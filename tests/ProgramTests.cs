using Xunit;
using SmartLightMusicLab4;

namespace SmartLightMusicLab4.Tests
{
    public class ProgramTests
    {
        [Fact]
        public void Add_ReturnsCorrectSum()
        {
            var result = Program.Add(2, 3);
            Assert.Equal(5, result);
        }
    }
}

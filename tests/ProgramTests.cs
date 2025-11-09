using Xunit;

namespace SmartLightMusicLab4.Tests
{
    public class ProgramTests
    {
        [Fact]
        public void Add_ReturnsCorrectSum()
        {
            int result = SmartLightMusicLab4.Program.Add(2, 3);
            Assert.Equal(5, result);
        }
    }
}

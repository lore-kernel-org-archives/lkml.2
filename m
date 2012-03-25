Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab2CYOzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 10:55:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55193 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab2CYOzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 10:55:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL 0/9] arm-soc updates, first batch
Date: Sun, 25 Mar 2012 14:55:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org
References: <1332626568-17812-1-git-send-email-arnd@arndb.de> <20120325105054.GD5611@n2100.arm.linux.org.uk>
In-Reply-To: <20120325105054.GD5611@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201203251455.43473.arnd@arndb.de>
X-Provags-ID: V02:K0:TAOLd8Aq2vuRQG5WrwEWULhPEprYg/5pYz7E/SZBbBg
 f1G+lbtl7n79NE9Rg1GdZp4CuvHxzeyEQAsF6vTzfe56M7/nH0
 aW3RGj4xRHRjd+1LpankIZfn8CZd0qtV3FpGVSl4RUkEGBsUcY
 q8Fpz2UTQPfgDC2adpmr0CW8dX/k/3BOies8YwCdqhAeurE38q
 nK+obTrKiaun6+mxxVdHsa0zergpy9TcQpbngyJldxFLFaWIa6
 srxQgELW+S3mSRbS0K+4KqTvDcnKLNKiJrWwEOO9hGxXOHBq81
 h4GkVFRWbz6wuelA2uMxEqoei2FqCWQaBecvfQkN/MNXZWE53i
 oo9ryg0utQU8tsetAo/o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 March 2012, Russell King - ARM Linux wrote:
> Arnd, I assume this shortlog is for the entire arm-soc queue rather than
> this set of 9 pull requests?  If so fine.
> 
> If not, I couldn't find Rob's IO stuff in this set of 9 pulls - at the
> moment because PXA currently fails to build because of that, and there's
> a couple of patches on the list from Rob sent on the 20th to solve that.
> However, Rob hasn't sent them to you yet.  I've already prodded over them
> to try and find out what's happening.

Yes, that's right. My script was comparing the wrong versions here.

See below for the actual shortlog of the current set of pull requests.

	Arnd

---

Aaro Koskinen (1):
      ARM: OMAP: add minimal support for Nokia RM-696

Afzal Mohammed (1):
      ARM: OMAP2+: id: Add am33xx SoC type detection

Alex (1):
      ARM: OMAP: Add omap_reserve functionality

Alex Gershgorin (1):
      i.MX35-PDK: Add Camera support

Amit Daniel Kachhap (5):
      ARM: EXYNOS: Add support AFTR mode on EXYNOS4210
      ARM: S5P: add L2 early resume code
      ARM: EXYNOS: save L2 settings during bootup
      ARM: EXYNOS: remove useless code to save/restore L2
      ARM: EXYNOS: Enable l2 configuration through device tree

Andrew Lunn (2):
      ARM: orion: spi: remove enable_clock_fix which is not used
      ARM: Kirkwood: Remove tclk from kirkwood_asoc_platform_data.

Andrzej Pietrasiewicz (3):
      ARM: EXYNOS: add support JPEG
      ARM: EXYNOS: Register JPEG on universal_c210
      ARM: EXYNOS: Register JPEG on nuri

Arnd Bergmann (122):
      Merge branch 'v3.4-next/devel-samsung-rtc' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'depends/driver-core' into next/soc2
      Merge branch 'ux500/soc' into next/soc2
      Merge branch 'lpc32xx/drivers' into next/drivers
      Merge tag 'rpmsg-for-3.4' of git://git.kernel.org/.../ohad/remoteproc into next/rpmsg
      Merge branch 'vexpress-dt-v3.3-rc4' of git://git.linaro.org/people/pawelmoll/linux into next/dt
      Merge branch 'features/cs89x0' of git://git.pengutronix.de/git/imx/linux-2.6 into next/drivers
      Merge branch 'imx-fixes' of git://git.pengutronix.de/git/imx/linux-2.6 into next/fixes-non-critical
      Merge branch 'imx-cleanup' of git://git.pengutronix.de/git/imx/linux-2.6 into next/cleanup
      Merge branch 'imx-drivers' of git://git.pengutronix.de/git/imx/linux-2.6 into next/drivers
      Merge branch 'v3.4/fixes' of git://gitorious.org/linux-davinci/linux-davinci into next/fixes-non-critical
      ARM: davinci: add back dummy header files
      Merge branch 'davinci/cleanups' into next/cleanup
      Merge branch 'kirkwood/board' into next/boards
      Merge branch 'lpc32xx/fixes-non-critical' of git://git.antcom.de/linux-2.6 into next/fixes-non-critical
      Merge branch 'mxs/gpmi' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/drivers
      Merge branch 'imx/driver' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/drivers
      Merge branch 'imx/dt' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge branch 'imx/defconfig' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge branch 'rtc-sa1100' of git://github.com/hzhuang1/linux into next/drivers
      Merge branch 'cleanup-3.4' of git://github.com/hzhuang1/linux into next/cleanup
      Merge branch 'board-specific' of git://github.com/hzhuang1/linux into next/boards
      Merge branch 'at91-3.4-base2+cleanup' of git://github.com/at91linux/linux-at91 into at91/staging/base2+cleanup
      ARM: ux500: U8500 depends on MMU
      ARM: ux500: add board autoselection
      ARM: ux500: select L2X0 cache on ux500
      ARM: ux500: select CPU_FREQ_TABLE where needed
      Merge branch 'fixes-non-critical' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge branch 'soc' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge branch 'omap1' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge branch 'dt' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge branch 'cleanup' of git://git.kernel.org/.../tmlind/linux-omap into omap/cleanup
      Merge branch 'cleanup' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'depends/omap/gpio/runtime-pm-cleanup' into next/cleanup
      Merge branches 'depends/irqdomain' and 'at91/base2+cleanup' into next/dt
      Merge branch 'at91-3.4-cleanup2+DT' of git://github.com/at91linux/linux-at91 into next/dt
      Merge branch 'features/imx27-visstrim' of git://git.pengutronix.de/git/imx/linux-2.6 into next/boards
      Merge branch 'features/imx27-dt' of git://git.pengutronix.de/git/imx/linux-2.6 into next/dt
      Merge branch 'features/imx31-moboard' of git://git.pengutronix.de/git/imx/linux-2.6 into next/boards
      Merge branch 'features/imx3' of git://git.pengutronix.de/git/imx/linux-2.6 into next/soc
      ARM: tegra: select CPU_FREQ_TABLE
      ARM: tegra: build localtimer support only when needed
      ARM: tegra: export usb phy symbols
      Merge tag 'tegra-cleanups' of git://git.kernel.org/.../olof/tegra into tegra/cleanups
      Merge tag 'tegra-cleanups' of git://git.kernel.org/.../olof/tegra into tegra/cleanups
      Merge tag 'tegra-dt' of git://git.kernel.org/.../olof/tegra into tegra/dt
      Merge tag 'tegra-soc' of git://git.kernel.org/.../olof/tegra into tegra/soc
      Merge tag 'tegra-soc-drivers' of git://git.kernel.org/.../olof/tegra into tegra/soc-drivers
      Merge tag 'tegra-soc2' of git://git.kernel.org/.../olof/tegra into tegra/soc2
      Merge tag 'tegra-boards' of git://git.kernel.org/.../olof/tegra into tegra/boards
      Merge branch 'depends/irqdomain' into next/drivers
      Merge branch 'ux500-fixes-20120301' of git://git.kernel.org/.../linusw/linux-stericsson into next/fixes-non-critical
      Merge branch 'ux500/timers' into next/timer
      Merge branch 'vexpress/timer' into next/timer
      Merge branch 'local_timers-for-arm-soc' of git://git.kernel.org/.../maz/arm-platforms into next/timer
      ARM: shmobile: remove additional __io() macro use
      Merge branch 'local_timers-for-arm-soc' of git://git.kernel.org/.../maz/arm-platforms into next/timer
      Merge tag 'imx25-iomux-ds' of git://git.pengutronix.de/git/imx/linux-2.6 into next/fixes-non-critical
      Merge branches 'lpc32xx/mach-lpc32xx-eth' and 'lpc32xx/mach-lpc32xx-usb' of git://git.antcom.de/linux-2.6 into lpc32xx/drivers
      Merge branch 'lpc32xx/drivers' into next/drivers
      Merge branch 'ep93xx-for-arm-soc' of git://github.com/RyanMallon/linux-2.6 into next/cleanup
      Merge branch 'fixes' of git://gitorious.org/linux-davinci/linux-davinci into next/fixes-non-critical
      Merge branch 'board-specific' of git://github.com/hzhuang1/linux into next/boards
      Merge branch 'fixes-non-critical' of git://github.com/hzhuang1/linux into next/maintainers
      Merge tag 'imx35-cam-fb' of git://git.pengutronix.de/git/imx/linux-2.6 into next/boards
      Merge branch 'renesas/fixes' into renesas/soc
      Merge branch 'renesas/soc' into next/soc
      Merge branch 'v3.4/features' of git://gitorious.org/linux-davinci/linux-davinci into next/drivers
      Merge branch 'next/soc-exynos5250-gpio' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'next/soc-exynos5250-arch' of git://git.kernel.org/.../kgene/linux-samsung into samsung/exynos5
      Merge branch 'for-armsoc' of http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/linux-2.6-arm into next/soc2
      Merge branch 'samsung/exynos5' into next/soc2
      Merge branch 'samsung/soc' into next/soc2
      Merge branch 'at91-3.4-cleanup2-DT2' of git://github.com/at91linux/linux-at91 into next/dt
      Merge branch 'at91-3.4-cleanup2-DT2+USB' of git://github.com/at91linux/linux-at91 into next/dt
      Merge branch 'ux500/soc' into ux500/dt
      Merge branch 'depends/driver-core' into ux500/dt
      ARM: ux500: Initial Device Tree support for Snowball
      ARM: ux500: combine the board init functions for DT boot
      ARM: ux500: split dts file for snowball into generic part
      Merge branch 'ux500/dt' into next/dt2
      Merge branch 'kirkwood_dt_for_3.4_v3' of git://git.infradead.org/users/jcooper/linux-kirkwood into kirkwood/dt
      Merge branch 'spear/dt' into next/dt2
      ARM: tegra: select USB_ULPI if USB is selected
      clk: make CONFIG_COMMON_CLK invisible
      Merge branch 'for-3.4/dt' of git://git.kernel.org/.../olof/tegra into next/dt2
      Merge branch 'for-3.4/cleanup-and-fixes' of git://git.kernel.org/.../olof/tegra into tegra/cleanups
      Merge branch 'tegra/cleanups' into next/cleanup2
      Merge branch 'for-3.4/boards' of git://git.kernel.org/.../olof/tegra into next/boards
      Merge branch 'fixes' into next/fixes-non-critical
      Merge branch 'renesas/timer' into next/timer
      Merge branch 'samsung/cleanup-exynos-clock' into next/soc
      Merge branch 'imx/defconfig' into next/drivers
      Merge branch 'next/fixes-non-critical' into next/drivers
      Merge branch 'tegra/cleanups' into next/timer
      Merge branch 'for-3.4' of git://gitorious.org/linux-omap-dss2/linux into next/cleanup
      Merge tag 'regulator-3.4' of git://git.kernel.org/.../broonie/regulator into next/drivers
      Merge tag 'asoc-3.4' of git://git.kernel.org/.../broonie/sound into next/boards
      Merge branch 'omap/fixes-non-critical-part2' into next/cleanup
      Merge branch 'rmobile-fixes-for-linus' of git://github.com/pmundt/linux-sh into renesas/soc
      Merge branch 'renesas/soc' into next/soc2
      Merge branch 'kirkwood/dt' into next/dt2
      Merge branch 'depends/omap/gpio/runtime-pm-cleanup' into for-next
      Merge branch 'next/fixes-non-critical' into for-next
      Merge branch 'next/cleanup' into for-next
      Merge branch 'next/maintainers' into for-next
      Merge branch 'next/timer' into for-next
      Merge branch 'next/soc' into for-next
      Merge branch 'next/boards' into for-next
      Merge branch 'next/rpmsg' into for-next
      Merge branch 'next/drivers' into for-next
      Merge branch 'next/dt' into for-next
      Merge branch 'next/cleanup2' into for-next
      Merge branch 'next/drivers2' into for-next
      Merge branch 'next/clk' into for-next
      Merge branch 'next/soc2' into for-next
      Merge branch 'next/dt2' into for-next
      [arm-soc internal] add back contents file
      Merge tag 'fbdev-updates-for-3.4' of git://github.com/schandinat/linux-2.6 into omap/cleanup
      Merge branch 'omap/fixes-non-critical-part2' into omap/cleanup
      Merge branch 'omap/cleanup' into next/cleanup
      Merge branch 'next/cleanup' into for-next

Axel Lin (1):
      rpmsg: rename virtqueue_add_buf_gfp to virtqueue_add_buf

Benoit Cousson (14):
      arm/dts: OMAP: Remove bootargs node from board files
      ARM: OMAP2+: kconfig: Enable devicetree by default for OMAP2+ systems
      ARM: OMAP2+: board-generic: Remove un-needed .atag_offset for DT_MACHINE
      ARM: OMAP2+: omap_device: Replace dev_warn by dev_dbg in omap_device_build_from_dt
      ARM: OMAP2+: pm: Do not init statically the SR and voltage layer with DT
      ARM: OMAP1: kconfig: Enable IRQ_DOMAIN by default for OMAP1 platforms
      arm/dts: OMAP3&4: Remove the '0x' prefix for serial nodes
      arm/dts: OMAP4: Add i2c controller nodes
      arm/dts: OMAP3: Add i2c controller nodes
      arm/dts: OMAP4: Update DTS file with new GIC bindings
      Merge branch 'irqdomain/next' of git://git.secretlab.ca/git/linux-2.6 into for_3.4/dt_irq_domain2
      ARM: OMAP2/3: intc: Add DT support for TI interrupt controller
      arm/dts: OMAP3: Add interrupt-controller bindings for INTC
      ARM: OMAP2+: board-generic: Use of_irq_init API

Bernhard Walle (1):
      ARM: OMAP2+: GPMC: Export gpmc_enable_hwecc and gpmc_calculate_ecc

Boojin Kim (2):
      ARM: EXYNOS: Enable MDMA driver
      ARM: EXYNOS: add support DMA for EXYNOS4X12 SoC

Changhwan Youn (1):
      ARM: EXYNOS: fix cycle count for periodic mode of clock event timers

Charulatha V (8):
      gpio/omap: remove dependency on gpio_bank_count
      gpio/omap: use flag to identify wakeup domain
      gpio/omap: make gpio_context part of gpio_bank structure
      gpio/omap: make non-wakeup GPIO part of pdata
      gpio/omap: avoid cpu checks during module ena/disable
      gpio/omap: use pinctrl offset instead of macro
      gpio/omap: remove bank->method & METHOD_* macros
      gpio/omap: fix bankwidth for OMAP7xx MPUIO

Dan Liang (2):
      ARM: at91/at91sam9x5: overall definition
      ARM: at91/at91sam9x5: SoC basic support

Daniel Lezcano (4):
      ARM: at91: coding style fixes
      ARM: at91: declare header name
      ARM: at91: remove wait_for_interrupt definition
      ARM: at91: implement the standby function for pm/cpuidle

Danny Kukawka (3):
      ARM: ux500: included linux/gpio.h twice
      ARM: OMAP: clock.c: included linux/debugfs.h twice
      ARM: OMAP2+: included some headers twice

Dirk Behme (1):
      ARM: imx6: Rename DEBUG_IMX6Q_UART to UART4

Dmitry Artamonow (3):
      arm/tegra: fix harmony pinmux for PCIe
      arm/tegra: add timeout to PCIe PLL lock detection loop
      arm/tegra: pcie: fix return value of function

Doug Anderson (2):
      ARM: tegra: Introduce define DEBUG_UART_SHIFT
      ARM: tegra: uncompress.h: Store UART address in a variable

Eunki Kim (1):
      ARM: EXYNOS: support EINT for EXYNOS4 and EXYNOS5

Fabio Estevam (16):
      ARM: mx28: Let audio support be built by default
      ARM: mx28: Remove duplicate OCOTP error message
      ARM: mx28evk: Simplify GPIO requests
      ARM: mxs: Use a proper timeout mechanism
      ARM: mach-pcm038: Fix field name of regulator_consumer_supply struct
      ARM: imx_v4_v5_defconfig: Fix the selection of 32 bit flash support for iMX21ADS board
      ARM: imx_v6_v7_defconfig: Add support for framebuffer and camera on mx31
      ARM: mx27_3ds: Add camera support
      ARM: imx_v4_v5_defconfig: Update defconfig
      ARM: plat-mxc: audmux-v1: Remove unneeded ifdef's
      ARM: mx3: Let mx31 and mx35 share the same CCM header file
      ARM: mach-imx: mx3: Fix section mismatch in imx3_init_l2x0()
      ARM: mx3: Let mx31 and mx35 enter in LPM mode in WFI
      ARM: mx3: Setup AIPS registers
      ARM: mx5: Use common function for configuring AIPS
      ARM: mx35: Setup the AIPS registers

Felipe Balbi (4):
      ARM: OMAP3+: SmartReflex: add missing platform_set_drvdata()
      ARM: OMAP3+: SmartReflex: move late_initcall() closer to its argument
      ARM: OMAP3+: SmartReflex: misc cleanups
      ARM: OMAP3+: SmartReflex: micro-optimization for sanity check

Felipe Contreras (1):
      ARM: OMAP: mailbox: trivial whitespace fix

Grazvydas Ignotas (2):
      ARM: OMAP: pandora: add support for backlight and poweroff
      ARM: omap: pandora: fix usbhs platform data

H Hartley Sweeten (1):
      ep93xx: Convert the watchdog driver into a platform device.

Haojian Zhuang (16):
      rtc: sa1100: remove periodic code
      rtc: sa1100: remove verification code of alarm
      rtc: sa1100: declare irq in resource
      ARM: pxa: add rtc dummy clock
      rtc: sa1100: enable clk support
      ARM: mmp: append irq name of gpio device
      ARM: pxa: add dummy clock for pxa25x and pxa27x
      ARM: mmp: enable rtc in pxa910
      rtc: sa1100: add OF support
      serial: pxa: add OF support
      i2c: pxa: add OF support
      ARM: mmp: enable rtc clk in pxa168
      ARM: mmp: append OF support on pxa168
      ARM: dts: append DTS file of pxa168
      Document: devicetree: add OF documents for arch-mmp
      MAINTAINERS: update MAINTAINERS email entry

Heiko Schocher (1):
      ARM: davinci: map default_queue to edma channels

Heiko Stuebner (21):
      ARM: S3C24XX: remove unused spi gpio setup functions
      ARM: S3C24XX: move spi-s3c24xx platdata out of mach
      ARM: S3C24XX: Remove extern declaration of clk_msysclk
      ARM: S3C24XX: move common S3C2443 clock definitions to clock.h
      ARM: S3C2410: move s3c2410_baseclk_add to clock.h
      ARM: SAMSUNG: cleanup of rtc register definitions
      rtc-s3c: make room for more variants in devicetree block
      rtc-s3c: add variants for S3C2443 and S3C2416
      ARM: S3C2443/S3C2416: add s3c_rtc_setname and rename rtc devices
      ARM: S3C24XX: Move s3c2443-clock.c to mach-s3c24xx
      ARM: S3C24XX: Move common-smdk code to mach directory
      ARM: S3C24XX: move simtec-specific code to mach directory
      ARM: S3C24XX: Consolidate Simtec extensions
      ARM: S3C24XX: Move device setup files to mach directory
      ARM: S3C24XX: Fix indentation of dma-s3c2443
      ARM: S3C24XX: Reuse S3C2443 dma for S3C2416
      ARM: S3C24XX: remove obsolete S3C2416_DMA option
      ARM: S3C24XX: remove XXX_setup_clocks method from S3C2443
      ARM: S3C24XX: add get_rate for clk_h on S3C2416/2443
      ARM: S3C24XX: add get_rate for clk_p on S3C2416/2443
      ARM: S3C24XX: remove call to s3c24xx_setup_clocks

Heiko Stübner (2):
      pxa: magician/hx4700: Convert to gpio-regulator from bq24022
      regulator: Remove bq24022 regulator driver

Hong Xu (1):
      ARM: at91: Update struct atmel_nand_data to support PMECC

Huang Shijie (1):
      ARM: mxs: add GPMI-NAND support for imx23/imx28

Igor Grinberg (1):
      ARM: OMAP3: cm-t3517: add EMAC support

Ilya Yanok (3):
      ARM: OMAP: move generic EMAC init to separate file
      arm/dts: mt_ventoux: very basic support for TeeJet Mt.Ventoux board
      ARM: OMAP2+: ads7846_init: put gpio_pendown into pdata if it's provided

Jaccon Bastiaansen (4):
      CS89x0 : add platform driver support
      CS89x0 : add CS89x0 platform device to the iMX21ADS board
      CS89x0 : remove QQ2440 board support from the CS89x0 driver
      CS89x0 : add CS89x0 platform device to the iMX31ADS board

Jaecheol Lee (1):
      ARM: EXYNOS: add clock registers for exynos4x12-cpufreq

Jaehoon Chung (3):
      ARM: SAMSUNG: support the second capability for samsung-soc
      mmc: sdhci-s3c: add platform data for the second capability
      ARM: SAMSUNG: change the name from s3c-sdhci to exynos4-sdhci

Janusz Krzysztofik (12):
      ARM: OMAP1: ams-delta: register latch dependent devices later
      ARM: OMAP1: ams-delta: convert latches to basic_mmio_gpio
      ARM: OMAP1: ams-delta: supersede custom led device by leds-gpio
      LED: drop leds-ams-delta driver
      MTD: NAND: ams-delta: use GPIO instead of custom I/O
      omapfb: lcd_ams_delta: drive control lines over GPIO
      input: serio: ams-delta: toggle keyboard power over GPIO
      ARM: OMAP1: ams-delta: fix incorrect section tags
      ARM: OMAP1: ams-delta: clean up init data section assignments
      ARM: OMAP1: ams-delta: set up regulator over modem reset GPIO pin
      ARM: OMAP1: ams-delta: update the modem to use regulator API
      ASoC: OMAP: ams-delta: drop .set_bias_level callback

Jarkko Nikula (1):
      ARM: OMAP: McSPI: Remove unused flag from struct omap2_mcspi_device_config

Jason Cooper (9):
      ARM: kirkwood: add dreamplug (fdt) support.
      ARM: kirkwood: convert uart0 to devicetree.
      ARM: orion: wdt: use resource vice direct access
      ARM: kirkwood: fdt: use mrvl ticker symbol
      ARM: kirkwood: fdt: absorb kirkwood_init()
      ARM: kirkwood: fdt: facilitate new boards during fdt migration
      ARM: kirkwood: fdt: define uart[01] as disabled, enable uart0
      ARM: kirkwood: rtc-mv devicetree bindings
      ARM: kirkwood: use devicetree for rtc-mv

Javier Martin (5):
      i.MX27: visstrim_m10: Add m41t00 RTC support.
      i.MX27: visstrim_m10: Sort IMX_HAVE_PLATFORM_MXC_MMC properly.
      i.MX27: visstrim_m10: Register I2C devices after I2C busses have been added.
      i.MX27: visstrim_m10: Add video support.
      i.MX27: visstrim_m10: Add led support.

Jean Pihet (3):
      ARM: OMAP3+: SmartReflex: fix the use of debugfs_create_* API
      ARM: OMAP3+: SmartReflex: fix error handling
      ARM: OMAP2+: PM debug: fix the use of debugfs_create_* API

Jean-Christophe PLAGNIOL-VILLARD (50):
      ARM: at91: code removal of CAP9 SoC
      ARM: at91: factorise duplicated at91sam9 idle
      ARM: at91/at91x40: remove use of at91_sys_read/write
      ARM: at91: make matrix register base soc independent
      ARM: at91: make ST (System Timer) soc independent
      ARM: at91/pm_slowclock: rename register to named define
      ARM: at91/pm_slowclock: function slow_clock() accepts parameters
      ARM: at91: move at91rm9200 sdramc defines to at91rm9200_sdramc.h
      ARM: at91: make sdram/ddr register base soc independent
      ARM: at91/pm_slowclock: add runtime detection of memory contoller
      ARM: at91/PMC: make register base soc independent
      ARM: at91/rtc-at91sam9: each SoC can select the RTT device to use
      ARM: at91:rtc/rtc-at91sam9: ioremap register bank
      ARM: at91/rtc-at91sam9: pass the GPBR to use via resources
      ARM: at91: finally drop at91_sys_read/write
      ARM: at91: merge SRAM Memory banks thanks to mirroring
      Atmel: move console default platform_device to serial driver
      ARM: at91/board-dt: drop default console
      ARM: at91: properly sort dtb files in Makefile.boot
      ARM: at91: pit add DT support
      ARM: at91: usb_a9g20/dt: add leds support
      ARM: at91: at91sam9m10g45ek/dt: add leds support
      ARM: at91: at91sam9m10g45ek/dt: add gpio-keys support
      ARM: at91: usb_a9g20/dt: add gpio-keys support
      ARM: at91: at91sam9x5cm/dt: add leds support
      ATMEL: fix nand ecc support
      mtd/atmel_nand: add on_flash_bbt to enable the use of On Flash BBT
      ARM: at91: enable on flash bbt for Atmel Reference and DT boards
      of: introduce helper to manage boolean
      of/mtd/nand: add generic bindings and helpers
      atmel/nand: add DT support
      ARM: at91: sam9x5 add nand support
      i2c/gpio: add DT support
      ARM: at91: sam9g20 add i2c DT support
      ARM: at91: usb_a9g20 add DT i2c support
      ARM: at91: sam9g45 add i2c DT support
      ARM: at91: sam9x5 add i2c DT support
      ARM: at91/dt: add Calao DAB-MMX daugther board support for USB-A9G20
      ARM: at91/dt: add specific DT soc init
      ARM: at91: add pmc DT support
      ARM: at91: always enable sam9 restart
      ARM: at91: add RSTC (Reset Controller) dt support
      ARM: at91: add ram controller DT support
      ARM: at91: add Shutdown Controller (SHDWC) DT support
      ARM: at91: usb ohci add dt support
      ARM: at91: dt: enable usb ohci for sam9g20, sam9g45 amd sam9x5
      ARM: at91: usb ehci add dt support
      ARM: at91: dt: enable usb ehci for sam9g45 and sam9x5
      USB: at91: Device udc add dt support
      ARM: at91: sam9g20 udc add dt support

Jesper Juhl (1):
      ARM: Remove redundant ';' from avic_irq_set_priority()

Jett.Zhou (1):
      ARM: sa1100: clean up clock support

Jingoo Han (1):
      ARM: SAMSUNG: Add a callback 'notify_after' for PWM backlight control

Jon Hunter (1):
      ARM: OMAP: Remove definition cpu_is_omap4430()

Joonyoung Shim (2):
      ARM: S3C64XX: Add usb otg phy control
      ARM: S5PV210: Add usb otg phy control

Josh Wu (2):
      ARM: at91: add clock selection parameter for at91_add_device_isi()
      ARM: at91: add Atmel ISI and ov2640 support on sam9m10g45 board

Kamil Debski (3):
      ARM: EXYNOS: add G2D to mach-nuri
      ARM: EXYNOS: add G2D to mach-universal
      ARM: SAMSUNG: add G2D to plat-s5p and mach-exynos

Kevin Hilman (6):
      ARM: OMAP: convert omap_device_build() and callers to __init
      Merge remote-tracking branch 'omap/hsmmc' into for_3.4/cleanup/pm-base
      ARM: OMAP: omap_device: remove omap_device_parent
      ARM: OMAP2+: PM: fix section mismatch with omap2_init_processor_devices()
      ARM: OMAP2+: PM: fix wakeupgen warning when hotplug disabled
      ARM: OMAP2+: gpmc-smsc911x: only register regulator for first instance

Kukjin Kim (32):
      ARM: EXYNOS: use static declaration when it is not used in other files
      ARM: S3C24XX: use static declaration when it is not used in other files
      ARM: S3C64XX: use static declaration when it is not used in other files
      ARM: S5P64X0: use static declaration when it is not used in other files
      ARM: S5PC100: use static declaration when it is not used in other files
      ARM: S5PV210: use static declaration when it is not used in other files
      ARM: SAMSUNG: use static declaration when it is not used in other files
      ARM: S3C24XX: change the ARCH_S3C2410 to ARCH_S3C24XX
      ARM: S3C2410: move mach-s3c2410/* into mach-s3c24xx/
      ARM: S3C2412: move mach-s3c2412/* into mach-s3c24xx/
      ARM: S3C2416: move mach-s3c2416/* into mach-s3c24xx/
      ARM: S3C2440: move mach-s3c2440/* into mach-s3c24xx/
      ARM: S3C2443: move mach-s3c2443/* into mach-s3c24xx/
      ARM: s3c2410_defconfig: update s3c2410_defconfig
      Merge branch 'topic/cleanup-s3c24xx' into next/cleanup-s3c24xx
      Merge branch 'topic/cleanup-use-static' into next/cleanup-use-static
      Merge branch 'next/cleanup-use-static' into next/cleanup-exynos-clock
      ARM: EXYNOS: replace clock.c for other new EXYNOS SoCs
      ARM: EXYNOS: use static declaration on regarding clock
      ARM: EXYNOS: change the prefix S5P_ to EXYNOS4_ for clock
      PM / devfreq: update the name of EXYNOS clock register
      ARM: EXYNOS: to declare static for mach-exynos/common.c
      ARM: EXYNOS: use exynos_init_uarts() instead of exynos4_init_uarts()
      ARM: EXYNOS: add clock part for EXYNOS5250 SoC
      ARM: EXYNOS: add initial setup-i2c0 for EXYNOS5
      ARM: EXYNOS: add support uart for EXYNOS4 and EXYNOS5
      ARM: EXYNOS: add support for EXYNOS5250 SoC
      ARM: EXYNOS: add interrupt definitions for EXYNOS5250
      ARM: EXYNOS: add support get_core_count() for EXYNOS5250
      ARM: EXYNOS: add support ARCH_EXYNOS5 for EXYNOS5 SoCs
      ARM: EXYNOS: add support device tree enabled board file for EXYNOS5
      ARM: dts: add initial dts file for EXYNOS5250, SMDK5250

Kuninori Morimoto (1):
      ARM: mach-shmobile: ap4evb: Reserve DMA memory for the frame buffer

Lauri Hintsala (1):
      ARM: mxs: Add initial support for Bluegiga APX4 Development Kit

Laxman Dewangan (2):
      ARM: tegra: Pause DMA when reading transfer count
      ARM: tegra: dma: not required to move requestor when stopping.

Lee Jones (11):
      ARM: ux500: pass parent pointer to each platform device
      ARM: ux500: export System-on-Chip information ux500 via sysfs
      ARM: ux500: move top level platform devices in sysfs to /sys/devices/socX
      ARM: ux500: remove intermediary add_platform_device* functions
      ARM: ux500: CONFIG: Enable Device Tree support for future endeavours
      ARM: ux500: db8500: list most devices in the snowball device tree
      ARM: ux500: Enable Cortex-A9 GIC (Generic Interrupt Controller) in Device Tree
      ARM: ux500: Enable PL011 AMBA UART Controller for Device Tree
      ARM: ux500: Enable PL310 Level 2 Cache Controller in Device Tree
      ARM: ux500: Enable PL022 SSP Controller in Device Tree
      ARM: ux500: Provide local timer support for Device Tree

Leon Romanovsky (3):
      ARM: dt: tegra: Enable device tree audio codec on PAZ00 board.
      ARM: dt: tegra: Enable headset autodetection on PAZ00 board.
      ASoC: DT: Add digital microphone binding to PAZ00 board.

Linus Walleij (5):
      ARM: plat-nomadik: get rid of global mtu base pointer
      ARM: plat-nomadik: handle clocking properly
      ARM: plat-nomadik: modernize MTU timer
      ARM: ux500: delete TPS6105X selection
      ARM: ux500: solve some Kconfig mess

Lothar Waßmann (1):
      arm/mxs: Add support for SSP/MMC ports 2 & 3

Magnus Damm (35):
      sh: introduce sh_clk_ops in parallel with clk_ops
      sh: convert cpg code to sh_clk_ops
      ARM: mach-shmobile: sh7367 sh_clk_ops rename
      ARM: mach-shmobile: sh7377 sh_clk_ops rename
      ARM: mach-shmobile: sh7372 sh_clk_ops rename
      ARM: mach-shmobile: sh73a0 sh_clk_ops rename
      ARM: mach-shmobile: r8a7740 sh_clk_ops rename
      ARM: mach-shmobile: r8a7779 sh_clk_ops rename
      sh: sh header sh_clk_ops rename
      sh: sh2 sh_clk_ops rename
      sh: sh2a sh_clk_ops rename
      sh: sh3 sh_clk_ops rename
      sh: sh4 sh_clk_ops rename
      sh: sh4a sh_clk_ops rename
      sh: sh5 sh_clk_ops rename
      sh: board sh_clk_ops rename
      sh: remove clk_ops
      ARM: mach-shmobile: sh7367 map_io and init_early update
      ARM: mach-shmobile: sh7377 map_io and init_early update
      ARM: mach-shmobile: sh7372 map_io and init_early update
      ARM: mach-shmobile: sh73a0 map_io and init_early update
      ARM: mach-shmobile: r8a7740 map_io and init_early update
      ARM: mach-shmobile: r8a7779 map_io and init_early update
      ARM: mach-shmobile: r8a7779 L2 cache support
      ARM: mach-shmobile: rename clk_init() to shmobile_clk_init()
      ARM: mach-shmobile: Move sh7372 Mackerel external clk setup
      ARM: mach-shmobile: Move sh7372 AP4EVB external clk setup
      ARM: mach-shmobile: add shmobile_earlytimer_init()
      ARM: mach-shmobile: sh7367 and G3EVM timer rework
      ARM: mach-shmobile: sh7377 and G4EVM timer rework
      ARM: mach-shmobile: sh7372, AP4EVB and Mackerel timer rework
      ARM: mach-shmobile: sh73a0, AG5EVM and Kota2 timer rework
      ARM: mach-shmobile: r8a7740 and Bonito timer rework
      ARM: mach-shmobile: r8a7779 and Marzen timer rework
      ARM: mach-shmobile: default to no earlytimer

Manjunath Hadli (10):
      ARM: davinci: dm644x: move private definitions to C file
      ARM: davinci: dm365: move private definitions to C file
      ARM: davinci: dm646x: move private definitions to C file
      ARM: davinci: create new common platform header for davinci
      ARM: davinci: streamline sysmod access
      ARM: davinci: dm644x: improve readability using macro
      ARM: davinci: dm644x: fix inconsistent variable naming
      ARM: davinci: dm644x: don't force vpfe registeration on all boards
      ARM: davinci: dm644x: add support for v4l2 video display
      ARM: davinci: dm644x evm: add support for VPBE display

Marc Dietrich (5):
      ARM: tegra: paz00: fix wrong SD1 power gpio
      ARM: tegra: paz00: fix wrong UART port on mini-pcie plug
      ARM: dt: tegra: add ADT7461 temperature sensor to paz00 device tree
      ARM: dt: tegra: add the power gpio key to paz00 device tree
      ARM: dt: tegra: add the wifi led to paz00 device tree

Marc Zyngier (16):
      ARM: smp_twd: make local_timer_stop a symbol instead of a #define
      ARM: local timers: introduce a new registration interface
      ARM: smp_twd: add runtime registration support
      ARM: smp_twd: add device tree support
      ARM: OMAP4: convert to twd_local_timer_register() interface
      ARM: plat-versatile: convert to twd_local_timer_register() interface
      ARM: tegra: convert to twd_local_timer_register() interface
      ARM: shmobile: convert to twd_local_timer_register() interface
      ARM: ux500: convert to twd_local_timer_register() interface
      ARM: highbank: convert to twd_local_timer_register() interface
      ARM: imx6q: convert to twd_local_timer_register() interface
      ARM: smp_twd: remove old local timer interface
      ARM: local timers: convert exynos to runtime registration interface
      ARM: local timers: convert MSM to runtime registration interface
      ARM: local timers: make the runtime registration interface mandatory
      ARM: ux500: fix compilation after local timer rework

Mark Asselstine (1):
      rpmsg: fix build warning when dma_addr_t is 64-bit

Mark Brown (12):
      ARM: S3C64XX: Support GPIO LEDs on Cragganmore
      ARM: S3C64XX: Fix build of Cragganmore after SPI changes
      ARM: S3C64XX: Enable power management for disk on Cragganmore
      ARM: S3C64XX: Enable power management for WiFi on Cragganmore
      ARM: S3C64XX: Add hookup for Tomatin module on Cragganmore
      ARM: S3C64XX: Add basic cpuidle driver
      ARM: S3C64XX: Add a SPKVDD supply for CODECs on Cragganmore
      ARM: S3C64XX: Gate some more clocks by default
      ARM: S3C64XX: Reduce residency requirement for cpuidle WFI mode
      ARM: S3C64XX: Define some additional always off clocks
      ARM: S3C64XX: Add some more Cragganmore module IDs to the table
      ARM: S3C64XX: Supply platform data for SPI on Cragganmore

Mark Grosen (2):
      remoteproc: do not require an iommu
      remoteproc: avoid registering a virtio device if not supported

Masanari Iida (1):
      ARM: OMAP1: Fix typo in lcd_dma.c

Maxim Osipov (1):
      ARM: at91: Add external RTC for Flexibity board

Mehnert (1):
      iomux-mx25.h slew rate adjusted for LCD __LD pins

Mike Turquette (3):
      Documentation: common clk API
      clk: introduce the common clock framework
      clk: basic clock hardware types

Minho Ban (1):
      ARM: SAMSUNG: use spin_lock_irqsave() in clk_{enable,disable}

Mircea Gherzan (1):
      ARM: OMAP: enable Bluetooth on the PandaBoard

MyungJoo Ham (4):
      ARM: EXYNOS: Add DMC1, allow PPMU access for DMC
      PM / devfreq: update the name of EXYNOS clock registers that were omitted
      ARM: EXYNOS: Add clock register addresses for EXYNOS4X12 bus devfreq driver
      ARM: EXYNOS: support Exynos4210-bus Devfreq driver on Nuri board

NeilBrown (2):
      ARM: OMAP2+: UART: remove unused fields in omap_uart_state.
      ARM: OMAP2+: remove some orphan function declarations.

Nicolas Ferre (29):
      Merge remote-tracking branch 'armsoc/depends/rmk/for-armsoc' into at91-3.4-base
      ARM: at91/dma: remove platform data from DMA controller
      ARM: at91/dma: DMA controller registering with DT support
      ARM: at91/at91sam9x5: PMC header file
      ARM: at91/at91sam9x5: clock management for at91sam9x5 chip family
      ARM: at91/at91sam9x5: Configuration and Makefile
      ARM: at91/at91sam9x5: Device tree definition files
      Merge remote-tracking branch 'armsoc/at91/device-board' into at91-3.4-base2
      Merge remote-tracking branch 'armsoc/at91/9x5' into at91-3.4-base2
      ARM: at91/ST: remove not needed casts
      ARM: at91/PMC: move assignment out of printf
      ARM: at91: add at91sam9g25ek.dts in Makefile.boot
      Merge branch 'irqdomain/next' of git://git.secretlab.ca/git/linux-2.6
      ARM: at91/aic: add irq domain and device tree support
      ARM: at91/snapper9260: move gpio_to_irq out of structure initialization
      ARM/USB: at91/ohci-at91: remove the use of irq_to_gpio
      ARM: at91/gpio: change comments and one variable name
      ARM: at91/gpio: add irqdomain and DT support
      ARM: at91/gpio: non-DT builds do not have gpio_chip.of_node field
      ARM: at91/gpio: add .to_irq gpio_chip handler
      ARM: at91/gpio: remove the static specification of gpio_chip.base
      ARM: at91/board-dt: remove AIC irq domain from board file
      ARM: at91: AIC and GPIO IRQ device tree initialization
      ARM: at91/pit: add traces in case of error
      ARM: at91/tclib: take iomem size from resource
      ARM: at91/tc: add device tree support to atmel_tclib
      ARM: at91/tc/clocksource: Add 32 bit variant to Timer Counter
      ARM: at91: add sam9_smc.o to at91sam9x5 build
      ARM: at91/pio: add new PIO3 features

Nishanth Menon (10):
      gpio/omap: save and restore debounce registers
      gpio/omap: enable irq at the end of all configuration in restore
      gpio/omap: restore OE only after setting the output level
      gpio/omap: handle set_dataout reg capable IP on restore
      ARM: OMAP3+: SmartReflex: fix err interrupt disable sequence
      ARM: OMAP3+: SmartReflex Class3: disable errorgen before disable VP
      ARM: OMAP3+: SmartReflex: Add a shutdown hook
      ARM: OMAP3+: SmartReflex: Fix status masking in ERRCONFIG register
      ARM: OMAP3+: SmartReflex: clear ERRCONFIG_VPBOUNDINTST only on a need
      ARM: OMAP3+: hwmod: add SmartReflex IRQs

Ohad Ben-Cohen (30):
      remoteproc: add framework for controlling remote processors
      remoteproc: add debugfs entries
      remoteproc: create rpmsg virtio device
      remoteproc/omap: add a remoteproc driver for OMAP4
      rpmsg: add virtio-based remote processor messaging bus
      samples/rpmsg: add an rpmsg driver sample
      remoteproc: remove unused resource type
      remoteproc/omap: utilize module_platform_driver
      remoteproc: look for truncated firmware images
      remoteproc: add Kconfig menu
      rpmsg: add Kconfig menu
      ARM: OMAP: omap_device: Expose omap_device_{alloc, delete, register}
      remoteproc: depend on EXPERIMENTAL
      rpmsg: depend on EXPERIMENTAL
      remoteproc: don't use virtio's weak barriers
      remoteproc: bail out if firmware has different endianess
      remoteproc: s/big switch/lookup table/
      remoteproc: make sure we're parsing a 32bit firmware
      remoteproc/omap: two Kconfig fixes
      rpmsg: fix name service endpoint leak
      rpmsg: validate incoming message length before propagating
      rpmsg: fix published buffer length in rpmsg_recv_done
      ARM: OMAP: don't build hwspinlock in vain
      remoteproc: resource table overhaul
      remoteproc: remoteproc_rpmsg -> remoteproc_virtio
      remoteproc: safer boot/shutdown order
      remoteproc: remove the single rpmsg vdev limitation
      remoteproc/omap: remove the mbox_callback limitation
      remoteproc: remove the hardcoded vring alignment
      remoteproc: cleanup resource table parsing paths

Ola Lilja (3):
      ARM: ux500: Add placeholder for clk_set_parent
      ARM: ux500: Add DMA-channels for MSP
      ARM: ux500: Add audio-regulators

Olof Johansson (57):
      ARM: tegra: emc: device tree bindings
      ARM: tegra: seaboard: add EMC table to device tree
      ARM: tegra: Don't WARN_ON() for too early dma channel allocations
      ARM: tegra: use APB DMA for accessing APB devices
      ARM: tegra: fuse: use apbio dma for register access
      ARM: tegra: fuse: add functions to access chip revision
      ARM: tegra: fuse: add bct strapping reading
      ARM: tegra: emc: convert tegra2_emc to a platform driver
      ARM: tegra: emc: device tree support
      Merge branch 'ux500-timers' of git://git.kernel.org/.../linusw/linux-stericsson into ux500/timers
      Merge branch 'at91-3.4-base' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge branch 'at91-3.4-base+pm_cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge branch 'at91-3.4-base' of git://github.com/at91linux/linux-at91 into at91/base
      Merge branch 'at91-3.4-base+device_board' of git://github.com/at91linux/linux-at91 into at91/device-board
      Merge branch 'at91-3.4-base+pm_cleanup' of git://github.com/at91linux/linux-at91 into at91/pm_cleanup
      Merge branch 'at91-3.4-base+9x5' of git://github.com/at91linux/linux-at91 into at91/9x5
      Merge branch 'ux500-timers' of git://git.kernel.org/.../linusw/linux-stericsson into next/soc
      Merge branch 'mxs/clk' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge branch 'mxs/defconfig' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge branch 'at91-3.4-base+9x5' of git://github.com/at91linux/linux-at91 into next/soc
      Merge branch 'at91-3.4-base+device_board' of git://github.com/at91linux/linux-at91 into next/drivers
      Merge branch 'mxs/boards' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/boards
      Merge branch 'features/imx-clk-prepare' of git://git.pengutronix.de/git/imx/linux-2.6 into next/drivers
      Merge branch 'for-arm-soc' of git://sources.calxeda.com/kernel/linux into next/soc
      Merge branch 'for-3.4/soc' into for-3.4/t30-smp
      Merge branch 'for-3.4/soc-drivers' into for-3.4/t30-smp
      Merge branch 'depends/rmk/for-armsoc' into for-3.4/cleanup-and-fixes
      Merge branch 'cleanup' of git://git.kernel.org/.../tmlind/linux-omap into omap/cleanup
      Merge branch 'fixes-non-critical' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge branch 'cleanup' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'next/cleanup-use-static' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge branch 'maintainers' of git://gitorious.org/linux-davinci/linux-davinci into next/maintainers
      Merge branch 'fixes-non-critical-part2' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge tag 'rpmsg-fixes-and-more-for-3.4' of git://git.kernel.org/.../ohad/remoteproc into next/rpmsg
      Merge branch 'next/cleanup-s3c24xx' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'imx35-imx5-aips-setup' of git://git.pengutronix.de/git/imx/linux-2.6 into next/soc
      Merge branch 'dt' of git://github.com/hzhuang1/linux into next/dt
      Merge branch 'regulator' of git://github.com/hzhuang1/linux into next/drivers
      Merge branch 'rtc' of git://github.com/hzhuang1/linux into next/drivers
      Merge branch 'io-cleanup-for-3.4' of git://sources.calxeda.com/kernel/linux into next/cleanup2
      Merge branch 'fixes-non-critical-part3' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge branch 'ams-delta' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge branch 'cleanup-pm' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'uart' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'dt-part2' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge branch 'sr' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge branch 'board' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge branch 'next/devel-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge branch 'fix-smsc911x-regulator' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge branch 'next/cleanup-exynos-clock' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge branch 'next/board-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/boards
      Merge branch 'next/devel-samsung-mmc' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'next/devel-samsung-dma' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'next/devel-samsung-pd' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'soc' of git://git.kernel.org/.../rafael/renesas into next/soc
      Merge branch 'io-cleanup-for-3.4' of git://sources.calxeda.com/kernel/linux into next/cleanup2
      ARM: tegra: update main repo and add patchwork

Paul Parsons (6):
      pxa/hx4700: Correct StrataFlash block size discovery
      pxa/hx4700: Add ASIC3 LED support
      pxa/hx4700: Fix PXA_GPIO_IRQ_BASE/IRQ_NUM values
      ARM: pxa/hx4700: Remove unwanted request for GPIO105
      ARM: pxa/hx4700: Reduce sleep mode battery discharge by 35%
      pxa/hx4700: Remove pcmcia platform_device structure

Paul Walmsley (7):
      ARM: OMAP2+: I2C: always compile I2C reset code, even if I2C driver is not built
      ARM: OMAP2xxx: PM: remove obsolete timer disable code in the suspend path
      ARM: OMAP3: PM: remove superfluous calls to pwrdm_clear_all_prev_pwrst()
      ARM: OMAP2+: PM: clean up omap_set_pwrdm_state()
      ARM: OMAP2+: PM: share clkdms_setup() across OMAP2, 3, 4
      ARM: OMAP2+: omap_device: call all suspend, resume callbacks when OMAP_DEVICE_NO_IDLE_ON_SUSPEND is set
      ARM: OMAP2+: PM: share some suspend-related functions across OMAP2, 3, 4

Pawel Moll (8):
      ARM: vexpress: Get rid of MMIO_P2V
      ARM: versatile: Map local timers using Device Tree when possible
      ARM: vexpress: Use FDT data in platform SMP calls
      ARM: vexpress: Add Device Tree support
      ARM: vexpress: Motherboard RS1 memory map support
      ARM: vexpress: Add Device Tree for V2P-CA5s core tile
      ARM: vexpress: Add Device Tree for V2P-CA9 core tile
      ARM: vexpress: Add Device Tree for V2P-CA15 core tile (TC1 variant)

Peter De Schrijver (20):
      ARM: tegra: add support for tegra30 interrupts
      ARM: tegra: add support for new clock framework features
      ARM: tegra: implement basic tegra30 clock framework
      ARM: tegra: enable tegra30 clock framework
      ARM: tegra: initialize basic system clocks
      ARM: tegra: definitions for flow controller
      ARM: tegra: assembler code for LP3
      ARM: tegra: cpuidle driver for tegra
      ARM: tegra: Avoid compiling cpuidle code when not configured
      ARM: tegra: cleanup use of chipid register
      ARM: tegra: export Tegra chipid
      ARM: tegra: initialize Tegra chipid early
      ARM: tegra: functions to access the flowcontroller
      ARM: tegra: rework Tegra secondary CPU core bringup
      ARM: tegra: prepare powergate.c for multiple variants
      ARM: tegra: export tegra_powergate_is_powered()
      ARM: tegra: add support for Tegra30 powerdomains
      ARM: tegra: support for Tegra30 CPU powerdomains
      ARM: tegra: support for secondary cores on Tegra30
      ARM: tegra: Enable CPUIdle on Tegra20

Peter Ujfalusi (1):
      OMAP4: dma: Correct CPU version check for dma_common_ch_end

Philipp Zabel (1):
      MAINTAINERS: update maintainer entry for pxa/hx4700

Philippe Langlais (2):
      ARM: ux500: set ARCH_NR_GPIO to 355 on U8500 platforms
      ARM: ux500: fix around AB8500 GPIO macro name

Philippe Rétornaz (2):
      mx31moboard: update maintainer
      mx31moboard: Add watchdog support

Richard Zhao (15):
      ARM: mxc: time: add clk_prepare/clk_unprepare
      ARM: mxc: ahci: add clk_prepare/clk_unprepare
      ARM: mxc: pwm: add clk_prepare/clk_unprepare
      ARM: mxc: epit: add clk_prepare/clk_unprepare
      ARM: mxc: arch_reset: add clk_prepare/clk_unprepare
      ARM: mxc: audmux-v2: add clk_prepare/clk_unprepare
      ARM: pm-imx5: add clk_prepare/clk_unprepare
      ARM: mx31moboard: add clk_prepare/clk_unprepare
      serial: imx: add clk_prepare/clk_unprepare
      i2c: imx: add clk_prepare/clk_unprepare
      mmc: sdhci-esdhc-imx: add clk_prepare/clk_unprepare
      ARM: dts: imx6q-sabrelite: add 2p5v and 3p3v regulators
      ARM: dts: imx6q-sabrelite: add sgtl5000 audio codec
      ARM: mxc: make imx_dma_is_general_purpose more generic for sdma
      ARM: imx6q: add cko1 clock

Rob Herring (29):
      ARM: timer-sp: add sched_clock support
      ARM: highbank: enable sp804 based sched_clock
      ARM: highbank: remove unused memory.h
      Merge remote-tracking branch 'arm-soc/at91/base2+cleanup' into cleanup-base
      usb: ohci-pxa27x: add explicit include of hardware.h
      ARM: provide runtime hook for ioremap/iounmap
      ARM: imx: convert to common runtime ioremap hook
      ARM: msm: use runtime ioremap hook
      ARM: iop13xx: use runtime ioremap hook
      ARM: ixp4xx: use runtime ioremap hook
      ARM: ebsa110: use runtime ioremap hook
      ARM: remove compile time __arch_ioremap/__arch_iounmap
      ARM: iop13xx: move io.h externs to pci.h
      ARM: msm: clean-up mach/io.h
      [media] davinci: remove includes of mach/io.h
      ARM: davinci: remove unneeded mach/io.h include
      ARM: orion5x: clean-up mach/io.h
      ARM: tegra: clean-up mach/io.h
      ARM: ep93xx: clean-up mach/io.h
      ARM: at91: add explicit include of hardware.h to uncompressor
      ARM: dove: add explicit include of dove.h to addr-map.c
      ARM: clps711x: remove unneeded include of mach/io.h
      ARM: make mach/io.h include optional
      ARM: remove bunch of now unused mach/io.h files
      ARM: kill off __mem_pci
      ARM: fix ioremap/iounmap for !CONFIG_MMU
      ARM: iop13xx: fix missing declaration of iop13xx_init_early
      ARM: create a common IOMEM definition
      ARM: __io abuse cleanup

Roland Stigge (21):
      ARM: LPC32xx: Added lpc32xx_defconfig
      ARM: LPC32xx: clock.c: warning fix
      ARM: LPC32xx: clock.c: Fix mutex lock issues
      ARM: LPC32XX: Remove broken non-static declaration
      ARM: LPC32xx: clock.c: Missing header file
      ARM: LPC32xx: clock.c: jiffies wrapping
      ARM: LPC32xx: clock.c: Clock registration fixes
      ARM: LPC32xx: Added lpc32xx_defconfig
      ARM: LPC32xx: clock.c: warning fix
      ARM: LPC32xx: clock.c: Fix mutex lock issues
      ARM: LPC32XX: Remove broken non-static declaration
      ARM: LPC32xx: clock.c: Missing header file
      ARM: LPC32xx: clock.c: jiffies wrapping
      ARM: LPC32xx: clock.c: Clock registration fixes
      ARM: LPC32xx: ADC support for mach-lpc32xx
      ARM: LPC32xx: Fix missing and bad LPC32XX macros
      Merge branch 'lpc32xx/fixup' of git://git.kernel.org/.../arm/arm-soc into lpc32xx/tmp
      Merge branch 'lpc32xx/fixup2' of git://git.kernel.org/.../arm/arm-soc into lpc32xx/tmp
      Merge branch 'lpc32xx/drivers' of git://git.kernel.org/.../arm/arm-soc into lpc32xx/tmp
      ARM: LPC32xx: USB Support
      ARM: LPC32xx: Ethernet support

Ryan Mallon (10):
      ep93xx: Move PHYS_BASE defines to local SoC header file
      ep93xx: Don't use system controller defines in audio drivers
      ep93xx: Move GPIO defines to gpio-ep93xx.h
      ep93xx: Use ioremap for backlight driver
      ep93xx: Move peripheral defines to local SoC header
      ep93xx: Configure GPIO ports in core code
      ep93xx: Make syscon access functions private to SoC
      ep93xx: Move crunch code to mach-ep93xx directory
      ep93xx: Move EP93XX_SYSCON defines to SoC private header
      ep93xx: Remove unnecessary includes of ep93xx-regs.h

Sachin Kamat (15):
      ARM: EXYNOS: Enable G2D on ORIGEN
      ARM: S5PV210: Add missing FIMC media device to Aquila
      ARM: EXYNOS: Add missing FIMC media device to SMDKV310
      ARM: EXYNOS: Add missing FIMC media device to Origen
      ARM: EXYNOS: Hook up G2D PD to generic PD infrastructure
      ARM: EXYNOS: Hook up JPEG PD to generic PD infrastructure
      ARM: EXYNOS: Enable G2D on SMDKV310
      ARM: S5PV210: Enable MFC on SMDKV210
      ARM: S5PV210: Enable MFC on SMDKC110
      ARM: S5PV210: Enable FIMC on SMDKV210
      ARM: S5PV210: Enable FIMC on SMDKC110
      ARM: EXYNOS: Enable JPEG on SMDKV310
      ARM: EXYNOS: Enable JPEG on Origen
      ARM: S5PV210: Add JPEG board definition
      ARM: S5PV210: Enable JPEG on SMDKV210

Sangsu Park (3):
      ARM: EXYNOS: add support GPIO for EXYNOS5250
      gpio/samsung: add support GPIOlib for EXYNOS5250
      gpio/samsung: use ioremap() for EXYNOS4 GPIOlib

Sangwook Lee (1):
      ARM: EXYNOS: Enable Bluetooth on ORIGEN

Santosh Shilimkar (2):
      ARM: OMAP: fix section mismatch warning for omap4_hotplug_cpu()
      ARM: OMAP: Fix section mismatch warning for platform_cpu_die()

Sascha Hauer (4):
      ARM i.MX5/6: Add dt support for generic boards
      ARM i.MX27: Add devicetree support
      ARM i.MX: Add phytec phycore-i.MX27 (aka pcm038) devicetree support
      devicetree-bindings: Add documentation for i.MX generic boards

Sekhar Nori (2):
      MAINTAINERS: mark TI DaVinci list as "moderated"
      MAINTAINERS: add TI DaVinci git tree information

Shawn Guo (8):
      ARM: mxs: detect SoC by checking CHIPID register
      ARM: imx5: generate dtbs for imx5 boards
      ARM: dts: imx51-babbage: update mc13892 device
      ARM: dts: imx6q-arm2: add vmmc-supply for usdhc
      ARM: dts: imx6q-sabrelite: add vmmc-supply for usdhc
      MAINTAINERS: remove arch/arm/mach-mx*/ from IMX entry
      ARM: imx: update imx_v6_v7_defconfig
      ARM: defconfig: imx_v6_v7: build in REGULATOR_FIXED_VOLTAGE

Shweta Gulati (1):
      ARM: OMAP3+: SmartReflex: use voltage domain name in device attributes

Simon Glass (3):
      arm: tegra: dts: Support host/device selection and legacy mode
      arm: tegra: dts: Add legacy mode support to Tegra2x USB1 port
      arm: tegra: dts: Mark USB1 as an OTG port on Seaboard

Stefan Roese (1):
      ARM: SPEAr600: Add device-tree support to SPEAr600 boards

Stephen Warren (27):
      dt: tegra gpio: Flesh out binding documentation
      ARM: dt: tegra30.dtsi: Reformat gpio's interrupts property
      ARM: dt: tegra30.dtsi: Add extra GPIO interrupt
      ARM: dt: tegra: Add Tegra APB DMA device tree binding
      ARM: dt: tegra: Modify I2S nodes to match binding
      ARM: dt: tegra: Add labels for I2S controllers
      ARM: dt: tegra: Enable audio on WM8903 boards, disable others
      ARM: dt: Add binding for Tegra PMC
      ARM: tegra: Support Tegra30 in decompressor UART setup
      ARM: tegra: uncompress.h: Choose a UART at runtime
      ARM: tegra: Pass uncompress.h UART selection to DEBUG_LL
      ARM: tegra: Remove use of TEGRA_GPIO_TO_IRQ
      gpio: tegra: Dynamically allocate IRQ base, and support DT
      gpio: tegra: Parameterize the number of banks
      ARM: tegra: Fix EMC pdata initialization from registers
      ARM: tegra: Add a simple PMC driver
      ARM: tegra: Remove duplicate PMU interrupt inversion code
      gpio: tegra: Fix build issue due to irq_domain rework.
      ARM: dt: Add SD controller configuration to Tegra Cardhu
      ARM: tegra: Demote EMC clock inconsistency BUG to WARN
      ARM: tegra: select required CPU and L2 errata options
      ARM: tegra: uncompress.h: Don't depend on kernel headers
      ARM: tegra: match SoC name not board name in DT board files
      ARM: dt: Add ARM PMU to tegra*.dtsi
      ARM: dt: Explicitly configure all serial ports on Tegra Cardhu
      ARM: tegra: update defconfig
      MAINTAINERS: ARM: tegra: update Stephen's email address

Sylwester Nawrocki (4):
      ARM: EXYNOS: Increase virtual framebuffer size on Universal C210 board
      ARM: EXYNOS: Add support for S5K6AAFX image sensor on Universal C210 board
      ARM: SAMSUNG: Add support for S5K6AAFX camera on Nuri board
      ARM: SAMSUNG: Correct MIPI-CSIS io memory resource definition

Tarun Kanti DebBarma (14):
      gpio/omap: handle save/restore context in GPIO driver
      gpio/omap: further cleanup using wkup_en register
      gpio/omap: use level/edge detect reg offsets
      gpio/omap: remove hardcoded offsets in context save/restore
      gpio/omap: cleanup set_gpio_triggering function
      gpio/omap: cleanup omap_gpio_mod_init function
      gpio/omap: remove unnecessary bit-masking for read access
      gpio/omap: use pm-runtime framework
      gpio/omap: optimize suspend and resume functions
      gpio/omap: cleanup prepare_for_idle and resume_after_idle
      gpio/omap: fix debounce clock handling
      gpio/omap: fix incorrect access of debounce module
      gpio/omap: remove omap_gpio_save_context overhead
      ARM: OMAP: dmtimer: fix missing content/correction in low-power mode support

Thierry Reding (1):
      ARM: tegra: PCIe: Provide 3.3V supply voltage

Tony Lindgren (42):
      Merge branch 'omap1-part2' into omap1
      Merge branch 'soc-part2' into soc
      Merge branch 'for_3.4/dt_base' of git://git.kernel.org/.../bcousson/linux-omap-dt into dt
      ARM: OMAP2+: Split omap2_hsmmc_init() to properly support I2C GPIO pins
      ARM: OMAP2+: Set Kconfig dependencies for PROC_DEVICETREE
      ARM: OMAP2+: Fix Kconfig dependencies for USB_ARCH_HAS_EHCI
      ARM: OMAP2+: Fix OMAP_HDQ_BASE build error
      ARM: OMAP2+: Fix board_mux section type conflict when OMAP_MUX is not set
      ARM: OMAP2+: Fix zoom LCD backlight if TWL_CORE is not selected
      ARM: OMAP: Fix devexit for dma when CONFIG_HOTPLUG is not set
      ARM: OMAP2+: Fix multiple randconfig errors with SOC_OMAP and SOC_OMAP_NOOP
      ARM: OMAP2+: Fix devexit for smartreflex when CONFIG_HOTPLUG is not set
      ARM: OMAP2+: Drop DISPC L3 firewall code
      ARM: OMAP2+: Move SDRC related functions from io.h into local common.h
      ARM: OMAP: Move omap_init_consistent_dma_size() to local common.h
      ARM: OMAP1: Move 16xx GPIO system clock to platform init code
      ARM: OMAP1: Move most of plat/io.h into local iomap.h
      ARM: OMAP2+: Move most of plat/io.h into local iomap.h
      ARM: OMAP: Remove plat/io.h by splitting it into mach/io.h and mach/hardware.h
      ARM: OMAP2+: Limit omap_read/write usage to legacy USB drivers
      ARM: OMAP2+: Mark omap_hsmmc_init and omap_mux related functions as __init
      Merge branch 'for_3.4/dts_updates' of git://git.kernel.org/.../bcousson/linux-omap-dt into dt
      Merge branch 'iomap' into cleanup
      Merge branch 'randconfig' into fixes-non-critical
      Merge branch 'hsmmc' into fixes-non-critical
      ARM: OMAP2+: Fix L4_EMU_34XX_BASE error after iomap changes
      Merge branch 'for_3.4/dt_irq_domain' of git://git.kernel.org/.../bcousson/linux-omap-dt into dt-part2
      Merge branch 'omap1' into ams-delta
      ARM: OMAP2+: Fix build error when only ARCH_OMAP2/3 or 4 is selected
      ARM: OMAP2+: Remove extra ifdefs for board-generic
      Merge branch 'for_3.4/cleanup/sr' of git://git.kernel.org/.../khilman/linux-omap-pm into sr
      Revert "ARM: OMAP2+: Fix multiple randconfig errors with SOC_OMAP and SOC_OMAP_NOOP"
      ARM: OMAP1: Fix section mismatch for omap1_init_early()
      ARM: OMAP2+: Fix omap24xx_io_desc warning if SoC subtypes are not selected
      ARM: OMAP2: Fix section warning for n8x0 when CONFIG_MMC_OMAP is not set
      Merge branch 'for_3.4/cleanup/pm' of git://git.kernel.org/.../khilman/linux-omap-pm into cleanup-pm
      Merge branch 'for_3.4/cleanup/uart' of git://git.kernel.org/.../khilman/linux-omap-pm into uart
      ARM: OMAP: Remove remaining includes for mach/io.h
      ARM: OMAP2+: Fix build error after merge
      ARM: OMAP2+: Fix build issues with missing include of linux/bug.h
      ARM: OMAP2+: Fix section warnings for hsmmc_init_one
      ARM: OMAP2+: Fix build for omap4 only builds with missing include of linux/bug.h

Tushar Behera (7):
      ARM: SAMSUNG: Add __init attribute to samsung_bl_set()
      ARM: SAMSUNG: fix __init attribute on regarding s3c_set_platdata()
      ARM: EXYNOS: Add __init attribute to nuri_camera_init()
      ARM: EXYNOS: Add __init attribute to universal_camera_init()
      ARM: EXYNOS: Add apb_pclk clkdev entry for mdma1
      ARM: EXYNOS: Add clkdev lookup entry for lcd clock
      ARM: EXYNOS: Fix compilation error with mach-exynos4-dt board

Uwe Kleine-König (3):
      ARM: OMAP4: board-4430sdp: don't initialize value that is never used
      ARM: davinci: cpufreq: fix compiler warning
      ARM: davinci: DA850: move da850_register_pm to .init.text

Vaibhav Bedia (1):
      ARM: OMAP: sram: Add am33xx SRAM support (minimal)

Vaibhav Hiremath (3):
      ARM: OMAP2+: Make cpu_rev static global variable
      ARM: OMAP2+: split omap2/3/4_check_revision function
      arm/dts: Add support for TI OMAP3 EVM board

Vladimir Zapolskiy (1):
      ARM: OMAP3: RX-51: add explicit mux configuration of tsc2005 control gpios

Wolfram Sang (4):
      ARM: mx28: check for gated clocks when setting saif divider
      ARM: mxs: read correct values when setting up MAC
      arm: lpc32xx: phy3250: add rtc & touch device
      arm: lpc32xx: phy3250: add rtc & touch device

Yuan Jiangli (1):
      ARM: OMAP3+: PM: VP: fix integer truncation error

wu guoxing (1):
      ARM : mx35: 3ds-board: add framebuffer device


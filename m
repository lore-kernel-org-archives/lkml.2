Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab2LQG5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:57:00 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52096 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2LQG46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:56:58 -0500
Date: Sun, 16 Dec 2012 22:56:54 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 3.7-rc0
Message-ID: <20121217065654.GB25829@core.coreip.homeip.net>
References: <20121217062504.GC13300@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217062504.GC13300@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** The subject should read 3.8-rc0 of course ***

On Sun, Dec 16, 2012 at 10:25:04PM -0800, Dmitry Torokhov wrote:
> Hi Linus,
> 
> Please pull from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> or
> 	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
> 
> to receive updates for the input subsystem. As usual, there are a couple
> of new drivers, input core now supports managed input devices (devres),
> a slew of drivers now have device tree support and a bunch of fixes and
> cleanups.
> 
> There will be 2 conflicts: one in arch/arm/mach-ux500/board-mop500-stuib.c,
> and another in drivers/input/touchscreen/ti_tscadc.c (which was renamed
> into ti_am335x_tsc).
> 
> Thanks!
> 
> Changelog:
> ---------
> 
> Aaro Koskinen (2):
>       Input: i8042-io - fix up region handling on MIPS
>       Input: add Retu power button driver.
> 
> Alban Bedel (2):
>       Input: tca8418_keypad - add support for device tree bindings
>       Input: tca8418_keypad - add support for shared interrupt
> 
> Alexander Shiyan (2):
>       Input: remove Compaq iPAQ H3600 (Bitsy) touchscreen driver
>       Input: gpio-keys-polled - honor 'autorepeat' setting in platform data
> 
> Andreas Pretzsch (1):
>       Input: imx_keypad - only set enabled columns to open-drain
> 
> Andy Shevchenko (1):
>       Input: ALPS - print small buffers via %*ph
> 
> AnilKumar Ch (1):
>       Input: matrix-keypad - add device tree support
> 
> Ashish Jangam (1):
>       Input: add DA9055 Onkey driver
> 
> Bill Pemberton (6):
>       Input: serio - remove CONFIG_HOTPLUG ifdefs
>       Input: remove use of __devexit_p
>       Input: remove use of __devinitdata
>       Input: remove use of __devinitconst
>       Input: remove use of __devinit
>       Input: remove use of __devexit
> 
> Deepak Sikri (1):
>       Input: spear-keyboard - fix for balancing the enable_irq_wake
> 
> Diego Calleja (1):
>       Input: wacom - fix touch support for Bamboo Fun CTH-461
> 
> Dmitry Torokhov (15):
>       Input: arc_ps2 - switch to using managed resources
>       Input: fix sparse warning in multitouch code
>       Input: fix sparse warning in __input_release_device()
>       Input: introduce managed input devices (add devres support)
>       Input: marix-keymap - automatically allocate memory for keymap
>       OMAP: nokia770: remove custom implementation of ads7846_get_pendown_state
>       Input: stmpe-keypad - add support for Device Tree bindings
>       Input: gpio_keys - report initial state when opening the device
>       Input: tca8418_keypad - use a temporary variable for parent device
>       Input: tca8418_keypad - use dev_get_platdata() to retrieve platform data
>       Input: tca8418_keypad - move device ID tables closer to where they are used
>       Input: tca8418_keypad - increase severity of failures in probe()
>       Input: tca8418-keypad - switch to using managed resources
>       Input: gpio_keys - switch to using gpio_request_one()
>       Input: gpio_keys_polled - switch to using gpio_request_one()
> 
> Florian Fainelli (1):
>       Input: matrix-keymap - provide a proper module license
> 
> Guillermo A. Amaral (2):
>       Input: xpad - minor formatting fixes
>       Input: xpad - add a few new VID/PID combinations
> 
> Henrik Rydberg (1):
>       Input: document new members of struct input_dev
> 
> Javier Martin (1):
>       Input: qt2160 - fix qt2160_write() implementation
> 
> Jonas Aaberg (1):
>       Input: gpio_keys - disable hardware on suspend
> 
> Kees Cook (2):
>       Input: remove CONFIG_EXPERIMENTAL from keyboard drivers
>       Input: remove CONFIG_EXPERIMENTAL from miscellaneous drivers
> 
> Lee Jones (4):
>       ARM: ux500: Strip out duplicate touch screen platform information
>       Input: bu21013_ts - request regulator that actually exists
>       Input: bu21013_ts - move GPIO init and exit functions into the driver
>       Input: bu21013_ts - add support for Device Tree booting
> 
> Mark Brown (3):
>       Input: wm831x-ts - remove unneeded clearing of driver data
>       Input: wm831x-ts - convert to devm_kzalloc()
>       Input: wm831x-on - convert to devm_kzalloc()
> 
> Mischa Jonker (1):
>       Input: serio - add ARC PS/2 driver
> 
> Peter Popovec (1):
>       Input: walkera0701 - fix crash on startup
> 
> Peter Ujfalusi (1):
>       Input: twl4030-pwrbutton - switch to using TWL_MODULE_PM_MASTER define
> 
> Ping Cheng (4):
>       Input: wacom - clean up device type code
>       Input: wacom - add support for 2 new multi-touch tablets (0x100 and 0x101)
>       Input: wacom - simplify type check for newer V5 devices
>       Input: wacom - add support for a new MT device (0x4001)
> 
> Rolf Eike Beer (1):
>       Input: HIL - remove one goto
> 
> Sachin Kamat (1):
>       Input: samsung-keypad - switch to using managed resources
> 
> Sascha Hauer (1):
>       Input: pwm-beeper - add devicetree probing support
> 
> Shubhrajyoti D (1):
>       Input: as5011 - use C99-style structure initializators
> 
> Shubhrajyoti Datta (1):
>       Input: cy8ctmg110_ts - use C99-style structure initializators
> 
> Tomasz Figa (1):
>       Input: mms114 - add device tree bindings
> 
> Ulf Hansson (2):
>       Input: nomadik-ske-keypad - fixup use of clk
>       Input: nomadik-ske-keypad - start using the apb_pclk
> 
> Vipul Kumar Samar (3):
>       Input: stmpe-ts - initialize the phys field in input device
>       Input: stmpe-ts - add DT support for stmpe touchscreen
>       Input: spear-keyboard - add clk_{un}prepare() support
> 
> Viresh Kumar (3):
>       Input: spear-keyboard - switch to using managed resources
>       Input: stmpe-keyboard - switch to using managed resources
>       Input: stmpe-ts - switch to using managed resources
> 
> Wei Yongjun (1):
>       Input: edt-ft5x06 - convert to use simple_open()
> 
> Xiaotian Feng (1):
>       Input: HIL - do not call tasklet_disable right before tasklet_kill
> 
> 
> Diffstat:
> --------
> 
>  .../bindings/input/gpio-matrix-keypad.txt          |  46 ++
>  .../devicetree/bindings/input/pwm-beeper.txt       |   7 +
>  .../devicetree/bindings/input/stmpe-keypad.txt     |  39 ++
>  .../devicetree/bindings/input/tca8418_keypad.txt   |   8 +
>  .../bindings/input/touchscreen/mms114.txt          |  34 ++
>  .../bindings/input/touchscreen/stmpe.txt           |  43 ++
>  Documentation/hwmon/fam15h_power                   |   2 +-
>  MAINTAINERS                                        |   5 +-
>  Makefile                                           |   2 +-
>  arch/arm/mach-omap1/board-nokia770.c               |  14 +-
>  arch/arm/mach-ux500/board-mop500-stuib.c           |  93 +---
>  arch/arm/xen/hypercall.S                           |  14 +-
>  arch/frv/Kconfig                                   |   1 +
>  arch/frv/boot/Makefile                             |  10 +-
>  arch/frv/include/asm/unistd.h                      |   1 -
>  arch/frv/kernel/entry.S                            |  28 +-
>  arch/frv/kernel/process.c                          |   5 +-
>  arch/frv/mb93090-mb00/pci-dma-nommu.c              |   1 +
>  arch/x86/include/asm/xen/hypervisor.h              |   1 -
>  arch/x86/kvm/x86.c                                 |  60 +--
>  arch/x86/xen/mmu.c                                 |  21 +-
>  arch/xtensa/Kconfig                                |   2 +
>  arch/xtensa/include/asm/io.h                       |   4 +
>  arch/xtensa/include/asm/processor.h                |   4 +-
>  arch/xtensa/include/asm/syscall.h                  |   2 +-
>  arch/xtensa/include/asm/unistd.h                   |  15 +-
>  arch/xtensa/include/uapi/asm/unistd.h              |  16 +-
>  arch/xtensa/kernel/entry.S                         |  57 +--
>  arch/xtensa/kernel/process.c                       | 128 +++---
>  arch/xtensa/kernel/syscall.c                       |   7 +-
>  arch/xtensa/kernel/xtensa_ksyms.c                  |   1 -
>  block/Kconfig                                      |   2 +-
>  block/blk-cgroup.c                                 |  10 +
>  block/blk-core.c                                   |   3 +-
>  drivers/acpi/video.c                               |  11 +-
>  drivers/block/Kconfig                              |  15 +-
>  drivers/block/cciss.c                              |   1 -
>  drivers/block/floppy.c                             |  90 ++--
>  drivers/block/loop.c                               |  17 +-
>  drivers/block/mtip32xx/mtip32xx.c                  |  19 +-
>  drivers/block/mtip32xx/mtip32xx.h                  |   3 +
>  drivers/block/xen-blkback/common.h                 |   4 +-
>  drivers/block/xen-blkback/xenbus.c                 |   9 +-
>  drivers/cpufreq/powernow-k8.c                      |   2 +-
>  drivers/gpio/gpio-74x164.c                         |   2 +-
>  drivers/gpio/gpio-mvebu.c                          |   4 +-
>  drivers/gpio/gpio-omap.c                           |  35 ++
>  drivers/gpio/gpio-timberdale.c                     |   4 +-
>  drivers/gpio/gpiolib.c                             |  10 +-
>  drivers/gpu/drm/exynos/Kconfig                     |   2 +-
>  drivers/gpu/drm/exynos/exynos_drm_connector.c      |   1 +
>  drivers/gpu/drm/exynos/exynos_drm_encoder.c        |  33 +-
>  drivers/gpu/drm/exynos/exynos_mixer.c              |   2 +-
>  drivers/gpu/drm/i915/i915_dma.c                    |   3 +-
>  drivers/gpu/drm/i915/intel_crt.c                   |   2 +-
>  drivers/gpu/drm/i915/intel_overlay.c               |  14 +-
>  drivers/gpu/drm/i915/intel_panel.c                 |   2 +-
>  drivers/gpu/drm/i915/intel_sdvo.c                  |  62 ++-
>  drivers/gpu/drm/i915/intel_sdvo_regs.h             |   2 +
>  drivers/gpu/drm/nouveau/core/core/mm.c             |   9 +-
>  drivers/gpu/drm/nouveau/core/include/core/mm.h     |   1 -
>  drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c      |  10 +-
>  drivers/gpu/drm/nouveau/core/subdev/i2c/base.c     |   2 +-
>  drivers/gpu/drm/nouveau/nouveau_display.c          |  36 +-
>  drivers/gpu/drm/nouveau/nouveau_drm.c              |  36 +-
>  drivers/gpu/drm/nouveau/nouveau_drm.h              |   2 +
>  drivers/gpu/drm/nouveau/nouveau_irq.c              |  16 +-
>  drivers/gpu/drm/nouveau/nv04_dac.c                 |  16 +-
>  drivers/gpu/drm/nouveau/nv04_dfp.c                 |  14 +-
>  drivers/gpu/drm/nouveau/nv04_tv.c                  |   9 +-
>  drivers/gpu/drm/radeon/evergreen_cs.c              |   2 +-
>  drivers/gpu/drm/radeon/radeon_atpx_handler.c       |   4 +-
>  drivers/gpu/drm/radeon/radeon_connectors.c         |  28 +-
>  drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |  15 +-
>  drivers/gpu/drm/radeon/radeon_legacy_encoders.c    | 175 ++++++--
>  drivers/gpu/drm/udl/udl_drv.h                      |   2 +-
>  drivers/gpu/drm/udl/udl_fb.c                       |  12 +-
>  drivers/gpu/drm/udl/udl_transfer.c                 |   5 +-
>  drivers/hid/hid-apple.c                            |   6 +
>  drivers/hid/hid-core.c                             |   6 +
>  drivers/hid/hid-ids.h                              |   3 +
>  drivers/hid/hid-microsoft.c                        |  18 +-
>  drivers/hid/hid-multitouch.c                       |   5 +-
>  drivers/hwmon/fam15h_power.c                       |   4 +-
>  drivers/hwmon/gpio-fan.c                           |   2 +
>  drivers/i2c/Makefile                               |   1 +
>  drivers/i2c/busses/Kconfig                         |   1 -
>  drivers/i2c/busses/Makefile                        |   1 -
>  drivers/i2c/busses/i2c-i801.c                      |  11 +-
>  drivers/i2c/busses/i2c-mxs.c                       | 186 +-------
>  drivers/i2c/busses/i2c-nomadik.c                   |   9 +-
>  drivers/i2c/busses/i2c-tegra.c                     |   2 +-
>  drivers/i2c/{busses => }/i2c-stub.c                |  66 ++-
>  drivers/input/gameport/emu10k1-gp.c                |   6 +-
>  drivers/input/gameport/fm801-gp.c                  |   6 +-
>  drivers/input/input-mt.c                           |   2 +-
>  drivers/input/input.c                              | 181 ++++++--
>  drivers/input/joystick/as5011.c                    |  29 +-
>  drivers/input/joystick/maplecontrol.c              |   6 +-
>  drivers/input/joystick/walkera0701.c               |   7 +-
>  drivers/input/joystick/xpad.c                      |  33 +-
>  drivers/input/keyboard/Kconfig                     |   2 +-
>  drivers/input/keyboard/adp5520-keys.c              |   6 +-
>  drivers/input/keyboard/adp5588-keys.c              |  18 +-
>  drivers/input/keyboard/adp5589-keys.c              |  21 +-
>  drivers/input/keyboard/bf54x-keys.c                |   6 +-
>  drivers/input/keyboard/davinci_keyscan.c           |   4 +-
>  drivers/input/keyboard/ep93xx_keypad.c             |   6 +-
>  drivers/input/keyboard/gpio_keys.c                 |  90 ++--
>  drivers/input/keyboard/gpio_keys_polled.c          |  26 +-
>  drivers/input/keyboard/hilkbd.c                    |  10 +-
>  drivers/input/keyboard/imx_keypad.c                |   9 +-
>  drivers/input/keyboard/jornada680_kbd.c            |   6 +-
>  drivers/input/keyboard/jornada720_kbd.c            |   6 +-
>  drivers/input/keyboard/lm8323.c                    |   6 +-
>  drivers/input/keyboard/lm8333.c                    |   6 +-
>  drivers/input/keyboard/locomokbd.c                 |   8 +-
>  drivers/input/keyboard/lpc32xx-keys.c              |   8 +-
>  drivers/input/keyboard/matrix_keypad.c             | 129 ++++--
>  drivers/input/keyboard/max7359_keypad.c            |   6 +-
>  drivers/input/keyboard/mcs_touchkey.c              |   6 +-
>  drivers/input/keyboard/mpr121_touchkey.c           |  12 +-
>  drivers/input/keyboard/nomadik-ske-keypad.c        |  38 +-
>  drivers/input/keyboard/omap-keypad.c               |   6 +-
>  drivers/input/keyboard/omap4-keypad.c              |  10 +-
>  drivers/input/keyboard/opencores-kbd.c             |   6 +-
>  drivers/input/keyboard/pmic8xxx-keypad.c           |  10 +-
>  drivers/input/keyboard/pxa27x_keypad.c             |   6 +-
>  drivers/input/keyboard/pxa930_rotary.c             |   6 +-
>  drivers/input/keyboard/qt1070.c                    |   8 +-
>  drivers/input/keyboard/qt2160.c                    |  31 +-
>  drivers/input/keyboard/samsung-keypad.c            | 109 ++---
>  drivers/input/keyboard/sh_keysc.c                  |   6 +-
>  drivers/input/keyboard/spear-keyboard.c            |  98 ++---
>  drivers/input/keyboard/stmpe-keypad.c              | 142 +++---
>  drivers/input/keyboard/tc3589x-keypad.c            |   6 +-
>  drivers/input/keyboard/tca6416-keypad.c            |   8 +-
>  drivers/input/keyboard/tca8418_keypad.c            | 179 ++++----
>  drivers/input/keyboard/tegra-kbc.c                 |  16 +-
>  drivers/input/keyboard/tnetv107x-keypad.c          |   6 +-
>  drivers/input/keyboard/twl4030_keypad.c            |   8 +-
>  drivers/input/keyboard/w90p910_keypad.c            |   6 +-
>  drivers/input/matrix-keymap.c                      |  26 +-
>  drivers/input/misc/88pm80x_onkey.c                 |   6 +-
>  drivers/input/misc/88pm860x_onkey.c                |   6 +-
>  drivers/input/misc/Kconfig                         |  29 +-
>  drivers/input/misc/Makefile                        |   2 +
>  drivers/input/misc/ab8500-ponkey.c                 |   6 +-
>  drivers/input/misc/ad714x-i2c.c                    |   6 +-
>  drivers/input/misc/ad714x-spi.c                    |   6 +-
>  drivers/input/misc/adxl34x-i2c.c                   |   6 +-
>  drivers/input/misc/adxl34x-spi.c                   |   6 +-
>  drivers/input/misc/bfin_rotary.c                   |   6 +-
>  drivers/input/misc/bma150.c                        |  28 +-
>  drivers/input/misc/cma3000_d0x_i2c.c               |   6 +-
>  drivers/input/misc/cobalt_btns.c                   |   6 +-
>  drivers/input/misc/da9052_onkey.c                  |   6 +-
>  drivers/input/misc/da9055_onkey.c                  | 171 ++++++++
>  drivers/input/misc/dm355evm_keys.c                 |   6 +-
>  drivers/input/misc/gp2ap002a00f.c                  |   8 +-
>  drivers/input/misc/gpio_tilt_polled.c              |   6 +-
>  drivers/input/misc/ixp4xx-beeper.c                 |   6 +-
>  drivers/input/misc/kxtj9.c                         |  16 +-
>  drivers/input/misc/m68kspkr.c                      |   6 +-
>  drivers/input/misc/max8925_onkey.c                 |   6 +-
>  drivers/input/misc/max8997_haptic.c                |   6 +-
>  drivers/input/misc/mc13783-pwrbutton.c             |   6 +-
>  drivers/input/misc/mma8450.c                       |   6 +-
>  drivers/input/misc/mpu3050.c                       |   8 +-
>  drivers/input/misc/pcap_keys.c                     |   6 +-
>  drivers/input/misc/pcf50633-input.c                |   6 +-
>  drivers/input/misc/pcf8574_keypad.c                |   6 +-
>  drivers/input/misc/pcspkr.c                        |   6 +-
>  drivers/input/misc/pm8xxx-vibrator.c               |   6 +-
>  drivers/input/misc/pmic8xxx-pwrkey.c               |   6 +-
>  drivers/input/misc/pwm-beeper.c                    |  20 +-
>  drivers/input/misc/rb532_button.c                  |   6 +-
>  drivers/input/misc/retu-pwrbutton.c                |  99 +++++
>  drivers/input/misc/rotary_encoder.c                |   9 +-
>  drivers/input/misc/sgi_btns.c                      |   6 +-
>  drivers/input/misc/sparcspkr.c                     |  14 +-
>  drivers/input/misc/twl4030-pwrbutton.c             |   3 +-
>  drivers/input/misc/twl4030-vibra.c                 |   6 +-
>  drivers/input/misc/twl6040-vibra.c                 |   6 +-
>  drivers/input/misc/wistron_btns.c                  |  20 +-
>  drivers/input/misc/wm831x-on.c                     |  11 +-
>  drivers/input/misc/xen-kbdfront.c                  |   7 +-
>  drivers/input/mouse/alps.c                         |  10 +-
>  drivers/input/mouse/bcm5974.c                      |  21 +
>  drivers/input/mouse/gpio_mouse.c                   |   6 +-
>  drivers/input/mouse/maplemouse.c                   |   6 +-
>  drivers/input/mouse/navpoint.c                     |   6 +-
>  drivers/input/mouse/pxa930_trkball.c               |   6 +-
>  drivers/input/mouse/synaptics_i2c.c                |   6 +-
>  drivers/input/serio/Kconfig                        |   9 +
>  drivers/input/serio/Makefile                       |   1 +
>  drivers/input/serio/altera_ps2.c                   |   6 +-
>  drivers/input/serio/ambakmi.c                      |   6 +-
>  drivers/input/serio/arc_ps2.c                      | 274 ++++++++++++
>  drivers/input/serio/ct82c710.c                     |   6 +-
>  drivers/input/serio/gscps2.c                       |   6 +-
>  drivers/input/serio/hil_mlc.c                      |  13 +-
>  drivers/input/serio/i8042-io.h                     |   2 +-
>  drivers/input/serio/i8042-sparcio.h                |   6 +-
>  drivers/input/serio/i8042.c                        |   6 +-
>  drivers/input/serio/maceps2.c                      |   8 +-
>  drivers/input/serio/pcips2.c                       |   6 +-
>  drivers/input/serio/q40kbd.c                       |   6 +-
>  drivers/input/serio/rpckbd.c                       |   6 +-
>  drivers/input/serio/sa1111ps2.c                    |  12 +-
>  drivers/input/serio/serio.c                        |  11 -
>  drivers/input/serio/xilinx_ps2.c                   |   8 +-
>  drivers/input/tablet/wacom_sys.c                   |  58 ++-
>  drivers/input/tablet/wacom_wac.c                   |  32 +-
>  drivers/input/tablet/wacom_wac.h                   |   2 +
>  drivers/input/touchscreen/88pm860x-ts.c            |   8 +-
>  drivers/input/touchscreen/Kconfig                  |  12 -
>  drivers/input/touchscreen/Makefile                 |   1 -
>  drivers/input/touchscreen/ad7877.c                 |   6 +-
>  drivers/input/touchscreen/ad7879-i2c.c             |   6 +-
>  drivers/input/touchscreen/ad7879-spi.c             |   6 +-
>  drivers/input/touchscreen/ads7846.c                |  10 +-
>  drivers/input/touchscreen/atmel_mxt_ts.c           |   6 +-
>  drivers/input/touchscreen/atmel_tsadcc.c           |   6 +-
>  drivers/input/touchscreen/auo-pixcir-ts.c          |   8 +-
>  drivers/input/touchscreen/bu21013_ts.c             | 125 ++++--
>  drivers/input/touchscreen/cy8ctmg110_ts.c          |  19 +-
>  drivers/input/touchscreen/cyttsp_i2c.c             |   6 +-
>  drivers/input/touchscreen/cyttsp_spi.c             |   6 +-
>  drivers/input/touchscreen/da9034-ts.c              |   6 +-
>  drivers/input/touchscreen/da9052_tsi.c             |  10 +-
>  drivers/input/touchscreen/edt-ft5x06.c             |  28 +-
>  drivers/input/touchscreen/eeti_ts.c                |   6 +-
>  drivers/input/touchscreen/egalax_ts.c              |   8 +-
>  drivers/input/touchscreen/h3600_ts_input.c         | 479 ---------------------
>  drivers/input/touchscreen/htcpen.c                 |   6 +-
>  drivers/input/touchscreen/ili210x.c                |   6 +-
>  drivers/input/touchscreen/intel-mid-touch.c        |  14 +-
>  drivers/input/touchscreen/jornada720_ts.c          |   6 +-
>  drivers/input/touchscreen/lpc32xx_ts.c             |   6 +-
>  drivers/input/touchscreen/max11801_ts.c            |   8 +-
>  drivers/input/touchscreen/mc13783_ts.c             |   4 +-
>  drivers/input/touchscreen/mcs5000_ts.c             |   6 +-
>  drivers/input/touchscreen/mms114.c                 |  68 ++-
>  drivers/input/touchscreen/pcap_ts.c                |   6 +-
>  drivers/input/touchscreen/pixcir_i2c_ts.c          |   6 +-
>  drivers/input/touchscreen/s3c2410_ts.c             |   6 +-
>  drivers/input/touchscreen/st1232.c                 |   8 +-
>  drivers/input/touchscreen/stmpe-ts.c               | 133 +++---
>  drivers/input/touchscreen/ti_tscadc.c              |   2 +-
>  drivers/input/touchscreen/tnetv107x-ts.c           |   6 +-
>  drivers/input/touchscreen/tps6507x-ts.c            |   4 +-
>  drivers/input/touchscreen/tsc2005.c                |   8 +-
>  drivers/input/touchscreen/tsc2007.c                |   6 +-
>  drivers/input/touchscreen/ucb1400_ts.c             |   8 +-
>  drivers/input/touchscreen/w90p910_ts.c             |   6 +-
>  drivers/input/touchscreen/wacom_i2c.c              |   6 +-
>  drivers/input/touchscreen/wm831x-ts.c              |  12 +-
>  drivers/md/faulty.c                                |   5 +-
>  drivers/md/raid1.c                                 |   2 +-
>  drivers/md/raid10.c                                |  15 +-
>  drivers/mfd/stmpe.c                                |   2 +
>  drivers/net/bonding/bond_sysfs.c                   |   4 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c   | 158 +++++--
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  13 +-
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  10 -
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   3 +
>  drivers/net/ethernet/nxp/lpc_eth.c                 |   1 +
>  drivers/net/phy/mdio-bitbang.c                     |   1 +
>  drivers/net/vmxnet3/vmxnet3_drv.c                  |  65 ++-
>  drivers/net/vxlan.c                                |   2 +-
>  drivers/net/wireless/ath/ath9k/xmit.c              |  10 +-
>  drivers/net/wireless/rt2x00/rt2800lib.c            |   2 +-
>  drivers/scsi/qla2xxx/qla_mid.c                     |   3 +
>  drivers/scsi/qla2xxx/qla_target.c                  |  25 +-
>  drivers/scsi/qla2xxx/qla_target.h                  |   1 +
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |  77 +++-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.h                 |   2 +
>  drivers/target/iscsi/iscsi_target.c                |   4 +-
>  drivers/target/iscsi/iscsi_target_core.h           |   1 +
>  drivers/target/iscsi/iscsi_target_login.c          |   1 +
>  drivers/target/iscsi/iscsi_target_util.c           |  22 +-
>  drivers/target/iscsi/iscsi_target_util.h           |   1 +
>  drivers/target/target_core_configfs.c              |   3 +-
>  drivers/target/target_core_device.c                |  18 +-
>  drivers/target/target_core_sbc.c                   |  18 +
>  drivers/target/target_core_spc.c                   |   2 +
>  drivers/target/target_core_tmr.c                   |   6 +-
>  drivers/target/target_core_transport.c             |   1 -
>  drivers/thermal/exynos_thermal.c                   |   2 +-
>  drivers/thermal/rcar_thermal.c                     |   2 +-
>  drivers/video/xen-fbfront.c                        |   5 +-
>  drivers/xen/gntdev.c                               |  36 +-
>  drivers/xen/xenbus/xenbus_dev_frontend.c           |   2 +-
>  fs/bio.c                                           |   6 +-
>  fs/ceph/export.c                                   |   2 +
>  fs/ext4/ialloc.c                                   |  19 +-
>  fs/file.c                                          |   4 +-
>  fs/nfs/dns_resolve.c                               |   5 +-
>  fs/nfs/inode.c                                     |   5 +-
>  fs/nfs/internal.h                                  |   6 +-
>  fs/nfs/mount_clnt.c                                |   2 +-
>  fs/nfs/namespace.c                                 |  19 +-
>  fs/nfs/nfs4namespace.c                             |   3 +-
>  fs/nfs/nfs4proc.c                                  |  46 +-
>  fs/nfs/pnfs.c                                      |   4 +-
>  fs/nfs/super.c                                     |  51 ++-
>  fs/nfs/unlink.c                                    |   2 +-
>  include/linux/hashtable.h                          | 192 +++++++++
>  include/linux/input.h                              |  10 +-
>  include/linux/input/bu21013.h                      |  10 +-
>  include/linux/kvm_host.h                           |  15 +-
>  include/linux/raid/Kbuild                          |   2 -
>  include/linux/raid/md_u.h                          | 141 +-----
>  include/net/cfg80211.h                             |   9 +
>  include/sound/core.h                               |   3 +
>  include/trace/events/xen.h                         |   8 +
>  include/uapi/linux/raid/Kbuild                     |   2 +
>  include/{ => uapi}/linux/raid/md_p.h               |   0
>  include/uapi/linux/raid/md_u.h                     | 155 +++++++
>  init/main.c                                        |   2 +
>  net/ceph/messenger.c                               |   6 +-
>  net/ipv4/netfilter/iptable_nat.c                   |   4 +-
>  net/ipv4/tcp_illinois.c                            |   8 +-
>  net/ipv4/tcp_input.c                               |   3 +
>  net/ipv4/tcp_metrics.c                             |   2 +-
>  net/ipv6/netfilter/ip6table_nat.c                  |   4 +-
>  net/ipv6/netfilter/nf_conntrack_reasm.c            |   4 +-
>  net/l2tp/l2tp_eth.c                                |   1 +
>  net/mac80211/ibss.c                                |   2 +-
>  net/mac80211/rx.c                                  |  74 +++-
>  net/mac80211/util.c                                |  42 +-
>  net/netfilter/nf_conntrack_h323_main.c             |   3 +-
>  net/sctp/socket.c                                  |   2 +-
>  net/sunrpc/backchannel_rqst.c                      |   2 +-
>  net/wireless/core.c                                |   3 +-
>  net/wireless/reg.c                                 |   5 +-
>  net/wireless/util.c                                |  14 +-
>  sound/core/compress_offload.c                      |   9 +-
>  sound/core/control.c                               |   5 +
>  sound/core/hwdep.c                                 |  12 +-
>  sound/core/init.c                                  |  50 ++-
>  sound/core/oss/mixer_oss.c                         |  10 +-
>  sound/core/oss/pcm_oss.c                           |   6 +
>  sound/core/pcm.c                                   |  13 +-
>  sound/core/pcm_native.c                            |  33 +-
>  sound/core/rawmidi.c                               |  26 +-
>  sound/core/sound.c                                 |  11 +-
>  sound/core/sound_oss.c                             |  10 +-
>  sound/pci/hda/patch_sigmatel.c                     |   2 +
>  sound/pci/ice1712/ice1724.c                        |   7 +-
>  sound/soc/omap/omap-dmic.c                         |   4 +-
>  sound/soc/omap/zoom2.c                             |   5 +-
>  sound/usb/card.c                                   |  12 +-
>  sound/usb/card.h                                   |   1 +
>  sound/usb/mixer.c                                  |  65 ++-
>  sound/usb/mixer_quirks.c                           |  58 ++-
>  sound/usb/pcm.c                                    |  53 ++-
>  sound/usb/proc.c                                   |   4 +-
>  sound/usb/stream.c                                 |   1 +
>  sound/usb/usbaudio.h                               |   2 +-
>  361 files changed, 4393 insertions(+), 2842 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/input/gpio-matrix-keypad.txt
>  create mode 100644 Documentation/devicetree/bindings/input/pwm-beeper.txt
>  create mode 100644 Documentation/devicetree/bindings/input/stmpe-keypad.txt
>  create mode 100644 Documentation/devicetree/bindings/input/tca8418_keypad.txt
>  create mode 100644 Documentation/devicetree/bindings/input/touchscreen/mms114.txt
>  create mode 100644 Documentation/devicetree/bindings/input/touchscreen/stmpe.txt
>  rename drivers/i2c/{busses => }/i2c-stub.c (75%)
>  create mode 100644 drivers/input/misc/da9055_onkey.c
>  create mode 100644 drivers/input/misc/retu-pwrbutton.c
>  create mode 100644 drivers/input/serio/arc_ps2.c
>  delete mode 100644 drivers/input/touchscreen/h3600_ts_input.c
>  create mode 100644 include/linux/hashtable.h
>  rename include/{ => uapi}/linux/raid/md_p.h (100%)
>  create mode 100644 include/uapi/linux/raid/md_u.h
> 
> -- 
> Dmitry
> 



-- 
Dmitry

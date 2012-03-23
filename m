Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab2CWLot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 07:44:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757473Ab2CWLoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 07:44:46 -0400
Message-ID: <4F6C6229.6050208@redhat.com>
Date: Fri, 23 Mar 2012 08:44:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.4-rc1] media updates
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For the media patch series, that includes:
	- V4L2 API additions to better support JPEG compression control;
	- media API additions to properly support MPEG decoders;
	- V4L2 API additions for image crop/scaling;
	- a few other V4L2 API DocBook fixes/improvements;
	- two new DVB frontend drivers: m88rs2000 and rtl2830;
	- two new DVB drivers: az6007 and rtl28xxu;
	- a framework for ISA drivers, that removed lots of common code
	  found at the ISA radio drivers;
	- a new FM transmitter driver (radio-keene);
	- a GPIO-based IR receiver driver;
	- a new sensor driver: mt9m032;
	- some new video drivers: adv7183, blackfin, mx2_emmaprp, sii9234_drv,
	  vs6624;
	- several new board additions, driver fixes, improvements and cleanups.

Thanks,
Mauro

-

Latest commit at the branch: 
7483d45f0aee3afc0646d185cabd4af9f6cab58c Merge branch 'staging/for_v3.4' into v4l_for_linus
The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Akihiro Tsukada (4):
      [media] dvb: earth-pt1: stop polling data when no one accesses the device
      [media] dvb: earth-pt1: add an error check/report on the incoming data
      [media] dvb: earth-pt1: decrease the too large DMA buffer size
      [media] dvb: earth-pt1: remove unsupported net subdevices

Alexey Khoroshilov (3):
      [media] staging: go7007: fix mismatch in mutex lock-unlock in [read|write]_reg_fp
      [media] dib9000: fix explicit lock mismatches
      [media] dib9000: implement error handling for DibAcquireLock

Andreas Regel (2):
      [media] stb0899: set FE_HAS_SIGNAL flag in read_status
      [media] stb0899: fixed reading of IF_AGC_GAIN register

Andrew Miller (1):
      [media] Staging: media: solo6x10: core.c Fix some coding style issue

Andrew Morton (1):
      [media] uvcvideo: uvc_driver.c: use linux/atomic.h

Andrzej Pietrasiewicz (1):
      [media] s5p-jpeg: Adapt to new controls

Andy Shevchenko (7):
      [media] media: video: append $(srctree) to -I parameters
      [media] media: tuners: append $(srctree) to -I parameters
      [media] media: dvb: append $(srctree) to -I parameters
      [media] media: saa7134: append $(srctree) to -I parameters
      [media] media: saa7164: append $(srctree) to -I parameters
      [media] media: ivtv: append $(srctree) to -I parameters
      [media] media: gspca: append $(srctree) to -I parameters

Antti Palosaari (15):
      [media] anysee: repeat failed USB control messages
      [media] Realtek RTL2830 DVB-T demodulator driver
      [media] Realtek RTL28xxU serie DVB USB interface driver
      [media] rtl28xx: fix rtl2831u with tuner mxl5005s
      [media] rtl28xx: initial support for rtl2832u
      [media] rtl28xx: reimplement I2C adapter
      [media] rtl2830: correct I2C functionality
      [media] rtl28xxu: make it compile against current Kernel
      [media] rtl28xxu: many small tweaks
      [media] rtl2830: prevent .read_status() when sleeping
      [media] tda10071: fix the delivery system
      [media] tda10071: fix the delivery system
      [media] af9015: fix i2c failures for dual-tuner devices - part 2
      [media] em28xx: support for 1b80:e425 MaxMedia UB425-TC
      [media] em28xx: support for 2013:0251 PCTV QuatroStick nano (520e)

Axel Lin (1):
      [media] convert drivers/media/* to use module_i2c_driver()

Bhupesh Sharma (1):
      [media] V4L/v4l2-dev: Make 'videodev_init' as a subsys initcall

Dan Carpenter (3):
      [media] s2255drv: cleanup vidioc_enum_fmt_cap()
      [media] s2255drv: fix some endian bugs
      [media] gpio-ir-recv: a couple signedness bugs

Danny Kukawka (5):
      [media] max2165: trival fix for some -Wuninitialized warning
      [media] mt2063: remove mt2063_setTune from header
      [media] adp1653: included linux/module.h twice
      [media] mt9p031.c included media/v4l2-subdev.h twice
      [media] cx18-driver: fix handling of 'radio' module parameter

Ezequiel García (6):
      [media] staging: easycap: Clean comment style in easycap_usb_probe()
      [media] staging: easycap: Fix incorrect comment
      [media] media: em28xx: Remove unused urb arrays from device struct
      [media] media: em28xx: Paranoic stack save
      [media] rc: Pospone ir raw decoders loading until really needed
      [media] em28xx: Unused macro cleanup

Fabio Estevam (3):
      [media] media: video: mx2_camera.c: Provide error message if clk_get fails
      [media] media: video: mx2_camera.c: Remove unneeded dev_dbg
      [media] video: Kconfig: Select VIDEOBUF2_DMA_CONTIG for VIDEO_MX2

Gianluca Gennari (5):
      [media] rtl2830: __udivdi3 undefined
      [media] em28xx: pre-allocate DVB isoc transfer buffers
      [media] as102: map URB DMA addresses in the driver
      [media] as102: add __packed attribute to structs defined inside packed structs
      [media] as102: set optimal eLNA config values for each device

Gordon Hecker (1):
      [media] af9015: fix i2c failures for dual-tuner devices

Guennadi Liakhovetski (2):
      [media] V4L: soc-camera: call soc_camera_power_on() after adding the client to the host
      [media] V4L: sh_mobile_ceu_camera: maximum image size depends on the hardware version

Hans Verkuil (38):
      [media] V4L2: Add per-device-node capabilities
      [media] vivi: set device_caps
      [media] ivtv: setup per-device caps
      [media] vivi: don't set V4L2_CAP_DEVICE_CAPS for the device_caps field
      [media] v4l2: add VIDIOC_(TRY_)DECODER_CMD
      [media] v4l spec: document VIDIOC_(TRY_)DECODER_CMD
      [media] ivtv: implement new decoder command ioctls
      [media] v4l2-ctrls: add new controls for MPEG decoder devices
      [media] Document decoder controls
      [media] ivtv: implement new decoder controls
      [media] cx18/ddbridge: remove unused headers
      [media] ivtv: add IVTV_IOC_PASSTHROUGH_MODE
      [media] v4l2: standardize log start/end message
      [media] v4l2-subdev: add start/end messages for log_status
      [media] v4l2-ctrls: add helper functions for control events
      [media] vivi: use v4l2_ctrl_subscribe_event
      [media] radio-keene: add a driver for the Keene FM Transmitter
      [media] hid-core: ignore the Keene FM transmitter
      [media] radio-isa: add framework for ISA radio drivers
      [media] radio-aimslab: Convert to radio-isa
      [media] radio-aztech: Convert to radio-isa
      [media] radio-gemtek: Convert to radio-isa
      [media] radio-rtrack2: Convert to radio-isa
      [media] radio-terratec: Convert to radio-isa
      [media] radio-trust: Convert to radio-isa
      [media] radio-typhoon: Convert to radio-isa
      [media] radio-zoltrix: Convert to radio-isa
      [media] radio/Kconfig: cleanup
      [media] v4l2-ctrls: v4l2_ctrl_add_handler should add all refs
      [media] ivtv: simplify how the decoder controls are set up
      [media] Fix small DocBook typo
      [media] Add missing slab.h to fix linux-next compile errors
      [media] tea575x-tuner: update to latest V4L2 framework requirements
      [media] tea575x: fix HW seek
      [media] radio-maxiradio: use the tea575x framework
      [media] V4L2 Spec: return -EINVAL on unsupported wrap_around value
      [media] Two small string fixes in v4l2-ctrls.c
      [media] -EINVAL -> -ENOTTY

Ivan Kalvachev (1):
      [media] em28xx: support for 2304:0242 PCTV QuatroStick (510e)

James Hogan (2):
      [media] rc/ir-raw: use kfifo_rec_ptr_1 instead of kfifo
      [media] media: ir-sony-decoder: 15bit function decode fix

Jarod Wilson (1):
      [media] mceusb: add Formosa device ID 0xe042

Javier Martin (16):
      [media] MEM2MEM: Add support for eMMa-PrP mem2mem operations
      [media] MX2: Add platform definitions for eMMa-PrP device
      [media] media: vb2: support userptr for PFN mappings
      [media] media i.MX27 camera: migrate driver to videobuf2
      [media] media i.MX27 camera: add start_stream and stop_stream callbacks
      [media] media i.MX27 camera: improve discard buffer handling
      [media] media i.MX27 camera: handle overflows properly
      [media] media: i.MX27 camera: Use list_first_entry() whenever possible
      [media] media: i.MX27 camera: Use spin_lock() inside the IRQ handler
      [media] media: i.MX27 camera: return IRQ_NONE if no IRQ status bit is set
      [media] media: i.MX27 camera: fix compilation warning
      [media] media: i.MX27 camera: more efficient discard buffer handling
      [media] media: i.MX27 camera: Add resizing support
      [media] media: tvp5150: Add cropping support
      [media] media: tvp5150: support g_mbus_fmt callback
      [media] uvcvideo: Allow userptr IO mode

Jean Delvare (3):
      [media] cx22702: Fix signal strength
      [media] dib0700: Drop useless check when remote key is pressed
      [media] dib0700: Fix memory leak during initialization

Jean-François Moine (25):
      [media] gspca - pac7302: Add new webcam 06f8:301b
      [media] gspca - pac7302: Cleanup source
      [media] gspca - pac7302: Simplify the function pkt_scan
      [media] gspca - pac7302: Use the new video control mechanism
      [media] gspca - pac7302: Do autogain setting work
      [media] gspca - sonixj: Remove the jpeg control
      [media] gspca - sonixj: Add exposure, gain and auto exposure for po2030n
      [media] gspca - zc3xx: Adjust the JPEG decompression tables
      [media] gspca - zc3xx: Do automatic transfer control for hv7131r and pas202b
      [media] gspca - zc3xx: Remove the low level traces
      [media] gspca - zc3xx: Cleanup source
      [media] gspca - zc3xx: Fix bad sensor values when changing autogain
      [media] gspca - zc3xx: Set the exposure at start of hv7131r
      [media] gspca - zc3xx: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support
      [media] gspca - zc3xx: Lack of register 08 value for sensor cs2102k
      [media] gspca - sn9c20x: Fix loss of frame start
      [media] gspca - sn9c20x: Use the new video control mechanism
      [media] gspca - sn9c20x: Propagate USB errors to higher level
      [media] gspca - sn9c20x: Add a delay after Omnivision sensor reset
      [media] gspca - sn9c20x: Add the JPEG compression quality control
      [media] gspca - sn9c20x: Optimize the code of write sequences
      [media] gspca - sn9c20x: Greater delay in case of sensor no response
      [media] gspca - sn9c20x: Add automatic JPEG compression mechanism
      [media] gspca - sn9c20x: Simplify register write for capture start/stop
      [media] gspca - sn9c20x: Cleanup source

Jesper Juhl (5):
      [media] drxk_hard: does not need to include linux/version.h
      [media] tm6000: Don't use pointer after freeing it in tm6000_ir_fini()
      [media] easycap: Fix mem leak in easycap_usb_probe()
      [media] [trivial] DiB0090: remove redundant '; ' from dib0090_fw_identify()
      [media] media, cx231xx: Fix double free on close

Jonathan Corbet (7):
      [media] marvell-cam: ensure that the camera stops when requested
      [media] marvell-cam: Remove broken "owner" logic
      [media] marvell-cam: Increase the DMA shutdown timeout
      [media] marvell-cam: fix the green screen of death
      [media] marvell-cam: Don't signal multiple frame completions in scatter/gather mode
      [media] mmp-camera: Don't power up the sensor on resume
      [media] marvell-cam: Demote the "release" print to debug level

Jose Alberto Reguero (5):
      [media] az6007: add another Terratec H7 usb id
      [media] drxk: Fix get_tune_settings for DVB-T
      [media] mt2063: increase frequency_max to tune channel 69
      [media] Add CI support to az6007 driver
      [media] gspca - ov534_9: Add brightness to OmniVision 5621 sensor

Julia Lawall (1):
      [media] v4l: s5p-tv: use devm_ functions

Justin P. Mattock (1):
      [media] staging: Fix comments and some typos in staging/media/*

Kamil Debski (3):
      [media] s5p-g2d: Added support for clk_prepare
      [media] s5p-mfc: Added support for clk_prepare
      [media] s5p-g2d: Added locking for writing control values to registers

Klaus Schmidinger (1):
      [media] stb0899: fix the limits for signal strength values

Kyle Strickland (1):
      [media] Add support for KWorld PC150-U ATSC hybrid tuner card

Larry Finger (1):
      [media] ivtv: Fix build warning

Laurent Pinchart (8):
      [media] v4l: Add custom compat_ioctl32 operation
      [media] uvcvideo: Return -ENOTTY in case of unknown ioctl
      [media] uvcvideo: Implement compat_ioctl32 for custom ioctls
      [media] uvcvideo: Add support for Dell XPS m1530 integrated webcam
      [media] mt9p031: Remove unused xskip and yskip fields in struct mt9p031
      [media] v4l: Aptina-style sensor PLL support
      [media] mt9p031: Use generic PLL setup code
      [media] media: Initialize the media core with subsys_initcall()

Malcolm Priestley (16):
      [media] it913x v1.23 use it913x_config.chip_ver to select firmware
      [media] it913x ver 1.24 Make 0x60 default on version 2 devices
      [media] IT913X Version 1 and Version 2 keymaps
      [media] it913x v1.25 support different for remotes
      [media] lmedm04 ver 1.96 Turn off PID filter by default
      [media] it913x ver 1.26 change to remove interruptible mutex locks
      [media] it913x ver 1.27 Allow PID 8192 to turn PID filter off
      [media] it913x-fe ver 1.15 read signal strenght using reg VAR_P_INBAND
      [media] STV0288 increase delay between carrier search
      [media] lmedm04 ver 1.97 Remove delays required for STV0288
      [media] lmedm04 v1.98 Remove clear halt
      [media] m88rs2000 1.12 v2 DVB-S frontend and tuner module
      [media] lmedm04 ver 1.99 support for m88rs2000 v2
      [media] lmedm04 RS2000 Firmware details
      [media] lmedm04 - support for m88rs2000 missing kconfig option
      [media] m88rs2000 ver 1.13 Correct deseqc and tuner gain functions

Manjunath Hadli (1):
      [media] davinci: vpif: remove machine specific header file includes

Martin Hostettler (1):
      [media] v4l: Add driver for Micron MT9M032 camera sensor

Masanari Iida (7):
      [media] [trivial] lmedm04: Fix typo
      [media] [trivial] ov6650: Fix typo
      [media] [trivial] s5p: Fix typo in mixer_drv.c and hdmi_drv.c
      [media] [trivial] frontends: Fix typo in tda1004x.c
      [media] [trivial] mantis: Fix typo in mantis_hif.c
      [media] [trivial]: Fix typo in radio-sf16fmr2.c
      [media] [trivial] davinci: Fix typo in dm355_ccdvc.c

Mauro Carvalho Chehab (48):
      [media] dvb: Add a new driver for az6007
      [media] az6007: Fix compilation troubles at az6007
      [media] az6007: Fix it to allow loading it without crash
      [media] az6007: Fix the I2C code in order to handle mt2063
      [media] az6007: Comment the gate_ctl mutex
      [media] az6007: Remove some dead code that doesn't seem to be needed
      [media] az6007: CodingStyle cleanup
      [media] az6007: Get rid of az6007.h
      [media] az6007: Replace the comments at the beginning of the driver
      [media] az6007: move device PID's to the proper place
      [media] az6007: make driver less verbose
      [media] drxk: Don't assume a default firmware name
      [media] az6007: need to define drivers name before including dvb-usb.h
      [media] az6007: Fix some init sequences and use the right firmwares
      [media] az6007: Change the az6007 read/write routine parameter
      [media] az6007: Simplify the read/write logic
      [media] az6007: Simplify the code by removing an uneeded function
      [media] az6007: Fix IR receive code
      [media] az6007: improve the error messages for az6007 read/write calls
      [media] az6007: Use the new MFE support at dvb-usb
      [media] az6007: Change it to use the MFE solution adopted at dvb-usb
      [media] az6007: Use a per device private struct
      [media] drxk: Allow setting it on dynamic_clock mode
      [media] az6007: Use DRX-K dynamic clock mode
      [media] drxk: add support for Mpeg output clock drive strength config
      [media] drxk: Allow enabling MERR/MVAL cfg
      [media] az6007: code cleanups and fixes
      [media] az6007: Driver cleanup
      [media] az6007: Protect read/write calls with a mutex
      [media] az6007: Be sure to use kmalloc'ed buffer for transfers
      [media] az6007: Fix IR handling
      [media] az6007: Convert IR to use the rc_core logic
      [media] az6007: Use the right keycode for Terratec H7
      [media] az6007: Enable the driver at the building system
      [media] az6007: CodingStyle fixes
      Merge tag 'v3.3-rc1' into staging/for_v3.3
      [media] cinergyT2-fe: Fix bandwdith settings
      Merge branch 'v4l_for_linus' into staging/for_v3.4
      Merge branch 'v4l_for_linus' into staging/for_v3.4
      [media] fintek-cir: add support for newer chip version
      [media] Documentation: Update some card lists
      [media] radio-sf16fmr2: fix session mismatches
      Merge tag 'v3.3' into staging/for_v3.4
      [media] m88rs2000: Don't fill info.type
      [media] /w9966: Fix a build warning
      [media] partially reverts changeset fa5527c
      [media] update CARDLIST.em28xx
      Merge branch 'staging/for_v3.4' into v4l_for_linus

Michael Krufky (12):
      [media] xc5000: allow drivers to set desired firmware in xc5000_attach
      [media] xc5000: add XC5000C_DEFAULT_FIRMWARE: dvb-fe-xc5000c-41.024.5-31875.fw
      [media] tuner: add support for Xceive XC5000C
      [media] tveeprom: add support for Xceive XC5000C tuner
      [media] remove unneeded #define's in xc5000.h
      [media] xc5000: remove static dependencies on xc5000 created by previous changesets
      [media] xc5000: drivers should specify chip revision rather than firmware
      [media] xc5000: declare firmware configuration structures as static const
      [media] tveeprom: update hauppauge tuner list thru 181
      [media] au8522: bug-fix: enable modulation AFTER tune (instead of before tuning)
      [media] mxl111sf: fix error on stream stop in mxl111sf_ep6_streaming_ctrl()
      [media] pvrusb2: fix 7MHz & 8MHz DVB-T tuner support for HVR1900 rev D1F5

Paolo Pantò (1):
      [media] rtl28xxu: add another Freecom usb id

Philipp Zabel (1):
      [media] V4L: pxa_camera: add clk_prepare/clk_unprepare calls

Randy Dunlap (1):
      [media] wl128x: fix build errors when GPIOLIB is not enabled

Ravi Kumar V (1):
      [media] rc: Add support for GPIO based IR Receiver driver

Sachin Kamat (1):
      [media] s5p-g2d: Add HFLIP and VFLIP support

Sander Eikelenboom (1):
      [media] cx25821: Add a card definition for "No brand" cards that have: subvendor = 0x0000 subdevice = 0x0000

Santosh Nayak (2):
      [media] Driver: video: Use the macro DMA_BIT_MASK()
      [media] dvb: negative value assigned to unsigned int in CDRXD()

Sascha Hauer (1):
      [media] V4L: mx2_camera: remove unsupported i.MX27 DMA mode, make EMMA mandatory

Scott Jiang (3):
      [media] adv7183: add adv7183 decoder driver
      [media] vs6624: add vs6624 sensor driver
      [media] add blackfin capture bridge driver

Simon Arlott (1):
      [media] dvb-core: fix DVBFE_ALGO_HW retune bug

Sylwester Nawrocki (16):
      [media] V4L: Add JPEG compression control class
      [media] V4L: Add JPEG compression control class documentation
      [media] s5p-jpeg: Use struct v4l2_fh
      [media] s5p-jpeg: Add JPEG controls support
      [media] s5p-fimc: Add driver documentation
      [media] s5p-fimc: convert to clk_prepare()/clk_unprepare()
      [media] s5p-csis: Add explicit dependency on REGULATOR
      [media] s5p-fimc: Convert to the device managed resources
      [media] s5p-fimc: Add support for VIDIOC_PREPARE_BUF/CREATE_BUFS ioctls
      [media] s5p-fimc: Replace the crop ioctls with VIDIOC_S/G_SELECTION
      [media] s5p-csis: Convert to the device managed resources
      [media] s5k6aa: Make subdev name independent of the I2C slave address
      [media] noon010pc30: Make subdev name independent of the I2C slave address
      [media] m5mols: Make subdev name independent of the I2C slave address
      [media] V4L: Improve the selection API documentation
      [media] s5p-csis: Fix compilation with PM_SLEEP disabled

Taylor Ralph (1):
      [media] hdpvr: update picture controls to support firmware versions > 0.15

Tomasz Stanislawski (3):
      [media] v4l: s5p-tv: add sii9234 driver
      [media] v4l: s5p-tv: hdmi: add support for platform data
      [media] v4l: s5p-tv: hdmi: integrate with MHL

Tomi Valkeinen (1):
      [media] omap_vout: fix section mismatch

Xi Wang (1):
      [media] lgdt330x: fix signedness error in i2c_read_demod_bytes()

 Documentation/DocBook/media/v4l/biblio.xml         |   20 +
 Documentation/DocBook/media/v4l/compat.xml         |   14 +
 Documentation/DocBook/media/v4l/controls.xml       |  220 ++++
 Documentation/DocBook/media/v4l/selection-api.xml  |    8 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |   19 +-
 .../DocBook/media/v4l/vidioc-decoder-cmd.xml       |  256 ++++
 .../DocBook/media/v4l/vidioc-encoder-cmd.xml       |    9 +-
 .../DocBook/media/v4l/vidioc-g-jpegcomp.xml        |   16 +-
 .../DocBook/media/v4l/vidioc-g-selection.xml       |  106 +-
 .../DocBook/media/v4l/vidioc-querycap.xml          |   36 +-
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |    6 +-
 Documentation/dvb/cards.txt                        |    1 +
 Documentation/dvb/lmedm04.txt                      |   11 +
 Documentation/video4linux/CARDLIST.cx23885         |    1 +
 Documentation/video4linux/CARDLIST.cx88            |    4 +-
 Documentation/video4linux/CARDLIST.em28xx          |   10 +-
 Documentation/video4linux/CARDLIST.saa7134         |    1 +
 Documentation/video4linux/CARDLIST.tuner           |    3 +-
 Documentation/video4linux/fimc.txt                 |  178 +++
 Documentation/video4linux/gspca.txt                |    1 +
 arch/arm/mach-imx/clock-imx27.c                    |    2 +-
 arch/arm/mach-imx/devices-imx27.h                  |    2 +
 arch/arm/plat-mxc/devices/platform-mx2-camera.c    |   18 +
 arch/arm/plat-mxc/include/mach/devices-common.h    |    2 +
 drivers/hid/hid-core.c                             |   10 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/media/common/tuners/Makefile               |    4 +-
 drivers/media/common/tuners/max2165.c              |    9 +-
 drivers/media/common/tuners/mt2063.c               |    4 +-
 drivers/media/common/tuners/mt2063.h               |    4 -
 drivers/media/common/tuners/tuner-types.c          |    4 +
 drivers/media/common/tuners/xc5000.c               |   47 +-
 drivers/media/common/tuners/xc5000.h               |    5 +
 drivers/media/dvb/ddbridge/ddbridge-core.c         |    1 +
 drivers/media/dvb/ddbridge/ddbridge.h              |    2 -
 drivers/media/dvb/dvb-core/dvb_frontend.c          |    2 +
 drivers/media/dvb/dvb-usb/Kconfig                  |   19 +
 drivers/media/dvb/dvb-usb/Makefile                 |   14 +-
 drivers/media/dvb/dvb-usb/af9015.c                 |   49 +
 drivers/media/dvb/dvb-usb/af9015.h                 |    2 +
 drivers/media/dvb/dvb-usb/anysee.c                 |   38 +-
 drivers/media/dvb/dvb-usb/az6007.c                 |  957 +++++++++++++++
 drivers/media/dvb/dvb-usb/dib0700_core.c           |   10 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    8 +
 drivers/media/dvb/dvb-usb/it913x.c                 |  170 ++-
 drivers/media/dvb/dvb-usb/lmedm04.c                |  287 ++++--
 drivers/media/dvb/dvb-usb/lmedm04.h                |    1 +
 drivers/media/dvb/dvb-usb/mxl111sf.c               |    6 +-
 drivers/media/dvb/dvb-usb/rtl28xxu.c               |  982 ++++++++++++++++
 drivers/media/dvb/dvb-usb/rtl28xxu.h               |  264 +++++
 drivers/media/dvb/frontends/Kconfig                |   15 +
 drivers/media/dvb/frontends/Makefile               |    6 +-
 drivers/media/dvb/frontends/au8522_decoder.c       |   13 +-
 drivers/media/dvb/frontends/au8522_dig.c           |   10 +-
 drivers/media/dvb/frontends/cx22702.c              |   22 +-
 drivers/media/dvb/frontends/dib0090.c              |    2 +-
 drivers/media/dvb/frontends/dib9000.c              |  121 ++-
 drivers/media/dvb/frontends/drxd_hard.c            |    6 +-
 drivers/media/dvb/frontends/drxk.h                 |   23 +-
 drivers/media/dvb/frontends/drxk_hard.c            |   47 +-
 drivers/media/dvb/frontends/drxk_hard.h            |    1 +
 drivers/media/dvb/frontends/it913x-fe-priv.h       |    5 +
 drivers/media/dvb/frontends/it913x-fe.c            |   91 ++-
 drivers/media/dvb/frontends/it913x-fe.h            |    4 +
 drivers/media/dvb/frontends/lgdt330x.c             |    6 +-
 drivers/media/dvb/frontends/m88rs2000.c            |  904 +++++++++++++++
 drivers/media/dvb/frontends/m88rs2000.h            |   66 ++
 drivers/media/dvb/frontends/rtl2830.c              |  562 +++++++++
 drivers/media/dvb/frontends/rtl2830.h              |   97 ++
 drivers/media/dvb/frontends/rtl2830_priv.h         |   57 +
 drivers/media/dvb/frontends/stb0899_drv.c          |   12 +-
 drivers/media/dvb/frontends/stv0288.c              |    2 +-
 drivers/media/dvb/frontends/tda1004x.c             |    4 +-
 drivers/media/dvb/frontends/tda10071.c             |    2 +-
 drivers/media/dvb/mantis/mantis_hif.c              |    2 +-
 drivers/media/dvb/ngene/ngene-cards.c              |    1 +
 drivers/media/dvb/pt1/pt1.c                        |   93 ++-
 drivers/media/media-devnode.c                      |    2 +-
 drivers/media/radio/Kconfig                        |  125 +--
 drivers/media/radio/Makefile                       |    2 +
 drivers/media/radio/radio-aimslab.c                |  440 ++------
 drivers/media/radio/radio-aztech.c                 |  372 ++-----
 drivers/media/radio/radio-gemtek.c                 |  494 ++-------
 drivers/media/radio/radio-isa.c                    |  340 ++++++
 drivers/media/radio/radio-isa.h                    |  105 ++
 drivers/media/radio/radio-keene.c                  |  427 +++++++
 drivers/media/radio/radio-maxiradio.c              |  379 +-----
 drivers/media/radio/radio-rtrack2.c                |  332 ++-----
 drivers/media/radio/radio-sf16fmr2.c               |   63 +-
 drivers/media/radio/radio-tea5764.c                |   19 +-
 drivers/media/radio/radio-terratec.c               |  365 +-----
 drivers/media/radio/radio-trust.c                  |  388 ++-----
 drivers/media/radio/radio-typhoon.c                |  366 ++-----
 drivers/media/radio/radio-zoltrix.c                |  442 ++------
 drivers/media/radio/saa7706h.c                     |   13 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   28 +-
 drivers/media/radio/si4713-i2c.c                   |   15 +-
 drivers/media/radio/tef6862.c                      |   14 +-
 drivers/media/rc/Kconfig                           |    9 +
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/fintek-cir.c                      |   26 +-
 drivers/media/rc/fintek-cir.h                      |    4 +-
 drivers/media/rc/gpio-ir-recv.c                    |  205 ++++
 drivers/media/rc/ir-sony-decoder.c                 |    2 +-
 drivers/media/rc/keymaps/Makefile                  |    3 +
 drivers/media/rc/keymaps/rc-it913x-v1.c            |   95 ++
 drivers/media/rc/keymaps/rc-it913x-v2.c            |   94 ++
 drivers/media/rc/keymaps/rc-kworld-pc150u.c        |  102 ++
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |   52 +
 drivers/media/rc/mceusb.c                          |    2 +
 drivers/media/rc/rc-core-priv.h                    |    2 +-
 drivers/media/rc/rc-main.c                         |    9 +-
 drivers/media/video/Kconfig                        |   49 +-
 drivers/media/video/Makefile                       |   24 +-
 drivers/media/video/adp1653.c                      |   20 +-
 drivers/media/video/adv7170.c                      |   13 +-
 drivers/media/video/adv7175.c                      |   13 +-
 drivers/media/video/adv7180.c                      |   14 +-
 drivers/media/video/adv7183.c                      |  699 +++++++++++
 drivers/media/video/adv7183_regs.h                 |  107 ++
 drivers/media/video/adv7343.c                      |   13 +-
 drivers/media/video/ak881x.c                       |   13 +-
 drivers/media/video/aptina-pll.c                   |  174 +++
 drivers/media/video/aptina-pll.h                   |   56 +
 drivers/media/video/as3645a.c                      |   19 +-
 drivers/media/video/blackfin/Kconfig               |   10 +
 drivers/media/video/blackfin/Makefile              |    2 +
 drivers/media/video/blackfin/bfin_capture.c        | 1059 +++++++++++++++++
 drivers/media/video/blackfin/ppi.c                 |  271 +++++
 drivers/media/video/bt819.c                        |   13 +-
 drivers/media/video/bt856.c                        |   13 +-
 drivers/media/video/bt866.c                        |   13 +-
 drivers/media/video/bt8xx/bttv-driver.c            |    4 -
 drivers/media/video/cs5345.c                       |   13 +-
 drivers/media/video/cs53l32a.c                     |   13 +-
 drivers/media/video/cx18/cx18-driver.c             |    8 +-
 drivers/media/video/cx18/cx18-driver.h             |    2 -
 drivers/media/video/cx18/cx18-ioctl.c              |    4 -
 drivers/media/video/cx231xx/cx231xx-417.c          |    1 -
 drivers/media/video/cx231xx/cx231xx-cards.c        |    1 -
 drivers/media/video/cx231xx/cx231xx-video.c        |    6 +-
 drivers/media/video/cx25821/cx25821-core.c         |    9 +-
 drivers/media/video/cx25840/cx25840-core.c         |   13 +-
 drivers/media/video/davinci/dm355_ccdc.c           |    2 +-
 drivers/media/video/davinci/vpif.h                 |    2 -
 drivers/media/video/davinci/vpif_display.c         |    2 -
 drivers/media/video/em28xx/em28xx-cards.c          |  114 ++-
 drivers/media/video/em28xx/em28xx-core.c           |  145 ++-
 drivers/media/video/em28xx/em28xx-dvb.c            |   96 ++-
 drivers/media/video/em28xx/em28xx-i2c.c            |    8 -
 drivers/media/video/em28xx/em28xx-video.c          |   10 +-
 drivers/media/video/em28xx/em28xx.h                |   29 +-
 drivers/media/video/gspca/gl860/Makefile           |    2 +-
 drivers/media/video/gspca/m5602/Makefile           |    2 +-
 drivers/media/video/gspca/ov534_9.c                |   49 +-
 drivers/media/video/gspca/pac7302.c                |  583 +++-------
 drivers/media/video/gspca/sn9c20x.c                | 1138 ++++++++----------
 drivers/media/video/gspca/sonixj.c                 |  185 +++-
 drivers/media/video/gspca/stv06xx/Makefile         |    2 +-
 drivers/media/video/gspca/zc3xx.c                  |  328 ++++--
 drivers/media/video/imx074.c                       |   13 +-
 drivers/media/video/indycam.c                      |   13 +-
 drivers/media/video/ir-kbd-i2c.c                   |   17 +-
 drivers/media/video/ivtv/Makefile                  |    8 +-
 drivers/media/video/ivtv/ivtv-controls.c           |   62 +
 drivers/media/video/ivtv/ivtv-controls.h           |    2 +
 drivers/media/video/ivtv/ivtv-driver.c             |   41 +-
 drivers/media/video/ivtv/ivtv-driver.h             |   12 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |    2 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |  188 ++--
 drivers/media/video/ivtv/ivtv-streams.c            |   20 +-
 drivers/media/video/ks0127.c                       |   13 +-
 drivers/media/video/m52790.c                       |   13 +-
 drivers/media/video/m5mols/m5mols_core.c           |   15 +-
 drivers/media/video/marvell-ccic/mcam-core.c       |   35 +-
 drivers/media/video/marvell-ccic/mcam-core.h       |    1 -
 drivers/media/video/marvell-ccic/mmp-driver.c      |   13 +-
 drivers/media/video/msp3400-driver.c               |   13 +-
 drivers/media/video/mt9m001.c                      |   13 +-
 drivers/media/video/mt9m032.c                      |  868 ++++++++++++++
 drivers/media/video/mt9m111.c                      |   13 +-
 drivers/media/video/mt9p031.c                      |   80 +-
 drivers/media/video/mt9t001.c                      |   13 +-
 drivers/media/video/mt9t031.c                      |   13 +-
 drivers/media/video/mt9t112.c                      |   16 +-
 drivers/media/video/mt9v011.c                      |   13 +-
 drivers/media/video/mt9v022.c                      |   13 +-
 drivers/media/video/mt9v032.c                      |   13 +-
 drivers/media/video/mx2_camera.c                   | 1214 +++++++++++---------
 drivers/media/video/mx2_emmaprp.c                  | 1008 ++++++++++++++++
 drivers/media/video/noon010pc30.c                  |   15 +-
 drivers/media/video/omap/omap_vout.c               |    3 +-
 drivers/media/video/ov2640.c                       |   16 +-
 drivers/media/video/ov5642.c                       |   13 +-
 drivers/media/video/ov6650.c                       |   15 +-
 drivers/media/video/ov7670.c                       |   13 +-
 drivers/media/video/ov772x.c                       |   17 +-
 drivers/media/video/ov9640.c                       |   13 +-
 drivers/media/video/ov9740.c                       |   13 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.c      |   10 +
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    1 -
 drivers/media/video/pwc/pwc-v4l.c                  |   10 +-
 drivers/media/video/pxa_camera.c                   |    4 +-
 drivers/media/video/rj54n1cb0c.c                   |   13 +-
 drivers/media/video/s2255drv.c                     |   33 +-
 drivers/media/video/s5k6aa.c                       |   15 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |  121 ++-
 drivers/media/video/s5p-fimc/fimc-core.c           |   85 +-
 drivers/media/video/s5p-fimc/fimc-core.h           |    2 -
 drivers/media/video/s5p-fimc/fimc-mdevice.c        |    7 +-
 drivers/media/video/s5p-fimc/mipi-csis.c           |  111 +--
 drivers/media/video/s5p-g2d/g2d-hw.c               |    5 +
 drivers/media/video/s5p-g2d/g2d.c                  |   63 +-
 drivers/media/video/s5p-g2d/g2d.h                  |    6 +-
 drivers/media/video/s5p-jpeg/jpeg-core.c           |  199 +++-
 drivers/media/video/s5p-jpeg/jpeg-core.h           |   11 +-
 drivers/media/video/s5p-jpeg/jpeg-hw.h             |   18 +-
 drivers/media/video/s5p-mfc/s5p_mfc_pm.c           |   24 +-
 drivers/media/video/s5p-tv/Kconfig                 |   10 +
 drivers/media/video/s5p-tv/Makefile                |    2 +
 drivers/media/video/s5p-tv/hdmi_drv.c              |  120 ++-
 drivers/media/video/s5p-tv/hdmiphy_drv.c           |   12 +-
 drivers/media/video/s5p-tv/mixer_drv.c             |    2 +-
 drivers/media/video/s5p-tv/sdo_drv.c               |   26 +-
 drivers/media/video/s5p-tv/sii9234_drv.c           |  432 +++++++
 drivers/media/video/saa6588.c                      |   13 +-
 drivers/media/video/saa7110.c                      |   13 +-
 drivers/media/video/saa7115.c                      |   13 +-
 drivers/media/video/saa7127.c                      |   13 +-
 drivers/media/video/saa7134/Makefile               |    8 +-
 drivers/media/video/saa7134/saa6752hs.c            |   13 +-
 drivers/media/video/saa7134/saa7134-cards.c        |   59 +
 drivers/media/video/saa7134/saa7134-dvb.c          |   44 +
 drivers/media/video/saa7134/saa7134-i2c.c          |   14 +-
 drivers/media/video/saa7134/saa7134-input.c        |   63 +
 drivers/media/video/saa7134/saa7134.h              |    5 +-
 drivers/media/video/saa7164/Makefile               |    8 +-
 drivers/media/video/saa7164/saa7164-encoder.c      |    6 -
 drivers/media/video/saa7164/saa7164-vbi.c          |    6 -
 drivers/media/video/saa717x.c                      |   13 +-
 drivers/media/video/saa7185.c                      |   13 +-
 drivers/media/video/saa7191.c                      |   13 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |   35 +-
 drivers/media/video/soc_camera.c                   |   32 +-
 drivers/media/video/sr030pc30.c                    |   13 +-
 drivers/media/video/tda7432.c                      |   13 +-
 drivers/media/video/tda9840.c                      |   13 +-
 drivers/media/video/tea6415c.c                     |   13 +-
 drivers/media/video/tea6420.c                      |   13 +-
 drivers/media/video/ths7303.c                      |   14 +-
 drivers/media/video/tlv320aic23b.c                 |   13 +-
 drivers/media/video/tm6000/tm6000-input.c          |    3 +-
 drivers/media/video/tuner-core.c                   |   28 +-
 drivers/media/video/tvaudio.c                      |   13 +-
 drivers/media/video/tveeprom.c                     |   10 +-
 drivers/media/video/tvp514x.c                      |   13 +-
 drivers/media/video/tvp5150.c                      |  141 ++-
 drivers/media/video/tvp7002.c                      |   25 +-
 drivers/media/video/tw9910.c                       |   16 +-
 drivers/media/video/upd64031a.c                    |   13 +-
 drivers/media/video/upd64083.c                     |   13 +-
 drivers/media/video/uvc/uvc_driver.c               |   11 +-
 drivers/media/video/uvc/uvc_queue.c                |    2 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |  207 ++++-
 drivers/media/video/v4l2-compat-ioctl32.c          |   22 +-
 drivers/media/video/v4l2-ctrls.c                   |   91 ++-
 drivers/media/video/v4l2-dev.c                     |    2 +-
 drivers/media/video/v4l2-ioctl.c                   |   42 +-
 drivers/media/video/v4l2-subdev.c                  |   12 +-
 drivers/media/video/videobuf2-vmalloc.c            |   70 +-
 drivers/media/video/vivi.c                         |   26 +-
 drivers/media/video/vp27smpx.c                     |   13 +-
 drivers/media/video/vpx3220.c                      |   13 +-
 drivers/media/video/vs6624.c                       |  928 +++++++++++++++
 drivers/media/video/vs6624_regs.h                  |  337 ++++++
 drivers/media/video/w9966.c                        |    4 +-
 drivers/media/video/wm8739.c                       |   13 +-
 drivers/media/video/wm8775.c                       |   13 +-
 drivers/staging/media/Kconfig                      |    2 +-
 drivers/staging/media/as102/as102_drv.c            |    2 +-
 drivers/staging/media/as102/as102_drv.h            |    2 +-
 drivers/staging/media/as102/as102_fe.c             |    6 +-
 drivers/staging/media/as102/as102_fw.h             |    2 +-
 drivers/staging/media/as102/as102_usb_drv.c        |   17 +-
 drivers/staging/media/as102/as10x_cmd.h            |   80 +-
 drivers/staging/media/as102/as10x_types.h          |    2 +-
 drivers/staging/media/easycap/easycap_main.c       |  243 ++---
 drivers/staging/media/go7007/go7007-v4l2.c         |    8 +-
 drivers/staging/media/go7007/s2250-board.c         |   16 +-
 drivers/staging/media/lirc/lirc_serial.c           |    2 +-
 drivers/staging/media/solo6x10/Kconfig             |    2 +-
 drivers/staging/media/solo6x10/core.c              |   32 +-
 include/linux/ivtv.h                               |    6 +-
 include/linux/videodev2.h                          |  149 ++-
 include/media/adv7183.h                            |   47 +
 include/media/blackfin/bfin_capture.h              |   37 +
 include/media/blackfin/ppi.h                       |   74 ++
 include/media/davinci/vpif_types.h                 |    2 +
 include/media/gpio-ir-recv.h                       |   22 +
 include/media/mt9m032.h                            |   36 +
 include/media/rc-map.h                             |    3 +
 include/media/s5p_hdmi.h                           |   35 +
 include/media/sh_mobile_ceu.h                      |    2 +
 include/media/sii9234.h                            |   24 +
 include/media/tuner.h                              |    1 +
 include/media/v4l2-chip-ident.h                    |    6 +
 include/media/v4l2-ctrls.h                         |   13 +
 include/media/v4l2-dev.h                           |    3 +
 include/media/v4l2-ioctl.h                         |    4 +
 include/sound/tea575x-tuner.h                      |    6 +-
 sound/i2c/other/tea575x-tuner.c                    |  169 ++-
 sound/pci/es1968.c                                 |   15 +
 sound/pci/fm801.c                                  |   20 +-
 313 files changed, 18529 insertions(+), 7057 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
 create mode 100644 Documentation/video4linux/fimc.txt
 create mode 100644 drivers/media/dvb/dvb-usb/az6007.c
 create mode 100644 drivers/media/dvb/dvb-usb/rtl28xxu.c
 create mode 100644 drivers/media/dvb/dvb-usb/rtl28xxu.h
 create mode 100644 drivers/media/dvb/frontends/m88rs2000.c
 create mode 100644 drivers/media/dvb/frontends/m88rs2000.h
 create mode 100644 drivers/media/dvb/frontends/rtl2830.c
 create mode 100644 drivers/media/dvb/frontends/rtl2830.h
 create mode 100644 drivers/media/dvb/frontends/rtl2830_priv.h
 create mode 100644 drivers/media/radio/radio-isa.c
 create mode 100644 drivers/media/radio/radio-isa.h
 create mode 100644 drivers/media/radio/radio-keene.c
 create mode 100644 drivers/media/rc/gpio-ir-recv.c
 create mode 100644 drivers/media/rc/keymaps/rc-it913x-v1.c
 create mode 100644 drivers/media/rc/keymaps/rc-it913x-v2.c
 create mode 100644 drivers/media/rc/keymaps/rc-kworld-pc150u.c
 create mode 100644 drivers/media/video/adv7183.c
 create mode 100644 drivers/media/video/adv7183_regs.h
 create mode 100644 drivers/media/video/aptina-pll.c
 create mode 100644 drivers/media/video/aptina-pll.h
 create mode 100644 drivers/media/video/blackfin/Kconfig
 create mode 100644 drivers/media/video/blackfin/Makefile
 create mode 100644 drivers/media/video/blackfin/bfin_capture.c
 create mode 100644 drivers/media/video/blackfin/ppi.c
 create mode 100644 drivers/media/video/mt9m032.c
 create mode 100644 drivers/media/video/mx2_emmaprp.c
 create mode 100644 drivers/media/video/s5p-tv/sii9234_drv.c
 create mode 100644 drivers/media/video/vs6624.c
 create mode 100644 drivers/media/video/vs6624_regs.h
 create mode 100644 include/media/adv7183.h
 create mode 100644 include/media/blackfin/bfin_capture.h
 create mode 100644 include/media/blackfin/ppi.h
 create mode 100644 include/media/gpio-ir-recv.h
 create mode 100644 include/media/mt9m032.h
 create mode 100644 include/media/s5p_hdmi.h
 create mode 100644 include/media/sii9234.h


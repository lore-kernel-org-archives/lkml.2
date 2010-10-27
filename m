Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467Ab0J0Odp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:33:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193Ab0J0Odm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:33:42 -0400
Message-ID: <4CC8380D.3040802@redhat.com>
Date: Wed, 27 Oct 2010 12:32:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from
	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For the changes we have for 2.6.37. This covers lots of fixes, cleanups and improvements
at the existing drivers. It also ports almost all remaining V4L1 drivers to V4L2 and
move a few obsolete drivers to staging, as we don't have any means to test them if
migrating them to V4L2, and such changes aren't trivial. As usual, there are several
new IR, frontend and video devices added in this series.

Thanks!
Mauro

---

The following changes since commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f:

  Linux 2.6.36 (2010-10-20 13:30:22 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Adrian Taylor (1):
      [media] Support for Elgato Video Capture

Alan Young (4):
      [media] hdpvr: remove unnecessary sleep in hdpvr_config_call
      [media] hdpvr: remove unecessary sleep in buffer drain loop
      [media] hdpvr: print firmware date
      [media] hdpvr: decrease URB timeout to 90ms

Alexander Goncharov (1):
      V4L/DVB: gspca - sonixj: Add webcam 0c45:612b

Anatolij Gustschin (1):
      V4L/DVB: v4l: fsl-viu.c: add slab.h include to fix compile breakage

Andrew Morton (1):
      [media] drivers/media/video/cx23885/cx23885-core.c: fix cx23885_dev_checkrevision()

Andy Shevchenko (2):
      V4L/DVB: media: cx23885: use '%pM' format to print MAC address
      [media] dvb: mantis: use '%pM' format to print MAC address

Andy Walls (3):
      V4L/DVB: gspca_cpia1: Add basic v4l2 illuminator controls for the Intel Play QX3
      V4L/DVB: gspca_cpia1: Restore QX3 illuminators' state on resume
      V4L/DVB: gspca_cpia1: Disable illuminator controls if not an Intel Play QX3

Antti Palosaari (38):
      V4L/DVB: NXP TDA18218 silicon tuner driver
      V4L/DVB: af9013: add support for tda18218 silicon tuner
      V4L/DVB: af9015: add support for tda18218 silicon tuner
      V4L/DVB: af9015: add missing TDA18218 Kconfig option
      V4L/DVB: af9015: simple comment update
      V4L/DVB: af9015: fix bug introduced by commit 490ade7e3f4474f626a8f5d778ead4e599b94fbc
      V4L/DVB: af9013: add support for MaxLinear MxL5007T tuner
      V4L/DVB: af9015: add support for TerraTec Cinergy T Stick Dual RC
      V4L/DVB: af9015: add remote support for TerraTec Cinergy T Stick Dual RC
      V4L/DVB: af9015: map TerraTec Cinergy T Stick Dual RC remote to device ID
      V4L/DVB: af9015: reimplement remote controller
      V4L/DVB: af9013: optimize code size
      V4L/DVB: af9015: use value from config instead hardcoded one
      [media] af9013: optimize code size
      [media] af9013: cache some reg values to reduce reg reads
      [media] af9015: make checkpatch.pl happy
      [media] af9015: remove needless variable set
      [media] TerraTec remote controller keytable
      [media] MSI DIGIVOX mini III remote controller keytable
      [media] TrekStor DVB-T USB Stick remote controller
      [media] Digittrade DVB-T USB Stick remote controller keytable
      [media] AverMedia RM-KS remote controller keytable
      [media] LeadTek Y04G0051 remote controller keytable
      [media] TwinHan AzureWave AD-TU700(704J) remote controller
      [media] A-Link DTU(m) remote controller
      [media] MSI DIGIVOX mini II remote controller
      [media] rename rc-msi-digivox.c -> rc-msi-digivox-iii.c
      [media] Total Media In Hand remote controller
      [media] fix MSI DIGIVOX mini III remote controller power buttons
      [media] fix TerraTec remote controller PIP button
      [media] fix A-Link DTU(m) remote controller PIP button
      [media] af9015: move remote controllers to new RC core
      [media] Anysee remote controller
      [media] anysee: switch to RC core
      [media] af9015: RC fixes and improvements
      [media] DigitalNow TinyTwin remote controller
      [media] af9015: map DigitalNow TinyTwin v2 remote
      [media] af9015: support for DigitalNow TinyTwin v3 [1f4d:9016]

Arnd Bergmann (2):
      V4L/DVB: dvb-core: kill the big kernel lock
      V4L/DVB: dvb/bt8xx: kill the big kernel lock

Baruch Siach (2):
      V4L/DVB: mx2_camera: fix comment typo
      V4L/DVB: mx2_camera: implement forced termination of active buffer for mx25

Ben Hutchings (1):
      [media] vivi: Don't depend on FONTS

Dan Carpenter (5):
      [media] IR/streamzap: fix usec to nsec conversion
      [media] saa7134: add test after for loop
      [media] cx88: uninitialized variable
      [media] cx231xx: fix double lock typo
      [media] s5p-fimc: add unlock on error path

Daniel Drake (6):
      [media] cafe_ccic: Fix hang in command write processing
      [media] ov7670: implement VIDIOC_ENUM_FRAMESIZES
      [media] cafe_ccic: Implement VIDIOC_ENUM_FRAMEINTERVALS and ENUM_FRAMESIZES
      [media] ov7670: fix QVGA visible area
      [media] ov7670: allow configuration of image size, clock speed, and I/O method
      [media] cafe_ccic: Configure ov7670 correctly

David Härdeman (1):
      V4L/DVB: imon: split mouse events to a separate input dev

Derek Kelly (4):
      [media] gp8psk: Add support for the Genpix Skywalker-2
      [media] dvb-usb-gp8psk: Fix driver name
      [media] dvb-usb-gp8psk: Fix tuner timeout (against git)
      [media] av7110: Fix driver name

Devin Heitmueller (27):
      [media] cx231xx: add USB ID Hauppauge model 111301
      [media] cx231xx: fix race condition in DVB initialization
      [media] Use smaller i2c transaction size with 18271 tuner
      [media] s5h1432: fix codingstyle issues
      [media] cx231xx-dvb: remove unused variable
      [media] cx231xx: fix format string warning
      [media] cx231xx: Fix VBI parameters for sampling rate and offset
      [media] cx231xx: Ensure VBI fields are sent in the correct order
      [media] cx231xx: remove board specific initialization
      [media] cx231xx: reduce log severity for some debug events
      [media] cx231xx: make video scaler work properly
      [media] cx231xx: Clear avmode bits before setting
      [media] cx231xx: do not call video_mux as part of isoc setup
      [media] cx231xx: Set the power mode instead of using the digital mux GPIOs
      [media] cx231xx: Remove hack which puts device into bulk mode
      [media] cx231xx: set standard tune to last known frequency when switching inputs
      [media] cx231xx: set correct i2c port for Exeter tuner
      [media] cx231xx: Add initial support for Hauppauge USB-Live2
      [media] cx231xx: make output mode configurable via the board profile
      [media] cx231xx: fixup video grabber board profile
      [media] cx231xx: move printk() line related to 417 initialization
      [media] cx231xx: remove i2c ir stubs
      [media] cx231xx: Make the DIF configuration based on the tuner not the board id
      [media] cx231xx: remove board specific check for Colibri configuration
      [media] cx231xx: whitespace cleanup
      [media] cx231xx: properly set active line count for PAL/SECAM
      [media] cx231xx: Fix vblank/vactive line counts for PAL/SECAM

Dmitri Belimov (1):
      V4L/DVB: tm6000+audio

Dmitry Belimov (1):
      [media] tm6000: Improve audio standards handling and add SECAM-DK

Dr. David Alan Gilbert (1):
      [media] Guard a divide in v4l1 compat layer

Gavin Hurlbut (3):
      [media] Change the second input names to include " 2" to distinguish them
      [media] Fix the negative -E{BLAH} returns from fops_read
      [media] Fix the -E{*} returns in the VBI device as well

Geert Uytterhoeven (1):
      [media] lirc: Make struct file_operations pointer const

Guennadi Liakhovetski (7):
      V4L/DVB: V4L2: avoid name conflicts in macros
      V4L/DVB: V4L2: add a generic function to find the nearest discrete format to the required one
      V4L/DVB: soc-camera: allow only one video queue per device
      [media] V4L: add IMX074 sensor chip ID
      [media] V4L: add an IMX074 sensor soc-camera / v4l2-subdev driver
      [media] V4L: sh_mobile_ceu_camera: use default .get_parm() and .set_parm() operations
      [media] v4l: document new Bayer and monochrome pixel formats

Hans Verkuil (85):
      V4L/DVB: v4l: add new YUV mediabus formats
      V4L/DVB: tvp514x: add support for enum/g/try/s_mbus_fmt
      V4L/DVB: tvp7002: add support for enum/try/g/s_mbus_fmt
      V4L/DVB: vpfe_capture: convert to new mediabus API
      V4L/DVB: tvp514x: remove obsolete enum/try/s/g_fmt
      V4L/DVB: tvp7002: remove obsolete enum/try/s/g_fmt
      V4L/DVB: go7007: convert to use the mediabus API
      V4L/DVB: cx25821: convert to the mediabus API
      V4L/DVB: v4l: add RGB444 mediabus formats
      V4L/DVB: ov7670: add enum/try/s_mbus_fmt support
      V4L/DVB: cafe_ccic: convert to the mediabus API
      V4L/DVB: ov7670: remove obsolete enum/try/s_fmt ops
      V4L/DVB: v4l2-subdev: remove obsolete enum/try/s/g_fmt
      V4L/DVB: saa5246a/saa5249: Remove obsolete teletext drivers
      V4L/DVB: videotext: remove this obsolete API
      V4L/DVB: Documentation: update now that the vtx/videotext API has been removed
      V4L/DVB: V4L Doc: fix DocBook syntax errors
      V4L/DVB: V4L Doc: document V4L2_CAP_RDS_OUTPUT capability
      V4L/DVB: V4L Doc: correct the documentation for VIDIOC_QUERYMENU
      V4L/DVB: V4L Doc: removed duplicate link
      V4L/DVB: pwc: fully convert driver to V4L2
      V4L/DVB: pwc: remove BKL
      V4L/DVB: vp27smpx: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: wm8739: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: cs5345: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: saa717x: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: saa7115: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: tda9840: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: ov7670: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: mt9v011: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: upd64031a: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: saa6588: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: saa6752hs: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: bt819: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: indycam: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: m52790: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: saa7185: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: msp3400: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: bt866: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: tea6415c: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: tvaudio: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: wm8775: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: adv7175: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: saa7191: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: bt856: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: tlv320aic23b: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: tuner: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: tda9875: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: saa7110: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: tda7432: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: tea6420: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: cs53l32a: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: vpx3220: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: tvp5150: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: upd64083: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: saa7127: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: cx25840: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: adv7170: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: ks0127: remove obsolete v4l2_i2c_drv.h header
      V4L/DVB: au8522_decoder: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: s2250: remove obsolete v4l2-i2c-drv.h header
      V4L/DVB: v4l: remove unused i2c-id.h headers
      V4L/DVB: saa7146/tuner: remove mxb hack
      V4L/DVB: ir-kbd-i2c: remove obsolete I2C_HW_B_CX2341X test
      V4L/DVB: tm6000: removed unused i2c adapter ID
      V4L/DVB: v4l: remove obsolete include/media/v4l2-i2c-drv.h file
      V4L/DVB: usbvision: remove BKL from usbvision
      V4L/DVB: tvaudio: remove obsolete tda8425 initialization
      V4L/DVB: v4l2-dev: after a disconnect any ioctl call will be blocked
      V4L/DVB: v4l2-dev: remove get_unmapped_area
      V4L/DVB: v4l2: add core serialization lock
      V4L/DVB: videobuf: prepare to make locking optional in videobuf
      V4L/DVB: videobuf: add ext_lock argument to the queue init functions
      V4L/DVB: videobuf: add queue argument to videobuf_waiton()
      V4L/DVB: vivi: remove BKL
      V4L/DVB: em28xx: remove BKL
      V4L/DVB: em28xx: the default std was not passed on to the subdevs
      V4L/DVB: radio-mr800: remove BKL
      V4L/DVB: cpia2: remove V4L1 support from this driver
      V4L/DVB: videobuf: add ext_lock argument to the queue init functions (part 2)
      V4L/DVB: v4l2-common: Move v4l2_find_nearest_format from videodev2.h to v4l2-common.h
      [media] radio-mr800: fix locking order
      [media] Re: [git:v4l-dvb/v2.6.37] [media] Fix compilation of Siliconfile SR030PC30 VGA camera
      [media] msp3400: fix mute audio regression
      [media] [RFC] radio-mr800: locking fixes

Hans de Goede (9):
      V4L/DVB: gspca_xirlink_cit: New gspca subdriver replacing v4l1 usbvideo/ibmcam.c
      V4L/DVB: gspca_xirlink_cit: Add support for Model 1, 2 & 4 cameras
      V4L/DVB: gspca_xirlink_cit: Add support for camera with a bcd version of 0.01
      V4L/DVB: gspca_xirlink_cit: Use alt setting -> fps formula for model 1 cams too
      V4L/DVB: gspca_xirlink_cit: support bandwidth changing for devices with 1 alt setting
      V4L/DVB: Mark usbvideo ibmcam driver as deprecated
      V4L/DVB: gspca_*: correct typo in my email address in various subdrivers
      V4L/DVB: gspca_konica: New gspca subdriver for konica chipset using cams
      V4L/DVB: gspca_xirlink_cit: adjust ibm netcam pro framerate for available bandwidth

Henrik Kurelid (1):
      [media] firedtv: add parameter to fake ca_system_ids in CA_INFO

James M McLaren (1):
      [media] hdpvr: Add missing URB_NO_TRANSFER_DMA_MAP flag

Janne Grunau (4):
      [media] hdpvr: add two known to work firmware versions
      [media] hdpvr: use AC3 as default audio codec for SPDIF
      [media] hdpvr: fix audio input setting for pre AC3 firmwares
      [media] hdpvr: add usb product id 0x4903

Janusz Krzysztofik (3):
      [media] SoC Camera: add driver for OMAP1 camera interface
      [media] SoC Camera: add driver for OV6650 sensor
      [media] SoC Camera: add support for g_parm / s_parm operations

Jarkko Nikula (1):
      V4L/DVB: radio-si4713: Release i2c adapter in driver cleanup paths

Jarod Wilson (31):
      V4L/DVB: IR/streamzap: functional in-kernel decoding
      V4L/DVB: IR: export ir_keyup so imon driver can use it directly
      V4L/DVB: IR/imon: protect ictx's kc and last_keycode w/spinlock
      V4L/DVB: IR/imon: set up mce-only devices w/mce keytable
      V4L/DVB: IR/lirc_dev: check for valid irctl in unregister path
      [media] IR: add driver for Nuvoton w836x7hg integrated CIR
      [media] nuvoton-cir: add proper rx fifo overrun handling
      [media] IR/Kconfig: sort hardware entries alphabetically
      [media] IR/lirc: further ioctl portability fixups
      [media] staging/lirc: ioctl portability fixups
      [media] lirc: wire up .compat_ioctl to main ioctl handler
      [media] lirc_dev: fixup error messages w/missing newlines
      [media] IR/streamzap: shorten up some define names for readability
      [media] IR/nuvoton: address all checkpatch.pl issues
      [media] dvb: remove obsolete lgdt3304 driver
      [media] lirc_dev: sanitize function and struct names a bit
      [media] lirc_dev: fix pointer to owner
      [media] lirc_dev: get irctl from irctls by inode again
      [media] lirc_dev: more error-checking improvements
      [media] lirc_dev: call cdev_del *after* irctl cleanup
      [media] lirc_dev: rework storage for cdev data
      [media] lirc_parallel: build on smp and kill dead code
      [media] lirc_igorplugusb: assorted fixups
      [media] lirc_igorplugusb: handle hw buffer overruns better
      [media] lirc_igorplugusb: add Fit PC2 device ID
      [media] lirc_it87: add another pnp id
      [media] mceusb: add symbolic names for commands
      [media] mceusb: hook debug print spew directly into parser routine
      [media] imon: fix my egregious brown paper bag w/rdev/idev split
      [media] imon: remove redundant change_protocol call
      [media] imon: fix nomouse modprobe option

Jean Delvare (7):
      V4L/DVB: cx22702: Clean up register access functions
      V4L/DVB: cx22702: Drop useless initializations to 0
      V4L/DVB: cx22702: Avoid duplicating code in branches
      V4L/DVB: cx22702: Some things never change
      V4L/DVB: cx22702: Simplify cx22702_set_tps()
      [media] i2c: Stop using I2C_CLASS_TV_ANALOG
      [media] i2c: Stop using I2C_CLASS_TV_DIGITAL

Jean-François Moine (28):
      V4L/DVB: gspca - all modules: Remove useless module load/unload messages
      V4L/DVB: gspca - all modules: Display error messages when gspca debug disabled
      V4L/DVB: gspca - sn9c20x: Fix the number of bytes per line
      V4L/DVB: gspca - sn9c20x: Better image sizes
      V4L/DVB: gspca - sonixj: Webcam 0c45:6102 added
      V4L/DVB: v4l2: Add illuminator controls
      V4L/DVB: gspca - benq: Display error messages when gspca debug disabled
      V4L/DVB: gspca - benq: Remove useless module load/unload messages
      V4L/DVB: gspca - cpia1: Fix compilation warning when gspca debug disabled
      V4L/DVB: gspca - spca505: Remove the eeprom write commands of NxUltra
      V4L/DVB: gspca - sonixj: Propagate USB errors to higher level
      V4L/DVB: gspca - many subdrivers: Handle the buttons when CONFIG_INPUT=m
      V4L/DVB: gspca - mr97310a: Declare static the constant tables
      V4L/DVB: gspca - sonixj: Add sensor mi0360b
      V4L/DVB: gspca - sonixj: Bad detection of the end of image
      V4L/DVB: gspca - sonixj: Have 0c45:6130 handled by sonixj instead of sn9c102
      [media] gspca - main: New video control mechanism
      [media] gspca - stk014: Use the new video control mechanism
      [media] gspca - ov519: Use the new video control mechanism
      [media] gspca - sonixj: Use the new video control mechanism
      [media] gspca - main: Have discontinuous sequence numbers when frames are lost
      [media] gspca - mars: Use the new video control mechanism
      [media] gspca - mars: Propagate USB errors to higher level
      [media] gspca - mars: Add illuminator controls
      [media] gspca - main: Fix a regression with the PS3 Eye webcam
      [media] gspca - sonixj: Fix a regression of sensors hv7131r and mi0360
      [media] gspca - sonixj: Fix a regression with sensor hv7131r
      [media] gspca: Fix coding style issues

Jiri Slaby (1):
      [media] drivers/media/IR/ene_ir.c: fix NULL dereference

Joe Perches (2):
      V4L/DVB: drivers/media/video/zoran: Don't use initialized char array
      [media] drivers/media/IR/imon.c: Use pr_err instead of err

Jonathan Corbet (2):
      [media] ov7670: implement VIDIOC_ENUM_FRAMEINTERVALS
      [media] Add the via framebuffer camera controller driver

Julia Lawall (8):
      V4L/DVB: drivers/media/video: Adjust confusing if indentation
      V4L/DVB: drivers/media/video/zoran: Use available error codes
      V4L/DVB: drivers/media: Use available error codes
      V4L/DVB: drivers/media/video: Use available error codes
      V4L/DVB: drivers/media/video/em28xx: Remove potential NULL dereference
      V4L/DVB: drivers/media/dvb/siano: Remove double test
      [media] drivers/media/dvb/ttpci/av7110_av.c: Add missing error handling code
      [media] drivers/media/video/bt8xx: Adjust confusing if indentation

Laurent Pinchart (28):
      V4L/DVB: v4l: Use v4l2_get_subdevdata instead of accessing v4l2_subdev::priv
      V4L/DVB: v4l: Add a v4l2_subdev host private data field
      [media] uvcvideo: Blacklist more controls for Hercules Dualpix Exchange
      [media] uvcvideo: Constify the uvc_entity_match_guid arguments
      [media] uvcvideo: Print query name in uvc_query_ctrl()
      [media] uvcvideo: Update e-mail address and copyright notices
      [media] uvcvideo: Set bandwidth to at least 1024 with the FIX_BANDWIDTH quirk
      [media] uvcvideo: Generate discontinuous sequence numbers when frames are lost
      [media] uvcvideo: Hardcode the index/selector relationship for XU controls
      [media] uvcvideo: Embed uvc_control_info inside struct uvc_control
      [media] uvcvideo: Delay initialization of XU controls
      [media] uvcvideo: Fix bogus XU controls information
      [media] uvcvideo: Fix uvc_query_v4l2_ctrl() and uvc_xu_ctrl_query() locking
      [media] v4l: Load I2C modules based on modalias
      [media] v4l: Remove hardcoded module names passed to v4l2_i2c_new_subdev*
      [media] go7007: Add MODULE_DEVICE_TABLE to the go7007 I2C modules
      [media] go7007: Fix the TW2804 I2C type name
      [media] go7007: Don't use module names to load I2C modules
      [media] zoran: Don't use module names to load I2C modules
      [media] pvrusb2: Don't use module names to load I2C modules
      [media] sh_vou: Don't use module names to load I2C modules
      [media] radio-si4713: Don't use module names to load I2C modules
      [media] soc_camera: Don't use module names to load I2C modules
      [media] vpfe_capture: Don't use module names to load I2C modules
      [media] vpif_display: Don't use module names to load I2C modules
      [media] vpif_capture: Don't use module names to load I2C modules
      [media] ivtv: Don't use module names to load I2C modules
      [media] cx18: Don't use module names to load I2C modules

Malcolm Priestley (5):
      V4L/DVB: Support for Sharp IX2505V (marked B0017) DVB-S silicon tuner
      V4L/DVB: Support or LME2510(C) DM04/QQBOX USB DVB-S BOXES
      V4L/DVB: STV0288 Incorrect bit sample for Vitterbi status
      [media] DiSEqC bug fixed for stv0288 based interfaces
      [media] lmedm04: driver for DM04/QQBOX updated to version 1.60

Martin Rubli (1):
      [media] uvcvideo: Remove sysadmin requirements for UVCIOC_CTRL_MAP

Mats Randgaard (3):
      V4L/DVB: vpif_cap/disp: Removed section mismatch warning
      V4L/DVB: vpif_cap/disp: Replaced kmalloc with kzalloc
      V4L/DVB: vpif_cap: don't ignore return code of videobuf_poll_stream()

Matthew Garrett (1):
      V4L/DVB: uvc: Enable USB autosuspend by default on uvcvideo

Matti Aaltonen (3):
      [media] V4L2: Add seek spacing and RDS CAP bits
      [media] Documentation: v4l: Add hw_seek spacing and two TUNER_RDS_CAP flags
      [media] [RFC,1/1] V4L2: Use new CAP bits in existing RDS capable drivers

Mauro Carvalho Chehab (72):
      gspca/konica: Fix compilation merge conflict
      V4L/DVB: Add documentation about the Ibmcam/Konica new gspca driver formats
      V4L/DVB: cx88: Fix some gcc warnings
      V4L/DVB: cx25821: fix gcc warning when compiled with allyesconfig
      V4L/DVB: ix2505v: make scripts/checkpatch.pl happy
      devices.txt: Remove the old obsolete vtx device nodes
      V4L/DVB: bttv: Move PV951 IR to the right driver
      V4L/DVB: Remove the usage of I2C_HW_B_CX2388x on ir-kbd-i2c.c
      V4L/DVB: saa7134: get rid of I2C_HW_SAA7134
      V4l/DVB: saa7134: properly mark some functions as static
      V4L/DVB: saa7134: split RC code into a different module
      V4L/DVB: Fix Kconfig dependencies for VIDEO_IR
      V4L/DVB: radio-si470x: remove the BKL lock used internally at the driver
      V4L/DVB: radio-si470x: use unlocked ioctl
      V4L/DVB: bttv-driver: document functions using mutex_lock
      V4L/DVB: bttv: Fix mutex unbalance at bttv_poll
      V4L/DVB: bttv: fix driver lock and remove explicit calls to BKL
      V4L/DVB: bttv: use unlocked ioctl
      V4L/DVB: cx88: Remove BKL
      V4L/DVB: Deprecate cpia driver (used for parallel port webcams)
      V4L/DVB: Deprecate stradis driver
      V4L/DVB: em28xx: fix a compilation warning
      V4L/DVB: tda18271: Add some hint about what tda18217 reg ID returned
      V4L/DVB: videobuf-dma-sg: Fix a warning due to the usage of min(PAGE_SIZE, arg)
      V4L/DVB: saa7134-input can't be a module right now
      V4L/DVB: tm6000: Fix warnings due to a small array size
      V4L/DVB: Fix a merge conflict that affects unlock_ioctl
      [media] videobuf-dma-sg: Use min_t(size_t, PAGE_SIZE ..)
      [media] lirc_igorplugusb: Fix a compilation waring
      [media] staging/tm6000: Fix a warning message
      [media] cx231xx: remove a printk warning at -avcore and at -417
      [media] cx231xx: fix Kconfig dependencies
      [media] cx231xx: properly implement URB control messages log
      [media] cx231xx: properly use the right tuner i2c address
      [media] cx231xx: better handle the master port enable command
      [media] cx231xx: Only change gpio direction when needed
      [media] tda18271: allow restricting max out to 4 bytes
      [media] cx231xx-audio: fix some locking issues
      [media] CodingStyle cleanup at s5h1432 and cx231xx
      [media] cx231xx-417: Fix a gcc warning
      [media] cx231xx: declare static functions as such
      [media] cx231xx: remove some unused functions
      [media] cx231xx: Colibri carrier offset was wrong for PAL/M
      [media] cx231xx: use core-assisted lock
      [media] em28xx-audio: fix some locking issues
      [media] tm6000: add audio standards table
      [media] V4L-DVB: tm6000: Move VBI init to a separate function
      [media] ir: avoid race conditions at device disconnect
      [media] saa7134: port Asus P7131 Hybrid to use the new rc-core
      [media] Add a todo file for staging/tm6000
      [media] ir: properly handle an error at input_register
      [media] saa7164: fix a warning at some printk's on i386
      [media] saa7164: Don't use typedefs
      [media] saa7134: Fix lots os spaces at the wrong places
      [media] cx25840: Remove a now unused variable
      [media] tm6000: don't use BKL at the driver
      [media] tm6000-alsa: fix some locking issues
      [media] tm6000: Use just one lock for devlist
      [media] tm6000: fix resource locking
      [media] mceusb: add support for cx231xx-based IR (e. g. Polaris)
      [media] cx231xx: Only register USB interface 1
      [media] cx231xx: Remove IR support from the driver
      [media] cx231xx: Fix compilation breakage if DVB is not selected
      [media] ir-raw-event: Fix a stupid error at a printk
      [media] mceusb: improve ir data buffer parser
      [media] mceusb: add a per-model structure
      [media] mceusb: allow a per-model RC map
      [media] mceusb: Allow a per-model device name
      [media] Documentation/video4linux/CARDLIST.[cx88|saa7134]
      tm6000: Remove some ugly debug code
      [media] DocBook/v4l: Add missing formats used on gspca cpia1 and sn9c2028
      videodev2.h.xml: Update to reflect the latest changes at videodev2.h

Maxim Levitsky (9):
      [media] IR: plug races in IR raw thread
      [media] IR: make sure we register the input device when it is safe to do so
      [media] IR: ene_ir: updates
      [media] IR: extend and sort the MCE keymap
      [media] IR: ene_ir: few bugfixes
      [media] IR: extend ir_raw_event and do refactoring
      [media] IR: ene_ir: add support for carrier reports
      [media] IR: ene_ir: don't upload all settings on each TX packet
      [media] IR: initialize ir_raw_event in few more drivers

Michael Grzeschik (4):
      V4L/DVB: mt9m111: register cleanup hex to dec bitoffset
      V4L/DVB: mx2_camera: remove emma limitation for RGB565
      V4L/DVB: mx2_camera: add informative camera clock frequency printout
      [media] mt9m111: changed MIN_DARK_COLS to MT9M131 spec count

Michael Krufky (1):
      [media] cx231xx: add support for Hauppauge EXETER

Michel Garnier (1):
      [media] em28xx: Add dvb support for Terratec Cinergy Hybrid T USB XS FR

Németh Márton (2):
      [media] gspca - sonixj: Remove magic numbers for delay
      [media] gspca - sonixj: Add horizontal and vertical flip for po2030n

Palash Bandyopadhyay (2):
      [media] s5h1432: Add new s5h1432 driver
      [media] cx231xx: Added support for Carraera, Shelby, RDx_253S and VIDEO_GRABBER

Paul Walmsley (1):
      [media] tvp5150: COMPOSITE0 input should not force-enable TV mode

Pawel Osciak (1):
      [media] v4l: videobuf: remove unused is_userptr variable

Pete Eberlein (1):
      [media] go7007: MJPEG buffer overflow

Ruslan Pisarev (8):
      [media] Staging: cx25821: remove spaces after parenthesis
      [media] Staging: cx25821: fix braces and space coding style issues
      [media] tm6000: don't initialize static var on tm6000-i2c.c
      [media] Staging: tm6000: fix braces, tabs, comments and space coding style issue in tm6000-video.c
      [media] tm6000: fix comments coding style issue in group of files
      [media] Staging: tm6000: Delete braces from return in tm6000-cards.c
      [media] tm6000: fix macros and comments coding style issue in tm6000.h
      [media] tm6000: fix a macro coding style issue

Sascha Hauer (1):
      [media] v4l2-mediabus: Add pixelcodes for BGR565 formats

Sergey Ivanov (1):
      [media] Twinhan 1027 + IR Port support

Stefan Lippers-Hollmann (1):
      V4L/DVB: af9015: add USB ID for Terratec Cinergy T Stick RC MKII

Stefan Ringel (1):
      V4L/DVB: tm6000: bugfix param string

Stephen Rothwell (1):
      [media] v4l-dvb: using vmalloc needs vmalloc.h in cx231xx-417.c

Steven Toth (44):
      [media] saa7164: basic definitions for -encoder.c
      [media] saa7164: Add some encoder firmwares message types and structs
      [media] saa7164: convert buffering structs to be more generic
      [media] saa7164: add various encoder message functions
      [media] saa7164: Implement encoder irq handling in a deferred work queue
      [media] saa7164: command dequeue fixup to clean the bus after error
      [media] saa7164: allow the encoder GOP structure to be configured
      [media] saa7164: generate a fixed kernel warning if the irq is 'late'
      [media] saa7164: add support for encoder CBR and VBR optionally
      [media] saa7164: allow the IBP reference distance to be configurable
      [media] saa7164: implement encoder peak bitrate feature
      [media] saa7164: allow encoder output format to be user configurable
      [media] saa7164: allow variable length GOP sizes and switch encoder default to CBR
      [media] saa7164: patches to monitor TS payload for inconsistencies
      [media] saa7164: allow the number of encoder buffers to be user configurable
      [media] saa7164: measure via histograms various irq and queue latencies
      [media] saa7164: add guard bytes around critical buffers to detect failure
      [media] saa7164: buffer crc checks and ensure we use the memcpy func
      [media] saa7164: adjust the PS pack size handling to fill buffers 100%
      [media] saa7164: Implement resolution control firmware command
      [media] saa7164: mundane buffer debugging changes to track issues
      [media] saa7164: irqhandler cleanup and helper function added
      [media] saa7164: code cleanup
      [media] saa7164: allow DMA engine buffers to vary in size between analog and digital
      [media] saa7164: New firmware changes, new size, new filename
      [media] saa7164: Avoid spurious error after firmware starts
      [media] saa7164: rename a structure for readability
      [media] saa7164: Add missing saa7164-vbi.c file
      [media] saa7164: add NTSC VBI support
      [media] saa7164: add firmware debug message collection and procfs changes
      [media] saa7164: VBI irq cleanup and V4L VBI raw pitch adjustments
      [media] saa7164: Monitor the command bus and check for inconsistencies
      [media] saa7164: enforce the march 10th firmware is used
      [media] saa7164: collect/show the firmware debugging via a thread
      [media] saa7164: monitor the RISC cpu load via a thread
      [media] saa7164: change debug to saa_debug
      [media] saa7164: fix vbi compiler warnings
      [media] saa7164: Some whitespace cleanup
      [media] saa7164: saa7164-buffer.c line 274 bugfix
      [media] saa7164: bugfix, avoid oops when driver unloads without firmware
      [media] saa7164: Remove loud debugging during video_poll()
      [media] saa7164: Disable firmware debug message output
      [media] saa7164: Remove V4L2_CAP_STREAMING capability flag
      [media] saa7164: Removed use of the BKL

Sven Barth (1):
      [media] Add support for AUX_PLL on cx2583x chips

Sylwester Nawrocki (9):
      [media] s5p-fimc: Register definition cleanup
      [media] s5p-fimc: mem2mem driver refactoring and cleanup
      [media] s5p-fimc: Fix 90/270 deg rotation errors
      [media] s5p-fimc: Do not lock both buffer queues in s_fmt
      [media] s5p-fimc: Add camera capture support
      [media] s5p-fimc: Add suport for FIMC on S5PC210 SoCs
      [media] Add driver for Siliconfile SR030PC30 VGA camera
      [media] SR030PC30: Avoid use of uninitialized variables
      [media] s5p-fimc: dubious one-bit signed bitfields

Thomas Gleixner (1):
      V4L/DVB: dvb: Convert "mutex" to semaphore

Tommy Jonsson (1):
      [media] firedtv: support for PSK8 for S2 devices. To watch HD

Yann E. MORIN (1):
      [media] v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T)

lawrence rust (3):
      V4L/DVB: cx88: convert core->tvaudio into an enum
      V4L/DVB: drivers/media: Make static data tables and strings const
      [media] Nova-S-Plus audio line input

 Documentation/DocBook/media-entities.tmpl          |    6 +
 Documentation/DocBook/v4l/compat.xml               |   24 +-
 Documentation/DocBook/v4l/controls.xml             |   12 +-
 Documentation/DocBook/v4l/dev-rds.xml              |   68 +-
 Documentation/DocBook/v4l/dev-teletext.xml         |   29 +-
 Documentation/DocBook/v4l/pixfmt-packed-rgb.xml    |    2 +-
 Documentation/DocBook/v4l/pixfmt-srggb10.xml       |   90 +
 Documentation/DocBook/v4l/pixfmt-srggb8.xml        |   67 +
 Documentation/DocBook/v4l/pixfmt-y10.xml           |   79 +
 Documentation/DocBook/v4l/pixfmt.xml               |   32 +-
 Documentation/DocBook/v4l/v4l2.xml                 |   10 +-
 Documentation/DocBook/v4l/videodev2.h.xml          |  106 +-
 Documentation/DocBook/v4l/vidioc-g-dv-preset.xml   |    3 +-
 Documentation/DocBook/v4l/vidioc-g-dv-timings.xml  |    3 +-
 .../DocBook/v4l/vidioc-query-dv-preset.xml         |    2 +-
 Documentation/DocBook/v4l/vidioc-querycap.xml      |    7 +-
 Documentation/DocBook/v4l/vidioc-queryctrl.xml     |   18 +-
 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 +-
 Documentation/devices.txt                          |    3 -
 Documentation/dvb/get_dvb_firmware                 |   46 +-
 Documentation/dvb/lmedm04.txt                      |   58 +
 Documentation/feature-removal-schedule.txt         |   40 +-
 Documentation/ioctl/ioctl-number.txt               |    1 -
 Documentation/video4linux/CARDLIST.cx88            |    1 +
 Documentation/video4linux/CARDLIST.em28xx          |    3 +-
 Documentation/video4linux/CARDLIST.saa7134         |    2 +-
 Documentation/video4linux/bttv/MAKEDEV             |    1 -
 Documentation/video4linux/gspca.txt                |    2 +
 Documentation/video4linux/v4l2-framework.txt       |   35 +-
 arch/arm/mach-mx3/mach-pcm037.c                    |    2 -
 arch/arm/mach-mx3/mx31moboard-marxbot.c            |    1 -
 arch/arm/mach-mx3/mx31moboard-smartbot.c           |    1 -
 arch/arm/mach-pxa/em-x270.c                        |    1 -
 arch/arm/mach-pxa/ezx.c                            |    2 -
 arch/arm/mach-pxa/mioa701.c                        |    1 -
 arch/arm/mach-pxa/pcm990-baseboard.c               |    2 -
 arch/sh/boards/mach-ap325rxa/setup.c               |    1 -
 arch/sh/boards/mach-ecovec24/setup.c               |    4 -
 arch/sh/boards/mach-kfr2r09/setup.c                |    1 -
 arch/sh/boards/mach-migor/setup.c                  |    2 -
 arch/sh/boards/mach-se/7724/setup.c                |    1 -
 drivers/media/IR/Kconfig                           |   39 +-
 drivers/media/IR/Makefile                          |    2 +
 drivers/media/IR/ene_ir.c                          | 1046 ++++---
 drivers/media/IR/ene_ir.h                          |  275 +-
 drivers/media/IR/imon.c                            |  690 +++--
 drivers/media/IR/ir-core-priv.h                    |   22 +-
 drivers/media/IR/ir-jvc-decoder.c                  |    5 +-
 drivers/media/IR/ir-keytable.c                     |    7 +-
 drivers/media/IR/ir-lirc-codec.c                   |  135 +-
 drivers/media/IR/ir-nec-decoder.c                  |    5 +-
 drivers/media/IR/ir-raw-event.c                    |   81 +-
 drivers/media/IR/ir-rc5-decoder.c                  |    5 +-
 drivers/media/IR/ir-rc5-sz-decoder.c               |  154 +
 drivers/media/IR/ir-rc6-decoder.c                  |    5 +-
 drivers/media/IR/ir-sony-decoder.c                 |    5 +-
 drivers/media/IR/ir-sysfs.c                        |   37 +-
 drivers/media/IR/keymaps/Makefile                  |   16 +-
 drivers/media/IR/keymaps/rc-alink-dtu-m.c          |   68 +
 drivers/media/IR/keymaps/rc-anysee.c               |   93 +
 drivers/media/IR/keymaps/rc-asus-pc39.c            |   80 +-
 drivers/media/IR/keymaps/rc-avermedia-rm-ks.c      |   79 +
 drivers/media/IR/keymaps/rc-azurewave-ad-tu700.c   |  102 +
 drivers/media/IR/keymaps/rc-digitalnow-tinytwin.c  |   98 +
 drivers/media/IR/keymaps/rc-digittrade.c           |   82 +
 drivers/media/IR/keymaps/rc-leadtek-y04g0051.c     |   99 +
 drivers/media/IR/keymaps/rc-lme2510.c              |   68 +
 drivers/media/IR/keymaps/rc-msi-digivox-ii.c       |   67 +
 drivers/media/IR/keymaps/rc-msi-digivox-iii.c      |   85 +
 drivers/media/IR/keymaps/rc-rc5-streamzap.c        |   81 -
 drivers/media/IR/keymaps/rc-rc6-mce.c              |   88 +-
 drivers/media/IR/keymaps/rc-streamzap.c            |   82 +
 drivers/media/IR/keymaps/rc-terratec-slim.c        |   79 +
 drivers/media/IR/keymaps/rc-total-media-in-hand.c  |   85 +
 drivers/media/IR/keymaps/rc-trekstor.c             |   80 +
 drivers/media/IR/keymaps/rc-twinhan1027.c          |   87 +
 drivers/media/IR/lirc_dev.c                        |  133 +-
 drivers/media/IR/mceusb.c                          |  475 ++-
 drivers/media/IR/nuvoton-cir.c                     | 1246 ++++++++
 drivers/media/IR/nuvoton-cir.h                     |  408 +++
 drivers/media/IR/streamzap.c                       |  376 +--
 drivers/media/common/saa7146_fops.c                |    2 +-
 drivers/media/common/saa7146_i2c.c                 |    1 -
 drivers/media/common/saa7146_vbi.c                 |    2 +-
 drivers/media/common/saa7146_video.c               |    2 +-
 drivers/media/common/tuners/Kconfig                |    7 +
 drivers/media/common/tuners/Makefile               |    1 +
 drivers/media/common/tuners/tda18218.c             |  334 ++
 drivers/media/common/tuners/tda18218.h             |   45 +
 drivers/media/common/tuners/tda18218_priv.h        |  106 +
 drivers/media/common/tuners/tda18271-common.c      |   59 +-
 drivers/media/common/tuners/tda18271-fe.c          |   16 +-
 drivers/media/common/tuners/tda18271.h             |    5 +-
 drivers/media/common/tuners/xc5000.c               |    2 +-
 drivers/media/common/tuners/xc5000.h               |    4 +-
 drivers/media/dvb/b2c2/flexcop-i2c.c               |    3 -
 drivers/media/dvb/bt8xx/dst_ca.c                   |    7 +-
 drivers/media/dvb/dm1105/dm1105.c                  |    1 -
 drivers/media/dvb/dvb-core/dmxdev.c                |   17 +-
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c        |    8 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c          |    4 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |    2 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |    9 +-
 drivers/media/dvb/dvb-core/dvbdev.c                |   17 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |   12 +
 drivers/media/dvb/dvb-usb/Makefile                 |    3 +
 drivers/media/dvb/dvb-usb/af9015.c                 |  392 ++--
 drivers/media/dvb/dvb-usb/af9015.h                 |  735 +-----
 drivers/media/dvb/dvb-usb/anysee.c                 |   87 +-
 drivers/media/dvb/dvb-usb/dvb-usb-i2c.c            |    1 -
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    6 +
 drivers/media/dvb/dvb-usb/friio-fe.c               |    2 +-
 drivers/media/dvb/dvb-usb/gp8psk-fe.c              |    4 +-
 drivers/media/dvb/dvb-usb/gp8psk.c                 |    9 +-
 drivers/media/dvb/dvb-usb/lmedm04.c                | 1088 +++++++
 drivers/media/dvb/dvb-usb/lmedm04.h                |  173 ++
 drivers/media/dvb/firewire/firedtv-avc.c           |   61 +-
 drivers/media/dvb/firewire/firedtv-fe.c            |   36 +-
 drivers/media/dvb/frontends/Kconfig                |   24 +-
 drivers/media/dvb/frontends/Makefile               |    3 +-
 drivers/media/dvb/frontends/af9013.c               |  251 +--
 drivers/media/dvb/frontends/af9013.h               |    1 +
 drivers/media/dvb/frontends/af9013_priv.h          |   60 +-
 drivers/media/dvb/frontends/au8522_decoder.c       |   27 +-
 drivers/media/dvb/frontends/cx22702.c              |  123 +-
 drivers/media/dvb/frontends/cx24110.c              |    2 +-
 drivers/media/dvb/frontends/cx24123.c              |    1 -
 drivers/media/dvb/frontends/dibx000_common.c       |    1 -
 drivers/media/dvb/frontends/drx397xD.c             |    2 +-
 drivers/media/dvb/frontends/ix2505v.c              |  323 ++
 drivers/media/dvb/frontends/ix2505v.h              |   64 +
 drivers/media/dvb/frontends/lgdt3304.c             |  380 ---
 drivers/media/dvb/frontends/lgdt3304.h             |   45 -
 drivers/media/dvb/frontends/lgs8gxx.c              |    2 +-
 drivers/media/dvb/frontends/mt352.c                |    2 +-
 drivers/media/dvb/frontends/mt352.h                |    2 +-
 drivers/media/dvb/frontends/s5h1420.c              |    1 -
 drivers/media/dvb/frontends/s5h1432.c              |  415 +++
 drivers/media/dvb/frontends/s5h1432.h              |   91 +
 drivers/media/dvb/frontends/si21xx.c               |    2 +-
 drivers/media/dvb/frontends/stb6100.c              |    2 +-
 drivers/media/dvb/frontends/stb6100.h              |    4 +-
 drivers/media/dvb/frontends/stv0288.c              |   25 +-
 drivers/media/dvb/frontends/stv0299.c              |    2 +-
 drivers/media/dvb/frontends/stv0299.h              |    2 +-
 drivers/media/dvb/frontends/tda1004x.c             |    2 +-
 drivers/media/dvb/frontends/zl10353.c              |    2 +-
 drivers/media/dvb/mantis/mantis_core.c             |    5 +-
 drivers/media/dvb/mantis/mantis_i2c.c              |    1 -
 drivers/media/dvb/mantis/mantis_ioc.c              |    9 +-
 drivers/media/dvb/ngene/ngene-i2c.c                |    1 -
 drivers/media/dvb/pluto2/pluto2.c                  |    1 -
 drivers/media/dvb/pt1/pt1.c                        |    1 -
 drivers/media/dvb/siano/smscoreapi.c               |    3 +-
 drivers/media/dvb/siano/smsir.c                    |    2 +-
 drivers/media/dvb/ttpci/av7110.c                   |    3 +-
 drivers/media/dvb/ttpci/av7110_av.c                |    5 +-
 drivers/media/dvb/ttpci/budget-core.c              |    2 -
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c  |    1 -
 drivers/media/radio/radio-cadet.c                  |    3 +-
 drivers/media/radio/radio-mr800.c                  |   75 +-
 drivers/media/radio/radio-si4713.c                 |   12 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |   29 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |   17 +-
 drivers/media/radio/si470x/radio-si470x.h          |    2 -
 drivers/media/radio/si4713-i2c.c                   |    2 +-
 drivers/media/radio/tef6862.c                      |    1 -
 drivers/media/video/Kconfig                        |  106 +-
 drivers/media/video/Makefile                       |   12 +-
 drivers/media/video/adv7170.c                      |   28 +-
 drivers/media/video/adv7175.c                      |   28 +-
 drivers/media/video/adv7180.c                      |    1 -
 drivers/media/video/au0828/au0828-cards.c          |    4 +-
 drivers/media/video/au0828/au0828-video.c          |    4 +-
 drivers/media/video/bt819.c                        |   28 +-
 drivers/media/video/bt856.c                        |   28 +-
 drivers/media/video/bt866.c                        |   28 +-
 drivers/media/video/bt8xx/bttv-cards.c             |   22 +-
 drivers/media/video/bt8xx/bttv-driver.c            |  273 ++-
 drivers/media/video/bt8xx/bttv-i2c.c               |   43 +-
 drivers/media/video/bt8xx/bttv-input.c             |   84 +-
 drivers/media/video/bt8xx/bttv-risc.c              |    2 +-
 drivers/media/video/bt8xx/bttv.h                   |    1 -
 drivers/media/video/bt8xx/bttvp.h                  |   13 +-
 drivers/media/video/cafe_ccic.c                    |  180 +-
 drivers/media/video/cpia2/Kconfig                  |    2 +-
 drivers/media/video/cpia2/cpia2.h                  |    8 +-
 drivers/media/video/cpia2/cpia2_core.c             |   51 +-
 drivers/media/video/cpia2/cpia2_v4l.c              |  332 +--
 drivers/media/video/cpia2/cpia2dev.h               |    4 +-
 drivers/media/video/cs5345.c                       |   27 +-
 drivers/media/video/cs53l32a.c                     |   27 +-
 drivers/media/video/cx18/cx18-driver.h             |   19 +-
 drivers/media/video/cx18/cx18-i2c.c                |   23 +-
 drivers/media/video/cx18/cx18-ioctl.c              |    1 -
 drivers/media/video/cx231xx/Kconfig                |    1 +
 drivers/media/video/cx231xx/Makefile               |    2 +-
 drivers/media/video/cx231xx/cx231xx-417.c          | 2194 +++++++++++++
 drivers/media/video/cx231xx/cx231xx-audio.c        |  256 ++-
 drivers/media/video/cx231xx/cx231xx-avcore.c       |  687 ++++-
 drivers/media/video/cx231xx/cx231xx-cards.c        |  427 ++-
 drivers/media/video/cx231xx/cx231xx-conf-reg.h     |    1 +
 drivers/media/video/cx231xx/cx231xx-core.c         |  787 ++++-
 drivers/media/video/cx231xx/cx231xx-dif.h          | 3178 +++++++++++++++++++
 drivers/media/video/cx231xx/cx231xx-dvb.c          |  250 ++-
 drivers/media/video/cx231xx/cx231xx-i2c.c          |   11 +-
 drivers/media/video/cx231xx/cx231xx-input.c        |  222 --
 drivers/media/video/cx231xx/cx231xx-vbi.c          |  109 +-
 drivers/media/video/cx231xx/cx231xx-vbi.h          |    2 +-
 drivers/media/video/cx231xx/cx231xx-video.c        |  595 +++--
 drivers/media/video/cx231xx/cx231xx.h              |  260 ++-
 drivers/media/video/cx23885/cx23885-417.c          |    2 +-
 drivers/media/video/cx23885/cx23885-cards.c        |    2 +-
 drivers/media/video/cx23885/cx23885-core.c         |    3 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |    7 +-
 drivers/media/video/cx23885/cx23885-video.c        |   11 +-
 drivers/media/video/cx23885/cx23888-ir.c           |    1 +
 drivers/media/video/cx25840/cx25840-audio.c        |   62 +-
 drivers/media/video/cx25840/cx25840-core.c         |   44 +-
 drivers/media/video/cx25840/cx25840-ir.c           |    1 +
 drivers/media/video/cx88/cx88-alsa.c               |  117 +-
 drivers/media/video/cx88/cx88-blackbird.c          |   16 +-
 drivers/media/video/cx88/cx88-cards.c              |   44 +-
 drivers/media/video/cx88/cx88-core.c               |   30 +-
 drivers/media/video/cx88/cx88-dsp.c                |   11 +-
 drivers/media/video/cx88/cx88-dvb.c                |  181 +-
 drivers/media/video/cx88/cx88-i2c.c                |   31 +-
 drivers/media/video/cx88/cx88-input.c              |   57 +-
 drivers/media/video/cx88/cx88-mpeg.c               |    6 +-
 drivers/media/video/cx88/cx88-tvaudio.c            |   43 +-
 drivers/media/video/cx88/cx88-vbi.c                |    2 +-
 drivers/media/video/cx88/cx88-video.c              |   86 +-
 drivers/media/video/cx88/cx88-vp3054-i2c.c         |    2 -
 drivers/media/video/cx88/cx88.h                    |   74 +-
 drivers/media/video/davinci/vpfe_capture.c         |   40 +-
 drivers/media/video/davinci/vpif_capture.c         |   18 +-
 drivers/media/video/davinci/vpif_display.c         |   16 +-
 drivers/media/video/em28xx/em28xx-audio.c          |   75 +-
 drivers/media/video/em28xx/em28xx-cards.c          |   57 +-
 drivers/media/video/em28xx/em28xx-video.c          |   97 +-
 drivers/media/video/em28xx/em28xx.h                |   18 +-
 drivers/media/video/fsl-viu.c                      |    7 +-
 drivers/media/video/gspca/Kconfig                  |   18 +
 drivers/media/video/gspca/Makefile                 |    4 +
 drivers/media/video/gspca/benq.c                   |   23 +-
 drivers/media/video/gspca/conex.c                  |   14 +-
 drivers/media/video/gspca/cpia1.c                  |  133 +-
 drivers/media/video/gspca/etoms.c                  |   12 +-
 drivers/media/video/gspca/finepix.c                |   15 +-
 drivers/media/video/gspca/gl860/gl860-mi2020.c     |    6 +-
 drivers/media/video/gspca/gl860/gl860.c            |    6 +-
 drivers/media/video/gspca/gspca.c                  |  161 +-
 drivers/media/video/gspca/gspca.h                  |   12 +-
 drivers/media/video/gspca/jeilinj.c                |   15 +-
 drivers/media/video/gspca/konica.c                 |  646 ++++
 drivers/media/video/gspca/m5602/m5602_core.c       |    8 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.c    |   48 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.h    |   14 +-
 drivers/media/video/gspca/m5602/m5602_ov7660.c     |   70 +-
 drivers/media/video/gspca/m5602/m5602_ov7660.h     |    9 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.c     |  102 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.h     |   12 +-
 drivers/media/video/gspca/m5602/m5602_po1030.c     |  136 +-
 drivers/media/video/gspca/m5602/m5602_po1030.h     |   13 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c     |   28 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.h     |   14 +-
 drivers/media/video/gspca/m5602/m5602_s5k83a.h     |   12 +-
 drivers/media/video/gspca/mars.c                   |  327 +-
 drivers/media/video/gspca/mr97310a.c               |   56 +-
 drivers/media/video/gspca/ov519.c                  |  389 +--
 drivers/media/video/gspca/ov534.c                  |   19 +-
 drivers/media/video/gspca/ov534_9.c                |   19 +-
 drivers/media/video/gspca/pac207.c                 |   26 +-
 drivers/media/video/gspca/pac7302.c                |   32 +-
 drivers/media/video/gspca/pac7311.c                |   32 +-
 drivers/media/video/gspca/sn9c2028.c               |   19 +-
 drivers/media/video/gspca/sn9c20x.c                |   65 +-
 drivers/media/video/gspca/sonixb.c                 |   21 +-
 drivers/media/video/gspca/sonixj.c                 |  926 +++---
 drivers/media/video/gspca/spca1528.c               |   15 +-
 drivers/media/video/gspca/spca500.c                |   14 +-
 drivers/media/video/gspca/spca501.c                |   16 +-
 drivers/media/video/gspca/spca505.c                |   18 +-
 drivers/media/video/gspca/spca508.c                |   16 +-
 drivers/media/video/gspca/spca561.c                |   16 +-
 drivers/media/video/gspca/sq905.c                  |   21 +-
 drivers/media/video/gspca/sq905c.c                 |   15 +-
 drivers/media/video/gspca/sq930x.c                 |   23 +-
 drivers/media/video/gspca/stk014.c                 |  174 +-
 drivers/media/video/gspca/stv0680.c                |   17 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c        |   14 +-
 drivers/media/video/gspca/stv06xx/stv06xx.h        |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c   |   19 +-
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h   |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h |    4 +-
 drivers/media/video/gspca/sunplus.c                |   27 +-
 drivers/media/video/gspca/t613.c                   |   10 +-
 drivers/media/video/gspca/tv8532.c                 |    8 +-
 drivers/media/video/gspca/vc032x.c                 |   19 +-
 drivers/media/video/gspca/w996Xcf.c                |   10 +-
 drivers/media/video/gspca/xirlink_cit.c            | 3253 ++++++++++++++++++++
 drivers/media/video/gspca/zc3xx.c                  |   37 +-
 drivers/media/video/hdpvr/hdpvr-control.c          |    5 +-
 drivers/media/video/hdpvr/hdpvr-core.c             |   36 +-
 drivers/media/video/hdpvr/hdpvr-i2c.c              |    1 -
 drivers/media/video/hdpvr/hdpvr-video.c            |    5 +-
 drivers/media/video/hdpvr/hdpvr.h                  |    7 +-
 drivers/media/video/hexium_gemini.c                |    1 -
 drivers/media/video/hexium_orion.c                 |    1 -
 drivers/media/video/imx074.c                       |  508 +++
 drivers/media/video/indycam.c                      |   27 +-
 drivers/media/video/ir-kbd-i2c.c                   |   62 +-
 drivers/media/video/ivtv/ivtv-driver.h             |   14 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |   42 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |    1 -
 drivers/media/video/ks0127.c                       |   27 +-
 drivers/media/video/m52790.c                       |   28 +-
 drivers/media/video/mem2mem_testdev.c              |    2 +-
 drivers/media/video/msp3400-driver.c               |   38 +-
 drivers/media/video/mt9m001.c                      |   26 +-
 drivers/media/video/mt9m111.c                      |   38 +-
 drivers/media/video/mt9t031.c                      |   24 +-
 drivers/media/video/mt9t112.c                      |   14 +-
 drivers/media/video/mt9v011.c                      |   29 +-
 drivers/media/video/mt9v022.c                      |   26 +-
 drivers/media/video/mx1_camera.c                   |   12 +-
 drivers/media/video/mx2_camera.c                   |   44 +-
 drivers/media/video/mx3_camera.c                   |   11 +-
 drivers/media/video/mxb.c                          |   17 +-
 drivers/media/video/omap/omap_vout.c               |    2 +-
 drivers/media/video/omap1_camera.c                 | 1702 ++++++++++
 drivers/media/video/omap24xxcam.c                  |    4 +-
 drivers/media/video/ov6650.c                       | 1225 ++++++++
 drivers/media/video/ov7670.c                       |  268 ++-
 drivers/media/video/ov7670.h                       |   20 +
 drivers/media/video/ov772x.c                       |   18 +-
 drivers/media/video/ov9640.c                       |   12 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |   11 +-
 drivers/media/video/pwc/Kconfig                    |    2 +-
 drivers/media/video/pwc/pwc-ctrl.c                 |   20 +-
 drivers/media/video/pwc/pwc-if.c                   |   35 +-
 drivers/media/video/pwc/pwc-misc.c                 |    4 +-
 drivers/media/video/pwc/pwc-uncompress.c           |    2 +-
 drivers/media/video/pwc/pwc-v4l.c                  |  322 +--
 drivers/media/video/pwc/pwc.h                      |    6 +-
 drivers/media/video/pxa_camera.c                   |   12 +-
 drivers/media/video/rj54n1cb0c.c                   |   26 +-
 drivers/media/video/s2255drv.c                     |    4 +-
 drivers/media/video/s5p-fimc/Makefile              |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |  819 +++++
 drivers/media/video/s5p-fimc/fimc-core.c           |  952 ++++---
 drivers/media/video/s5p-fimc/fimc-core.h           |  377 ++-
 drivers/media/video/s5p-fimc/fimc-reg.c            |  321 ++-
 drivers/media/video/s5p-fimc/regs-fimc.h           |   64 +-
 drivers/media/video/saa5246a.c                     | 1123 -------
 drivers/media/video/saa5249.c                      |  650 ----
 drivers/media/video/saa6588.c                      |   29 +-
 drivers/media/video/saa7110.c                      |   27 +-
 drivers/media/video/saa7115.c                      |   33 +-
 drivers/media/video/saa7127.c                      |   27 +-
 drivers/media/video/saa7134/Kconfig                |   11 +-
 drivers/media/video/saa7134/Makefile               |    7 +-
 drivers/media/video/saa7134/saa6752hs.c            |   27 +-
 drivers/media/video/saa7134/saa7134-cards.c        |    8 +-
 drivers/media/video/saa7134/saa7134-core.c         |    6 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |    2 +-
 drivers/media/video/saa7134/saa7134-empress.c      |    2 +-
 drivers/media/video/saa7134/saa7134-i2c.c          |    1 -
 drivers/media/video/saa7134/saa7134-input.c        |   15 +-
 drivers/media/video/saa7134/saa7134-video.c        |   16 +-
 drivers/media/video/saa7134/saa7134.h              |   16 +-
 drivers/media/video/saa7164/Makefile               |    2 +-
 drivers/media/video/saa7164/saa7164-api.c          |  973 ++++++-
 drivers/media/video/saa7164/saa7164-buffer.c       |  194 ++-
 drivers/media/video/saa7164/saa7164-bus.c          |  131 +-
 drivers/media/video/saa7164/saa7164-cards.c        |   33 +-
 drivers/media/video/saa7164/saa7164-cmd.c          |   35 +-
 drivers/media/video/saa7164/saa7164-core.c         |  890 +++++-
 drivers/media/video/saa7164/saa7164-dvb.c          |  109 +-
 drivers/media/video/saa7164/saa7164-encoder.c      | 1503 +++++++++
 drivers/media/video/saa7164/saa7164-fw.c           |   11 +-
 drivers/media/video/saa7164/saa7164-i2c.c          |    2 +-
 drivers/media/video/saa7164/saa7164-reg.h          |   59 +-
 drivers/media/video/saa7164/saa7164-types.h        |  255 ++-
 drivers/media/video/saa7164/saa7164-vbi.c          | 1375 +++++++++
 drivers/media/video/saa7164/saa7164.h              |  295 ++-
 drivers/media/video/saa717x.c                      |   27 +-
 drivers/media/video/saa7185.c                      |   28 +-
 drivers/media/video/saa7191.c                      |   27 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |   30 +-
 drivers/media/video/sh_vou.c                       |    7 +-
 drivers/media/video/sn9c102/sn9c102_devtable.h     |    4 +
 drivers/media/video/soc_camera.c                   |  200 +-
 drivers/media/video/sr030pc30.c                    |  894 ++++++
 drivers/media/video/tda7432.c                      |   27 +-
 drivers/media/video/tda9840.c                      |   27 +-
 drivers/media/video/tda9875.c                      |   27 +-
 drivers/media/video/tea6415c.c                     |   27 +-
 drivers/media/video/tea6420.c                      |   27 +-
 drivers/media/video/tlg2300/pd-video.c             |    4 +-
 drivers/media/video/tlv320aic23b.c                 |   28 +-
 drivers/media/video/tuner-core.c                   |   40 +-
 drivers/media/video/tvaudio.c                      |   40 +-
 drivers/media/video/tvp514x.c                      |   67 +-
 drivers/media/video/tvp5150.c                      |   31 +-
 drivers/media/video/tvp7002.c                      |  126 +-
 drivers/media/video/tw9910.c                       |   20 +-
 drivers/media/video/upd64031a.c                    |   27 +-
 drivers/media/video/upd64083.c                     |   27 +-
 drivers/media/video/usbvideo/Kconfig               |   10 +-
 drivers/media/video/usbvision/usbvision-i2c.c      |   15 +-
 drivers/media/video/usbvision/usbvision-video.c    |    8 +-
 drivers/media/video/usbvision/usbvision.h          |    1 +
 drivers/media/video/uvc/uvc_ctrl.c                 |  712 +++--
 drivers/media/video/uvc/uvc_driver.c               |   19 +-
 drivers/media/video/uvc/uvc_isight.c               |    2 +-
 drivers/media/video/uvc/uvc_queue.c                |   11 +-
 drivers/media/video/uvc/uvc_status.c               |    4 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |   56 +-
 drivers/media/video/uvc/uvc_video.c                |   52 +-
 drivers/media/video/uvc/uvcvideo.h                 |   40 +-
 drivers/media/video/v4l1-compat.c                  |   13 +-
 drivers/media/video/v4l2-common.c                  |   27 +
 drivers/media/video/v4l2-ctrls.c                   |    4 +
 drivers/media/video/v4l2-dev.c                     |  119 +-
 drivers/media/video/v4l2-event.c                   |    9 +-
 drivers/media/video/v4l2-mem2mem.c                 |    8 +-
 drivers/media/video/via-camera.c                   | 1474 +++++++++
 drivers/media/video/via-camera.h                   |   93 +
 drivers/media/video/videobuf-core.c                |  115 +-
 drivers/media/video/videobuf-dma-contig.c          |   15 +-
 drivers/media/video/videobuf-dma-sg.c              |   13 +-
 drivers/media/video/videobuf-dvb.c                 |    2 +-
 drivers/media/video/videobuf-vmalloc.c             |    9 +-
 drivers/media/video/vino.c                         |    4 +-
 drivers/media/video/vivi.c                         |   17 +-
 drivers/media/video/vp27smpx.c                     |   28 +-
 drivers/media/video/vpx3220.c                      |   27 +-
 drivers/media/video/wm8739.c                       |   27 +-
 drivers/media/video/wm8775.c                       |  132 +-
 drivers/media/video/zoran/zoran.h                  |    2 -
 drivers/media/video/zoran/zoran_card.c             |   23 +-
 drivers/media/video/zoran/zoran_device.c           |   12 +-
 drivers/media/video/zoran/zoran_driver.c           |    2 +-
 drivers/media/video/zr364xx.c                      |    4 +-
 drivers/staging/Kconfig                            |    4 +
 drivers/staging/Makefile                           |    2 +
 drivers/staging/cpia/Kconfig                       |   39 +
 drivers/staging/cpia/Makefile                      |    5 +
 drivers/staging/cpia/TODO                          |    8 +
 drivers/{media/video => staging/cpia}/cpia.c       |    0
 drivers/{media/video => staging/cpia}/cpia.h       |    0
 drivers/{media/video => staging/cpia}/cpia_pp.c    |    0
 drivers/{media/video => staging/cpia}/cpia_usb.c   |    0
 drivers/staging/cx25821/Kconfig                    |    2 +-
 drivers/staging/cx25821/cx25821-alsa.c             |    2 +-
 drivers/staging/cx25821/cx25821-audio-upstream.c   |   13 +-
 drivers/staging/cx25821/cx25821-audio-upstream.h   |    4 +-
 drivers/staging/cx25821/cx25821-audio.h            |   10 +-
 drivers/staging/cx25821/cx25821-core.c             |   64 +-
 drivers/staging/cx25821/cx25821-i2c.c              |    2 +-
 drivers/staging/cx25821/cx25821-medusa-reg.h       |   10 +-
 drivers/staging/cx25821/cx25821-medusa-video.c     |    8 +-
 drivers/staging/cx25821/cx25821-reg.h              |    4 +-
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |  135 +-
 .../staging/cx25821/cx25821-video-upstream-ch2.h   |   14 +-
 drivers/staging/cx25821/cx25821-video-upstream.c   |   28 +-
 drivers/staging/cx25821/cx25821-video-upstream.h   |   10 +-
 drivers/staging/cx25821/cx25821-video.c            |    6 +-
 drivers/staging/cx25821/cx25821.h                  |   51 +-
 drivers/staging/dt3155v4l/dt3155v4l.c              |    8 +-
 drivers/staging/go7007/Kconfig                     |    2 +-
 drivers/staging/go7007/go7007-driver.c             |   55 +-
 drivers/staging/go7007/go7007-usb.c                |    2 +-
 drivers/staging/go7007/go7007-v4l2.c               |   19 +-
 drivers/staging/go7007/s2250-board.c               |   34 +-
 drivers/staging/go7007/wis-ov7640.c                |    1 +
 drivers/staging/go7007/wis-saa7113.c               |    1 +
 drivers/staging/go7007/wis-saa7115.c               |    1 +
 drivers/staging/go7007/wis-sony-tuner.c            |    1 +
 drivers/staging/go7007/wis-tw2804.c                |    1 +
 drivers/staging/go7007/wis-tw9903.c                |    1 +
 drivers/staging/go7007/wis-uda1342.c               |    1 +
 drivers/staging/lirc/Kconfig                       |    2 +-
 drivers/staging/lirc/lirc_igorplugusb.c            |  190 +-
 drivers/staging/lirc/lirc_it87.c                   |   23 +-
 drivers/staging/lirc/lirc_ite8709.c                |    6 +-
 drivers/staging/lirc/lirc_parallel.c               |   61 +-
 drivers/staging/lirc/lirc_serial.c                 |   24 +-
 drivers/staging/lirc/lirc_sir.c                    |   24 +-
 drivers/staging/lirc/lirc_zilog.c                  |    3 +
 drivers/staging/stradis/Kconfig                    |    7 +
 drivers/staging/stradis/Makefile                   |    3 +
 drivers/staging/stradis/TODO                       |    6 +
 drivers/{media/video => staging/stradis}/stradis.c |    0
 drivers/staging/tm6000/TODO                        |    6 +
 drivers/staging/tm6000/tm6000-alsa.c               |  102 +-
 drivers/staging/tm6000/tm6000-cards.c              |   41 +-
 drivers/staging/tm6000/tm6000-core.c               |  157 +-
 drivers/staging/tm6000/tm6000-dvb.c                |   32 +-
 drivers/staging/tm6000/tm6000-i2c.c                |   43 +-
 drivers/staging/tm6000/tm6000-input.c              |   34 +-
 drivers/staging/tm6000/tm6000-regs.h               |   32 +-
 drivers/staging/tm6000/tm6000-stds.c               |  350 ++-
 drivers/staging/tm6000/tm6000-usb-isoc.h           |   32 +-
 drivers/staging/tm6000/tm6000-video.c              |  442 ++--
 drivers/staging/tm6000/tm6000.h                    |   54 +-
 drivers/video/via/accel.c                          |    2 +-
 drivers/video/via/via-core.c                       |   16 +-
 include/linux/Kbuild                               |    1 -
 include/linux/via-core.h                           |    4 +-
 include/linux/videodev2.h                          |   12 +-
 include/linux/videotext.h                          |  125 -
 include/media/ir-core.h                            |   41 +-
 include/media/ir-kbd-i2c.h                         |   10 +-
 include/media/lirc_dev.h                           |    6 +-
 include/media/omap1_camera.h                       |   35 +
 include/media/rc-map.h                             |   19 +-
 include/media/s3c_fimc.h                           |   60 +
 include/media/sh_vou.h                             |    1 -
 include/media/soc_camera.h                         |    9 +-
 include/media/sr030pc30.h                          |   21 +
 include/media/v4l2-chip-ident.h                    |    8 +
 include/media/v4l2-common.h                        |   10 +
 include/media/v4l2-dev.h                           |    8 +-
 include/media/v4l2-device.h                        |   57 +-
 include/media/v4l2-i2c-drv.h                       |   80 -
 include/media/v4l2-mediabus.h                      |    8 +
 include/media/v4l2-subdev.h                        |   24 +-
 include/media/videobuf-core.h                      |   19 +-
 include/media/videobuf-dma-contig.h                |    3 +-
 include/media/videobuf-dma-sg.h                    |    3 +-
 include/media/videobuf-vmalloc.h                   |    3 +-
 include/media/wm8775.h                             |    3 +
 536 files changed, 41164 insertions(+), 13146 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-srggb10.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-srggb8.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y10.xml
 create mode 100644 Documentation/dvb/lmedm04.txt
 create mode 100644 drivers/media/IR/ir-rc5-sz-decoder.c
 create mode 100644 drivers/media/IR/keymaps/rc-alink-dtu-m.c
 create mode 100644 drivers/media/IR/keymaps/rc-anysee.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia-rm-ks.c
 create mode 100644 drivers/media/IR/keymaps/rc-azurewave-ad-tu700.c
 create mode 100644 drivers/media/IR/keymaps/rc-digitalnow-tinytwin.c
 create mode 100644 drivers/media/IR/keymaps/rc-digittrade.c
 create mode 100644 drivers/media/IR/keymaps/rc-leadtek-y04g0051.c
 create mode 100644 drivers/media/IR/keymaps/rc-lme2510.c
 create mode 100644 drivers/media/IR/keymaps/rc-msi-digivox-ii.c
 create mode 100644 drivers/media/IR/keymaps/rc-msi-digivox-iii.c
 delete mode 100644 drivers/media/IR/keymaps/rc-rc5-streamzap.c
 create mode 100644 drivers/media/IR/keymaps/rc-streamzap.c
 create mode 100644 drivers/media/IR/keymaps/rc-terratec-slim.c
 create mode 100644 drivers/media/IR/keymaps/rc-total-media-in-hand.c
 create mode 100644 drivers/media/IR/keymaps/rc-trekstor.c
 create mode 100644 drivers/media/IR/keymaps/rc-twinhan1027.c
 create mode 100644 drivers/media/IR/nuvoton-cir.c
 create mode 100644 drivers/media/IR/nuvoton-cir.h
 create mode 100644 drivers/media/common/tuners/tda18218.c
 create mode 100644 drivers/media/common/tuners/tda18218.h
 create mode 100644 drivers/media/common/tuners/tda18218_priv.h
 create mode 100644 drivers/media/dvb/dvb-usb/lmedm04.c
 create mode 100644 drivers/media/dvb/dvb-usb/lmedm04.h
 create mode 100644 drivers/media/dvb/frontends/ix2505v.c
 create mode 100644 drivers/media/dvb/frontends/ix2505v.h
 delete mode 100644 drivers/media/dvb/frontends/lgdt3304.c
 delete mode 100644 drivers/media/dvb/frontends/lgdt3304.h
 create mode 100644 drivers/media/dvb/frontends/s5h1432.c
 create mode 100644 drivers/media/dvb/frontends/s5h1432.h
 create mode 100644 drivers/media/video/cx231xx/cx231xx-417.c
 create mode 100644 drivers/media/video/cx231xx/cx231xx-dif.h
 delete mode 100644 drivers/media/video/cx231xx/cx231xx-input.c
 create mode 100644 drivers/media/video/gspca/konica.c
 create mode 100644 drivers/media/video/gspca/xirlink_cit.c
 create mode 100644 drivers/media/video/imx074.c
 create mode 100644 drivers/media/video/omap1_camera.c
 create mode 100644 drivers/media/video/ov6650.c
 create mode 100644 drivers/media/video/ov7670.h
 create mode 100644 drivers/media/video/s5p-fimc/fimc-capture.c
 delete mode 100644 drivers/media/video/saa5246a.c
 delete mode 100644 drivers/media/video/saa5249.c
 create mode 100644 drivers/media/video/saa7164/saa7164-encoder.c
 create mode 100644 drivers/media/video/saa7164/saa7164-vbi.c
 create mode 100644 drivers/media/video/sr030pc30.c
 create mode 100644 drivers/media/video/via-camera.c
 create mode 100644 drivers/media/video/via-camera.h
 create mode 100644 drivers/staging/cpia/Kconfig
 create mode 100644 drivers/staging/cpia/Makefile
 create mode 100644 drivers/staging/cpia/TODO
 rename drivers/{media/video => staging/cpia}/cpia.c (100%)
 rename drivers/{media/video => staging/cpia}/cpia.h (100%)
 rename drivers/{media/video => staging/cpia}/cpia_pp.c (100%)
 rename drivers/{media/video => staging/cpia}/cpia_usb.c (100%)
 create mode 100644 drivers/staging/stradis/Kconfig
 create mode 100644 drivers/staging/stradis/Makefile
 create mode 100644 drivers/staging/stradis/TODO
 rename drivers/{media/video => staging/stradis}/stradis.c (100%)
 create mode 100644 drivers/staging/tm6000/TODO
 delete mode 100644 include/linux/videotext.h
 create mode 100644 include/media/omap1_camera.h
 create mode 100644 include/media/s3c_fimc.h
 create mode 100644 include/media/sr030pc30.h
 delete mode 100644 include/media/v4l2-i2c-drv.h


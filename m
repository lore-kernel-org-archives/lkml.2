Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab2EXPe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:34:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733Ab2EXPey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:34:54 -0400
Message-ID: <4FBE5518.5090705@redhat.com>
Date: Thu, 24 May 2012 12:34:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.5-rc1] media updates for v3.5
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For a series of patches for 3.5, including:
	- some V4L2 API updates needed by embedded devices;
	- DVB API extensions for ATSC-MH delivery system, used in US for mobile TV;
	- new tuners for fc0011/0012/0013 and tua9001;
	- a new dvb driver for af9033/9035;
	- a new ATSC-MH frontend (lg2160);
	- new remote controller keymaps;
	- Removal of a few legacy webcam driver that got replaced by gspca on
	  several kernel versions ago;
	- a new driver for Exynos 4/5 webcams(s5pp fimc-lite);
	- a new webcam sensor driver (smiapp);
	- a new video input driver for embedded (sta2x1xx);
	- several improvements, fixes, cleanups, etc inside the drivers.

Regards,
Mauro

-

Latest commit at the branch: 
71006fb22b0f5a2045605b3887ee99a0e9adafe4 [media] saa7134-cards: Remove a PCI entry added by mistake
The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:

  Linux 3.4 (2012-05-20 15:29:13 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Alan McIvor (1):
      [media] Default bt878 contrast value

Alexey Khoroshilov (1):
      [media] dib9000: get rid of Dib*Lock macros

Andy Shevchenko (1):
      [media] as3645a: move relevant code under __devinit/__devexit

Anssi Hannula (4):
      [media] ati_remote: allow specifying a default keymap selector function
      [media] ati_remote: add support for Medion X10 Digitainer remote
      [media] ati_remote: add keymap for Medion X10 OR2x remotes
      [media] ati_remote: add regular up/down buttons to Medion Digitainer keymap

Antonio Ospite (3):
      [media] gspca - ov534: Add Saturation control
      [media] Input: move drivers/input/fixp-arith.h to include/linux
      [media] gspca - ov534: Add Hue control

Antti Palosaari (33):
      [media] Infineon TUA 9001 silicon tuner driver
      [media] Afatech AF9033 DVB-T demodulator driver
      [media] Afatech AF9035 DVB USB driver
      [media] af9035: enhancement for unknown tuner ID handling
      [media] af9035: reimplement firmware downloader
      [media] af9035: add missing error check
      [media] af9033: correct debug print
      [media] af9033: implement .read_snr()
      [media] af9035: add log writing if unsupported Xtal freq is given
      [media] af9035: fix and enhance I2C adapter
      [media] af9035: initial support for IT9135 chip
      [media] af9033: do some minor changes for .get_frontend()
      [media] af9035: minor changes for af9035_fc0011_tuner_callback()
      [media] af9035: reorganise USB ID and device list
      [media] af9035: disable frontend0 I2C-gate control
      [media] af9035: various small changes for af9035_ctrl_msg()
      [media] af9035: remove unused struct
      [media] af9035: move device configuration to the state
      [media] af9035: remove one config parameter
      [media] af9035: add few new reference design USB IDs
      [media] get_dvb_firmware: add dvb-demod-drxk-pctv.fw
      [media] rtl28xxu: dynamic USB ID support
      [media] af9015: various small changes and clean-ups
      [media] drxk: fix GPIOs
      [media] em28xx: disable LNA - PCTV QuatroStick nano (520e)
      [media] rtl2830: implement .read_snr()
      [media] rtl2830: implement .read_ber()
      [media] rtl2830: implement .read_signal_strength()
      [media] rtl2830: implement .get_frontend()
      [media] rtl2830: prevent hw access when sleeping
      [media] rtl28xxu: add small sleep for rtl2830 demod attach
      [media] zl10353: change .read_snr() to report SNR as a 0.1 dB
      [media] em28xx: simple comment fix

Arnd Bergmann (5):
      [media] video/omap24xxcam: use __iomem annotations
      [media] dvb/drxd: stub out drxd_attach when not built
      [media] media/rc: IR_SONY_DECODER depends on BITREVERSE
      [media] media/video: add I2C dependencies
      [media] drivers/media: add missing __devexit_p() annotations

Ben Hutchings (1):
      [media] rc: Fix invalid free_region and/or free_irq on probe failure

Bhupesh Sharma (1):
      [media] usb: gadget/uvc: Remove non-required locking from 'uvc_queue_next_buffer' routine

Dan Carpenter (6):
      [media] mxl111sf: remove an unused variable
      [media] uvcvideo: remove unneeded access_ok() check
      [media] pluto2: remove some dead code
      [media] saa7164: saa7164_vbi_stop_port() returns linux error codes
      [media] ngene: remove an unneeded condition
      [media] gspca: passing wrong length parameter to reg_w()

Daniel Drake (1):
      [media] via-camera: specify XO-1.5 camera clock speed

Ezequiel Garcia (2):
      [media] em28xx: Make card_setup() and pre_card_setup() static
      [media] em28xx: Remove unused list_head struct for queued buffers

Ezequiel García (19):
      [media] em28xx: Remove redundant dev->ctl_input set
      [media] em28xx: Export em28xx_[read,write]_reg functions as SYMBOL_GPL
      [media] em28xx: Move ir/rc related initialization to em28xx_ir_init()
      [media] em28xx: Move em28xx_register_i2c_ir() to em28xx-input.c
      [media] em28xx: Change scope of em28xx-input local functions to static
      [media] em28xx: Make em28xx-input.c a separate module
      [media] em28xx: Remove unused field from em28xx_buffer struct
      [media] em28xx: Remove unused enum em28xx_io_method
      [media] em28xx: Remove unused wait_queue's
      [media] staging: easycap: Split device struct alloc and retrieval code
      [media] staging: easycap: Split buffer and video urb allocation
      [media] staging: easycap: Push bInterfaceNumber saving to config_easycap()
      [media] staging: easycap: Initialize 'ntsc' parameter before usage
      [media] staging: easycap: Push video registration to easycap_register_video()
      [media] staging: easycap: Split audio buffer and urb allocation
      [media] staging: easycap: Clean comment style in easycap_usb_disconnect()
      [media] staging: easycap: Clean comment style in easycap_delete()
      [media] staging: easycap: Split easycap_delete() into several pieces
      [media] em28xx: Fix memory leak on driver defered resource release

Federico Vaga (3):
      [media] adv7180: add support to user controls
      [media] videobuf-dma-contig: add cache support
      [media] STA2X11 VIP: new V4L2 driver

Gianluca Gennari (12):
      [media] af9035: fix warning
      [media] af9035: add USB id for 07ca:a867
      [media] af9035: add support for the tda18218 tuner
      [media] af9035: use module_usb_driver macro
      [media] af9033: implement get_frontend
      [media] lirc: delete unused init/exit function prototypes
      [media] em28xx-dvb: stop URBs when stopping the streaming
      [media] em28xx: clean-up several unused parametrs in struct em28xx_usb_isoc_ctl
      [media] dib7000p: remove duplicate code and comment
      [media] dib0700: add new USB PID for the Elgato EyeTV DTT stick
      [media] em28xx-dvb: enable LNA for cxd2820r in DVB-T mode
      [media] cxd2820r: tweak search algorithm behavior

Guennadi Liakhovetski (10):
      [media] V4L: fix a compiler warning
      [media] mt9m032: fix two dead-locks
      [media] mt9m032: fix compilation breakage
      [media] mt9m032: use the available subdev pointer, don't re-calculate it
      [media] V4L: marvell-ccic: (cosmetic) remove redundant variable assignment
      [media] V4L: soc-camera: (cosmetic) use a more explicit name for a host handler
      [media] V4L: mem2mem: fix alignment in mem2mem-testdev
      [media] V4L: mx2-camera: avoid overflowing 32-bits
      [media] V4L: soc-camera: switch to using the existing .enum_framesizes()
      [media] V4L: sh_mobile_ceu_camera: don't fail TRY_FMT

H Hartley Sweeten (2):
      [media] media: videobuf2-dma-contig: include header for exported symbols
      [media] media: videobuf2-dma-contig: quiet sparse noise about plain integer as NULL pointer

Hans Verkuil (86):
      [media] ivtv: only start streaming in poll() if polling for input
      [media] videobuf2: only start streaming in poll() if so requested by the poll mask
      [media] videobuf: only start streaming in poll() if so requested by the poll mask
      [media] videobuf2-core: also test for pending events
      [media] vivi: let vb2_poll handle events
      [media] radio-rtrack2: add missing slab.h
      [media] videodev2.h: Fix VIDIOC_QUERYMENU ioctl regression
      [media] V4L: fix incorrect refcounting
      [media] V4L2: drivers implementing vidioc_default should also return -ENOTTY
      [media] v4l2-ctrls.c: zero min/max/step/def values for 64 bit integers
      [media] vivi: fix duplicate line
      [media] V4L2 Spec: fix typo
      [media] dsbr100: clean up and update to the latest v4l2 framework
      [media] ivtv: set max/step to 0 for PTS and FRAME controls
      [media] radio-keene: support suspend/resume
      [media] radio-isa: fix memory leak
      [media] radio-mr800: cleanup and have it comply to the V4L2 API
      [media] radio-mr800: add support for stereo and signal detection
      [media] radio-mr800: add hardware seek support
      [media] cpia2: major overhaul to get it in a working state again
      [media] pvrusb2: convert to video_ioctl2
      [media] v4l2-dev: make it possible to skip locking for selected ioctls
      [media] v4l2-dev/ioctl: determine the valid ioctls upfront
      [media] tea575x-tuner: mark VIDIOC_S_HW_FREQ_SEEK as an invalid ioctl
      [media] v4l2-ioctl: handle priority handling based on a table lookup
      [media] v4l2-dev: add flag to have the core lock all file operations
      [media] v4l2-framework.txt: document v4l2_dont_use_cmd
      [media] gspca: Allow subdrivers to use the control framework
      [media] gspca: Use video_drvdata(file) instead of file->private_data
      [media] gscpa: Use v4l2_fh and add G/S_PRIORITY support
      [media] gspca: Add support for control events
      [media] gspca: Fix querycap and incorrect return codes
      [media] gspca: Fix locking issues related to suspend/resume
      [media] gspca: Switch to V4L2 core locking, except for the buffer queuing ioctls
      [media] gspca_zc3xx: Convert to the control framework
      [media] gcpca_sn9c20x: Convert to the control framework
      [media] gspca_stv06xx: Convert to the control framework
      [media] gspca_mars: Convert to the control framework
      [media] pms: update to the latest V4L2 frameworks
      [media] si470x: Clean up, introduce the control framework
      [media] si470x: add control event support and more v4l2 compliancy fixes
      [media] radio-si470x-common.c: remove unnecessary kernel log spam
      [media] radio-si470x-usb: remove autosuspend, implement suspend/resume
      [media] dw2102: fix compile warnings
      [media] cx231xx: fix compiler warnings
      [media] ivtv/cx18: fix compiler warnings
      [media] cx25821: fix compiler warnings
      [media] v4l: fix compiler warnings
      [media] v4l: fix compiler warnings
      [media] v4l/dvb: fix compiler warnings
      [media] v4l/dvb: fix compiler warnings
      [media] mxb/saa7146: first round of cleanups
      [media] mxb: fix initial audio + ntsc/secam support
      [media] mxb: fix audio handling
      [media] mxb: simplify a line that was too long
      [media] tda9840: fix setting of the audio mode
      [media] mxb: fix audio and standard handling
      [media] saa7146: move overlay information from saa7146_fh into saa7146_vv
      [media] saa7146: move video_fmt from saa7146_fh to saa7146_vv
      [media] saa7146: move vbi fields from saa7146_fh to saa7146_vv
      [media] saa7146: remove the unneeded type field from saa7146_fh
      [media] saa7146: rename vbi/video_q to vbi/video_dmaq
      [media] saa7146: support control events and priority handling
      [media] saa7146: fix querycap, vbi/video separation and g/s_register
      [media] fixes and add querystd support to mxb
      [media] hexium-gemini: remove B&W control, fix input table
      [media] hexium-orion: fix incorrect input table
      [media] vivi: add more pixelformats
      [media] vivi: add the alpha component control
      [media] av7110: fix v4l2_compliance test issues
      [media] v4l2-framework.txt: update the core lock documentation
      [media] v4l2-dev.h: add comment not to use V4L2_FL_LOCK_ALL_FOPS in new drivers
      [media] v4l2-dev: rename two functions
      [media] v4l2-event: fix regression with initial event handling
      [media] videodev2.h: add enum/query/cap dv_timings ioctls
      [media] V4L2 spec: document the new V4L2 DV timings ioctls
      [media] v4l2 framework: add support for the new dv_timings ioctls
      [media] v4l2-dv-timings.h: definitions for CEA-861 and VESA DMT timings
      [media] tvp7002: add support for the new dv timings API
      [media] Feature removal: remove invalid DV presets
      [media] V4L2: Mark the DV Preset API as deprecated
      [media] bw-qcam: update to latest frameworks
      [media] c-qcam: convert to the latest frameworks
      [media] arv: use latest frameworks
      [media] w9966: convert to the latest frameworks
      [media] gspca: the field 'frozen' is under CONFIG_PM

Hans de Goede (47):
      [media] pwc: poll(): Check that the device has not beem claimed for streaming already
      pwc: Add support for control events
      [media] stk-webcam: Don't flip the image by default
      [media] gspca/autogain_functions.h: Allow users to declare what they want
      [media] gspca_pac73xx: Remove comments from before the 7302 / 7311 separation
      [media] gspca_pac7311: Make sure exposure changes get applied immediately
      [media] gspca_pac7311: Adjust control scales to match registers
      [media] gspca_pac7311: Switch to new gspca control mechanism
      [media] gspca_pac7311: Switch to coarse expo autogain algorithm
      [media] gspca_pac7311: Convert multi-line comments to standard kernel style
      [media] gspca_pac7311: Properly set the compression balance
      [media] gspca_pac7302: Convert multi-line comments to standard kernel style
      [media] gspca_pac7302: Document some more registers
      [media] gspca_pac7302: Improve the gain control
      [media] media/video/et61x251: Remove this deprecated driver
      [media] media/radio: use v4l2_ctrl_subscribe_event where possible
      [media] v4l2-event: Add v4l2_subscribed_event_ops
      [media] v4l2-ctrls: Use v4l2_subscribed_event_ops
      [media] uvcvideo: Fix a "ignoring return value of ‘__clear_user’" warning
      [media] uvcvideo: Refactor uvc_ctrl_get and query
      [media] uvcvideo: Move __uvc_ctrl_get() up
      [media] uvcvideo: Add support for control events
      [media] uvcvideo: Properly report the inactive flag for inactive controls
      [media] uvcvideo: Send control change events for slave ctrls when the master changes
      [media] uvcvideo: Drop unused ctrl member from struct uvc_control_mapping
      [media] videobuf2: Fix a bug in fileio emulation error handling
      [media] pwc: Fix locking
      [media] gscpa: Clear usb_err before calling sd methods from suspend/resume
      [media] gspca: Use req_events in poll
      [media] gspca: Call sd_stop0 on disconnect
      [media] gspca: Set gspca_dev->usb_err to 0 at the begin of gspca_stream_off
      [media] gspca: Add autogain functions for use with control framework drivers
      [media] gspca_gl860: Add a present check to sd_stop0
      [media] gspca_zc3xx: Fix setting of jpeg quality while streaming
      [media] gspca_zc3xx: Fix JPEG quality setting code
      [media] gspca_zc3xx: Always automatically adjust BRC as needed
      [media] gspca_zc3xx: Disable the highest quality setting as it is not usable
      [media] gspca_sn9c20x: Whitespace fixes
      [media] gscpa_stv06xx: Make sd_desc const
      [media] gscpa: Move ctrl_handler to gspca_dev
      [media] gscpa_pac207: use usb_err for error handling
      [media] gspca_pac207: Convert to the control framework
      [media] gscpa_pac207: Switch to coarse_grained_expo auto gain algorithm
      [media] gspca: Remove gspca_auto_gain_n_exposure function
      [media] gspca_pac7311: Convert to the control framework
      [media] gspca_pac7311: Set register page at start of init
      [media] gspca_pac7311: Remove vflip control

Hans-Frieder Vogt (9):
      [media] af9035: i2c read fix
      [media] af9035: add Avermedia Volar HD (A867R) support
      [media] af9035: add remote control support
      [media] af9033: implement ber and ucb functions
      [media] fc001x: common header file for FC0012 and FC0013
      [media] fc001x: tuner driver for FC0012, version 0.5
      [media] fc001x: tuner driver for FC0013
      [media] fc0012 ver. 0.6: introduction of get_rf_strength function
      [media] fc0013 ver. 0.2: introduction of get_rf_strength function

Igor M. Liplianin (2):
      [media] cx23885: TeVii s471 card support
      [media] m88rs2000: LNB voltage control implemented

Il Han (1):
      [media] lmedm04: Initialize a variable before its usage

Ismael Luceno (2):
      [media] au0828: Add USB ID used by many dongles
      [media] au0828: Move the Kconfig knob under V4L_USB_DRIVERS

Javier Martin (4):
      [media] i.MX2: eMMa-PrP: Allow userptr IO mode
      [media] media: tvp5150: Fix mbus format
      [media] i.MX27: visstrim_m10: Remove use of MX2_CAMERA_SWAP16
      [media] media: mx2_camera: Fix mbus format handling

Jean-François Moine (7):
      [media] gspca - ov519: Add more information about probe problems
      [media] gspca - sn9c20x: Change the number of the sensor mt9vprb
      [media] gspca - sn9c20x: Add the sensor mt9vprb to the sensor ident table
      [media] gspca - sn9c20x: Define more tables as constant
      [media] gspca - sn9c20x: Set the i2c interface speed
      [media] gspca - sn9c20x: Don't do sensor update before the capture is started
      [media] gspca - sn9c20x: Change the exposure setting of Omnivision sensors

Jesper Juhl (3):
      [media] staging/media/as102: Don't call release_firmware() on uninitialized variable
      [media] staging: as102: Remove redundant NULL check before release_firmware() and pointless comments
      [media] s2255drv: Remove redundant NULL test before release_firmware()

Jim Cromie (1):
      [media] cx231xx: replace open-coded ARRAY_SIZE with macro

Jozsef Marton (1):
      [media] media: add support to gspca/pac7302.c for 093a:2627 (Genius FaceCam 300)

Julia Lawall (1):
      [media] drivers/media/video/au0828/au0828-video.c: add missing video_device_release

Kartik Mohta (1):
      [media] mt9v032: Correct the logic for the auto-exposure setting

Konstantin Khlebnikov (1):
      [media] mm/drivers: use vm_flags_t for vma flags

Kuninori Morimoto (1):
      [media] V4L2: sh_mobile_ceu: manage lower 8bit bus

Laurent Pinchart (36):
      [media] uvcvideo: Fix ENUMINPUT handling
      [media] MAINTAINERS: Update UVC driver's mailing list address
      [media] uvcvideo: Use videobuf2 .get_unmapped_area() implementation
      [media] omap3isp: Prevent pipelines that contain a crashed entity from starting
      [media] omap3isp: Fix frame number propagation
      [media] omap3isp: preview: Skip brightness and contrast in configuration ioctl
      [media] omap3isp: preview: Optimize parameters setup for the common case
      [media] omap3isp: preview: Remove averager parameter update flag
      [media] omap3isp: preview: Remove unused isptables_update structure definition
      [media] omap3isp: preview: Merge configuration and feature bits
      [media] omap3isp: preview: Remove update_attrs feature_bit field
      [media] omap3isp: preview: Rename prev_params fields to match userspace API
      [media] omap3isp: preview: Simplify configuration parameters access
      [media] omap3isp: preview: Shorten shadow update delay
      [media] omap3isp: preview: Rename last occurences of *_rgb_to_ycbcr to *_csc
      [media] omap3isp: preview: Add support for greyscale input
      [media] omap3isp: Mark probe and cleanup functions with __devinit and __devexit
      [media] omap3isp: ccdc: Add selection support on output formatter source pad
      [media] omap3isp: preview: Replace the crop API by the selection API
      [media] omap3isp: resizer: Replace the crop API by the selection API
      [media] v4l: aptina-pll: Round up minimum multiplier factor value properly
      [media] mt9p031: Identify color/mono models using I2C device name
      [media] mt9p031: Replace the reset board callback by a GPIO number
      [media] mt9p031: Implement black level compensation control
      [media] v4l: v4l2-ctrls: moves the forward declaration of struct file
      [media] mx2_camera: Fix sizeimage computation in try_fmt()
      [media] soc_camera: Use soc_camera_device::sizeimage to compute buffer sizes
      [media] soc_camera: Use soc_camera_device::bytesperline to compute line sizes
      [media] soc-camera: Add plane layout information to struct soc_mbus_pixelfmt
      [media] soc-camera: Fix bytes per line computation for planar formats
      [media] soc-camera: Add soc_mbus_image_size
      [media] soc-camera: Honor user-requested bytesperline and sizeimage
      [media] mx2_camera: Use soc_mbus_image_size() instead of manual computation
      [media] soc-camera: Support user-configurable line stride
      [media] sh_mobile_ceu_camera: Support user-configurable line stride
      [media] uvcvideo: Fix V4L2 button controls that share the same UVC control

Liu Ying (1):
      [media] V4L: OV5642:remove redundant code to set cropping w/h

Malcolm Priestley (3):
      [media] it913x.: Fix a misuse of ||
      [media] rc-it913x=v2 Incorrect assigned KEY_1
      [media] m88rs2000 - only flip bit 2 on reg 0x70 on 16th try

Marcos Paulo de Souza (3):
      [media] drivers: media: video: adp1653.c: Remove unneeded include of version.h
      [media] drivers: media: radio: radio-keene.c: Remove unneeded include of version.h
      [media] drivers: media: dvb: ddbridge: ddbridge-code: Remove unneeded include of version.h

Marek Szyprowski (1):
      [media] v4l: s5p-tv: fix plane size calculation

Mark Brown (1):
      [media] Convert I2C drivers to dev_pm_ops

Masahiro Nakai (1):
      [media] V4L2: mt9t112: fixup JPEG initialization workaround

Mauro Carvalho Chehab (12):
      Merge branch 'poll' into staging/for_v3.4
      Merge tag 'v3.4-rc3' into staging/for_v3.5
      [media] tlg2300: Remove usage of KERNEL_VERSION()
      [media] tm6000: don't use KERNEL_VERSION
      Merge remote-tracking branch 'linus/master' into staging/for_v3.5
      [media] saa7134: remove unused  log_err() macro
      [media] smiapp: fix compilation breakage
      [media] lg2160: Don't fill the legacy DVBv3 ops.type field
      [media] lg2160: Fix a few warnings
      Revert "[media] staging: media: go7007: Adlink MPG24 board issues"
      [media] sta2x11_vip: Fix 60Hz video standard handling
      [media] saa7134-cards: Remove a PCI entry added by mistake

Michael Buesch (7):
      [media] af9035: Add USB read checksumming
      [media] Add fc0011 tuner driver
      [media] af9035: Add fc0011 tuner support
      [media] af9035: Add Afatech USB PIDs
      [media] fc0011: use usleep_range()
      [media] af9035: Use usleep_range() in fc0011 support code
      [media] fc0011: Reduce number of retries

Michael Krufky (18):
      [media] xc5000: support 32MHz & 31.875MHz xtal using the 41.024.5 firmware
      [media] xc5000: log firmware upload failures in xc5000_fwupload
      [media] xc5000: xtal_khz should be a u16 rather than a u32
      [media] au0828-dvb: attach tuner based on dev->board.tuner_type on hvr950q
      [media] au8522: build ATV/DTV demodulators as separate modules
      [media] au8522_common: add missing MODULE_LICENSE
      [media] au8522_common: dont EXPORT_SYMBOL(au8522_led_gpio_enable)
      [media] smsusb: add autodetection support for USB ID 2040:c0a0
      [media] linux-dvb v5 API support for ATSC-MH
      [media] DocBook: document new DTV Properties for ATSC-MH delivery system
      [media] increment DVB API to version 5.6 for ATSC-MH frontend control
      [media] mxl111sf-tuner: tune SYS_ATSCMH just like SYS_ATSC
      [media] DVB: add support for the LG2160 ATSC-MH demodulator
      [media] dvb-demux: add functionality to send raw payload to the dvr device
      [media] dvb-usb: add support for dvb-usb-adapters that deliver raw payload
      [media] dvb-usb: increase MAX_NO_OF_FE_PER_ADAP from 2 to 3
      [media] mxl111sf: add ATSC-MH support
      [media] DVB: remove "stats" property bits from ATSC-MH API property additions

Michel Machado (1):
      [media] rc-loopback: remove duplicate line

Mike Isely (9):
      [media] pvrusb2: Stop statically initializing reserved struct fields to zero
      [media] pvrusb2: Clean up pvr2_hdw_get_detected_std()
      [media] pvrusb2: Implement querystd for videodev_ioctl2
      [media] pvrusb2: Transform video standard detection result into read-only control ID
      [media][trival] pvrusb2: Fix truncated video standard names
      [media] pvrusb2: Base available video standards on what hardware supports
      [media] pvrusb2: Trivial tweak to get rid of some redundant dereferences
      [media] pvrusb2: Get rid of obsolete code for video standard enumeration
      [media] pvrusb2: For querystd, start with list of hardware-supported standards

Ondrej Zary (4):
      [media] radio-isa: PnP support for the new ISA radio framework
      [media] radio-gemtek: add PnP support for AOpen FX-3D/Pro Radio
      [media] [resend] radio-sf16fmr2: add PnP support for SF16-FMD2
      [media] radio-sf16fmi: add support for SF16-FMD

Pierangelo Terzulli (1):
      [media] af9035: add AVerMedia Twinstar (A825) [07ca:0825]

Sachin Kamat (10):
      [media] v4l: s5p-tv: Fix section mismatch warning in mixer_video.c
      [media] s5p-mfc: Fix NULL pointer warnings
      [media] s5p-mfc: Add missing static storage class to silence warnings
      [media] s5p-g2d: Fix NULL pointer warnings in g2d.c file
      [media] s5p-g2d: Add missing static storage class in g2d.c file
      [media] s5p-jpeg: Make s5p_jpeg_g_selection function static
      [media] s5p-mfc: Add missing static storage class in s5p_mfc_enc.c file
      [media] s5p-g2d: Use devm_* functions in g2d.c file
      [media] s5p-jpeg: Use devm_* functions in jpeg-core.c file
      [media] s5p-mfc: Use devm_* functions in s5p_mfc.c file

Sakari Ailus (45):
      [media] v4l: Introduce integer menu controls
      [media] v4l: Document integer menu controls
      [media] vivi: Add an integer menu test control
      [media] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION IOCTLs
      [media] v4l: vdev_to_v4l2_subdev() should have return type "struct v4l2_subdev *"
      [media] v4l: Check pad number in get try pointer functions
      [media] v4l: Support s_crop and g_crop through s/g_selection
      [media] v4l: Add subdev selections documentation: svg and dia files
      [media] v4l: Add subdev selections documentation
      [media] v4l: Mark VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP obsolete
      [media] omap3isp: Prevent crash at module unload
      [media] omap3isp: Handle omap3isp_csi2_reset() errors
      [media] v4l2: use __u32 rather than enums in ioctl() structs
      [media] v4l: Image source control class
      [media] v4l: Image processing control class
      [media] v4l: Document raw bayer 4CC codes
      [media] v4l: Add DPCM compressed raw bayer pixel formats
      [media] media: Add link_validate() op to check links to the sink pad
      [media] v4l: Improve sub-device documentation for pad ops
      [media] v4l: Implement v4l2_subdev_link_validate()
      [media] v4l: Allow changing control handler lock
      [media] omap3isp: Support additional in-memory compressed bayer formats
      [media] omap3isp: Move definitions required by board code under include/media
      [media] omap3isp: Move setting constaints above media_entity_pipeline_start
      [media] omap3isp: Assume media_entity_pipeline_start may fail
      [media] omap3isp: Add lane configuration to platform data
      [media] omap3isp: Refactor collecting information on entities in pipeline
      [media] omap3isp: Add information on external subdev to struct isp_pipeline
      [media] omap3isp: Introduce isp_video_check_external_subdevs()
      [media] omap3isp: Use external rate instead of vpcfg
      [media] omap3isp: Default link validation for ccp2, csi2, preview and resizer
      [media] omap3isp: Move CCDC link validation to ccdc_link_validate()
      [media] smiapp: Generic SMIA++/SMIA PLL calculator
      [media] smiapp: Add driver
      [media] smiapp: Remove smiapp-debug.h in favour of dynamic debug
      [media] smiapp: Allow using external clock from the clock framework
      [media] smiapp: Pass struct sensor to register writing commands instead of i2c_client
      [media] smiapp: Quirk for sensors that only do 8-bit reads
      [media] smiapp: Use 8-bit reads only before identifying the sensor
      [media] smiapp: Round minimum pre_pll up rather than down in ip_clk_freq check
      [media] smiapp: Initialise rval in smiapp_read_nvm()
      [media] smiapp: Use non-binning limits if the binning limit is zero
      [media] smiapp: Allow generic quirk registers
      [media] smiapp: Add support for 8-bit uncompressed formats
      [media] smiapp: Use v4l2_ctrl_new_int_menu() instead of v4l2_ctrl_new_custom()

Santosh Nayak (1):
      [media] dib0700: Return -EINTR and unlock mutex if locking attempts fails

Srinivas Kandagatla (2):
      [media] [3.3.0] ir-raw: remove BUG_ON in ir_raw_event_thread
      [media] kernel:kfifo: export __kfifo_max_r symbol

Sylwester Nawrocki (44):
      [media] s5p-fimc: Don't use platform data for CSI data alignment configuration
      [media] s5p-fimc: Reinitialize the pipeline properly after VIDIOC_STREAMOFF
      [media] s5p-fimc: Simplify locking by removing the context data structure spinlock
      [media] s5p-fimc: Refactor hardware setup for m2m transaction
      [media] s5p-fimc: Remove unneeded fields from struct fimc_dev
      [media] s5p-fimc: Handle sub-device interdependencies using deferred probing
      [media] V4L: JPEG class documentation corrections
      [media] s5p-fimc: Fix locking in subdev set_crop op
      [media] V4L: Extend V4L2_CID_COLORFX with more image effects
      [media] V4L: Add helper function for standard integer menu controls
      [media] V4L: Add camera exposure bias control
      [media] V4L: Add an extended camera white balance control
      [media] V4L: Add camera wide dynamic range control
      [media] V4L: Add camera image stabilization control
      [media] V4L: Add camera ISO sensitivity controls
      [media] V4L: Add camera exposure metering control
      [media] V4L: Add camera scene mode control
      [media] V4L: Add camera 3A lock control
      [media] V4L: Add camera auto focus controls
      [media] m5mols: Convert macros to inline functions
      [media] m5mols: Refactored controls handling
      [media] m5mols: Use proper sensor mode for the controls
      [media] m5mols: Add ISO sensitivity controls
      [media] m5mols: Add auto and preset white balance control
      [media] m5mols: Add exposure bias control
      [media] m5mols: Add wide dynamic range control
      [media] m5mols: Add image stabilization control
      [media] m5mols: Add exposure metering control
      [media] m5mols: Add JPEG compression quality control
      [media] m5mols: Add 3A lock control
      [media] V4L: JPEG class documentation corrections
      [media] s5p-fimc: Avoid crash with null platform_data
      [media] s5p-fimc: Move m2m node driver into separate file
      [media] s5p-fimc: Use v4l2_subdev internal ops to register video nodes
      [media] s5p-fimc: Refactor the register interface functions
      [media] s5p-fimc: Add FIMC-LITE register definitions
      [media] s5p-fimc: Rework the video pipeline control functions
      [media] s5p-fimc: Prefix format enumerations with FIMC_FMT_
      [media] s5p-fimc: Minor cleanups
      [media] s5p-fimc: Make sure an interrupt is properly requested
      [media] s5p-fimc: Add support for Exynos4x12 FIMC-LITE
      [media] s5p-fimc: Update copyright notices
      [media] s5p-fimc: Add color effect control
      [media] s5p-fimc: Use selection API in place of crop operations

Tim Gardner (2):
      [media] staging: go7007: Add MODULE_FIRMWARE
      [media] video: vicam: Add MODULE_FIRMWARE

Tomasz Stanislawski (5):
      [media] v4l: s5p-tv: mixer: fix compilation warning
      [media] v4l: s5p-tv: hdmiphy: add support for per-platform variants
      [media] v4l: s5p-tv: hdmi: parametrize DV timings
      [media] v4l: s5p-tv: hdmi: fix mode synchronization
      [media] v4l: s5p-tv: mixer: fix handling of interlaced modes

Uwe Kleine-König (1):
      [media] s5p-tv: mark const init data with __initconst instead of __initdata

Volokh Konstantin (1):
      [media] staging: media: go7007: Adlink MPG24 board issues

Xi Wang (3):
      [media] v4l2-ctrls: fix integer overflow in v4l2_g_ext_ctrls()
      [media] v4l2-ctrls: fix integer overflow in try_set_ext_ctrls()
      [media] zoran: fix integer overflow in setup_window()

joseph daniel (2):
      [media] staging/media/as102: removed else statements
      [media] staging/media/as102: remove version.h include at as102_fe.c

remi schwartz (1):
      [media] patch for Asus My Cinema PS3-100 (1043:48cd)

 Documentation/DocBook/media/Makefile               |    4 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml    |  160 ++
 Documentation/DocBook/media/v4l/biblio.xml         |   29 +
 Documentation/DocBook/media/v4l/common.xml         |   38 +-
 Documentation/DocBook/media/v4l/compat.xml         |   75 +
 Documentation/DocBook/media/v4l/controls.xml       |  708 +++++-
 Documentation/DocBook/media/v4l/dev-subdev.xml     |  202 ++-
 Documentation/DocBook/media/v4l/io.xml             |   12 +-
 Documentation/DocBook/media/v4l/pixfmt-srggb10.xml |    2 +-
 .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |   29 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |    6 +-
 .../media/v4l/subdev-image-processing-crop.dia     |  614 +++++
 .../media/v4l/subdev-image-processing-crop.svg     |   63 +
 .../media/v4l/subdev-image-processing-full.dia     | 1588 +++++++++++
 .../media/v4l/subdev-image-processing-full.svg     |  163 ++
 ...ubdev-image-processing-scaling-multi-source.dia | 1152 ++++++++
 ...ubdev-image-processing-scaling-multi-source.svg |  116 +
 Documentation/DocBook/media/v4l/v4l2.xml           |   44 +-
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |   16 +-
 Documentation/DocBook/media/v4l/vidioc-cropcap.xml |    4 +-
 .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    |  211 ++
 .../DocBook/media/v4l/vidioc-enum-dv-presets.xml   |    4 +
 .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   |  119 +
 .../DocBook/media/v4l/vidioc-enum-fmt.xml          |    4 +-
 .../DocBook/media/v4l/vidioc-enuminput.xml         |    2 +-
 .../DocBook/media/v4l/vidioc-enumoutput.xml        |    2 +-
 Documentation/DocBook/media/v4l/vidioc-g-crop.xml  |    4 +-
 .../DocBook/media/v4l/vidioc-g-dv-preset.xml       |    6 +
 .../DocBook/media/v4l/vidioc-g-dv-timings.xml      |  130 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   26 +
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |    2 +-
 .../DocBook/media/v4l/vidioc-g-frequency.xml       |    6 +-
 Documentation/DocBook/media/v4l/vidioc-g-parm.xml  |    5 +-
 .../DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml  |    2 +-
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |    2 +-
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |    6 +
 .../DocBook/media/v4l/vidioc-query-dv-preset.xml   |    4 +
 .../DocBook/media/v4l/vidioc-query-dv-timings.xml  |  104 +
 .../DocBook/media/v4l/vidioc-queryctrl.xml         |   41 +-
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |    7 +-
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |    5 +-
 .../DocBook/media/v4l/vidioc-subdev-g-crop.xml     |    9 +-
 .../media/v4l/vidioc-subdev-g-selection.xml        |  228 ++
 Documentation/dvb/get_dvb_firmware                 |   20 +-
 Documentation/feature-removal-schedule.txt         |    9 +
 Documentation/media-framework.txt                  |   19 +
 Documentation/video4linux/4CCs.txt                 |   32 +
 Documentation/video4linux/gspca.txt                |    1 +
 Documentation/video4linux/v4l2-controls.txt        |   21 +
 Documentation/video4linux/v4l2-framework.txt       |  106 +-
 MAINTAINERS                                        |    9 +-
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        |    2 +-
 arch/arm/plat-mxc/include/mach/mx2_cam.h           |    2 -
 drivers/input/ff-memless.c                         |    3 +-
 drivers/media/common/saa7146_fops.c                |  126 +-
 drivers/media/common/saa7146_hlp.c                 |   23 +-
 drivers/media/common/saa7146_vbi.c                 |   54 +-
 drivers/media/common/saa7146_video.c               |  367 +--
 drivers/media/common/tuners/Kconfig                |   27 +
 drivers/media/common/tuners/Makefile               |    4 +
 drivers/media/common/tuners/fc0011.c               |  524 ++++
 drivers/media/common/tuners/fc0011.h               |   41 +
 drivers/media/common/tuners/fc0012-priv.h          |   43 +
 drivers/media/common/tuners/fc0012.c               |  467 ++++
 drivers/media/common/tuners/fc0012.h               |   44 +
 drivers/media/common/tuners/fc0013-priv.h          |   44 +
 drivers/media/common/tuners/fc0013.c               |  634 +++++
 drivers/media/common/tuners/fc0013.h               |   57 +
 drivers/media/common/tuners/fc001x-common.h        |   39 +
 drivers/media/common/tuners/tua9001.c              |  215 ++
 drivers/media/common/tuners/tua9001.h              |   46 +
 drivers/media/common/tuners/tua9001_priv.h         |   34 +
 drivers/media/common/tuners/xc5000.c               |    7 +-
 drivers/media/common/tuners/xc5000.h               |    2 +-
 drivers/media/dvb/bt8xx/dst_ca.c                   |    2 -
 drivers/media/dvb/ddbridge/ddbridge-core.c         |    3 +-
 drivers/media/dvb/dvb-core/dvb_demux.c             |   10 +
 drivers/media/dvb/dvb-core/dvb_demux.h             |    2 +
 drivers/media/dvb/dvb-core/dvb_frontend.c          |   80 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |   18 +
 drivers/media/dvb/dvb-usb/Kconfig                  |   13 +
 drivers/media/dvb/dvb-usb/Makefile                 |    3 +
 drivers/media/dvb/dvb-usb/af9015.c                 |  495 ++--
 drivers/media/dvb/dvb-usb/af9035.c                 | 1242 +++++++++
 drivers/media/dvb/dvb-usb/af9035.h                 |  113 +
 drivers/media/dvb/dvb-usb/dib0700_core.c           |   24 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |    7 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |   12 +
 drivers/media/dvb/dvb-usb/dvb-usb-urb.c            |   12 +
 drivers/media/dvb/dvb-usb/dvb-usb.h                |    3 +-
 drivers/media/dvb/dvb-usb/dw2102.c                 |   76 +-
 drivers/media/dvb/dvb-usb/it913x.c                 |    4 +-
 drivers/media/dvb/dvb-usb/lmedm04.c                |    5 +-
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c         |    1 +
 drivers/media/dvb/dvb-usb/mxl111sf.c               |  872 ++++++-
 drivers/media/dvb/dvb-usb/rtl28xxu.c               |   28 +
 drivers/media/dvb/frontends/Kconfig                |   35 +-
 drivers/media/dvb/frontends/Makefile               |    7 +-
 drivers/media/dvb/frontends/af9013.c               |   13 +-
 drivers/media/dvb/frontends/af9033.c               |  980 +++++++
 drivers/media/dvb/frontends/af9033.h               |   75 +
 drivers/media/dvb/frontends/af9033_priv.h          |  470 ++++
 drivers/media/dvb/frontends/au8522_common.c        |  259 ++
 drivers/media/dvb/frontends/au8522_dig.c           |  215 --
 drivers/media/dvb/frontends/au8522_priv.h          |    2 +
 drivers/media/dvb/frontends/cx24110.c              |    7 +-
 drivers/media/dvb/frontends/cxd2820r_core.c        |    4 +-
 drivers/media/dvb/frontends/dib7000p.c             |    5 -
 drivers/media/dvb/frontends/dib9000.c              |  131 +-
 drivers/media/dvb/frontends/drxd.h                 |   14 +
 drivers/media/dvb/frontends/drxk_hard.c            |   18 +-
 drivers/media/dvb/frontends/drxk_map.h             |    2 +
 drivers/media/dvb/frontends/ds3000.c               |    5 +-
 drivers/media/dvb/frontends/it913x-fe.c            |   26 +-
 drivers/media/dvb/frontends/lg2160.c               | 1468 ++++++++++
 drivers/media/dvb/frontends/lg2160.h               |   84 +
 drivers/media/dvb/frontends/lgs8gxx.c              |    3 +-
 drivers/media/dvb/frontends/m88rs2000.c            |   29 +-
 drivers/media/dvb/frontends/rtl2830.c              |  201 ++-
 drivers/media/dvb/frontends/rtl2830_priv.h         |    1 +
 drivers/media/dvb/frontends/stb0899_drv.c          |    8 +-
 drivers/media/dvb/frontends/stb6100.c              |    3 +-
 drivers/media/dvb/frontends/stv0297.c              |    2 -
 drivers/media/dvb/frontends/stv0900_sw.c           |    2 -
 drivers/media/dvb/frontends/stv090x.c              |    2 -
 drivers/media/dvb/frontends/zl10353.c              |    5 +-
 drivers/media/dvb/mantis/hopper_cards.c            |    3 +-
 drivers/media/dvb/mantis/mantis_cards.c            |    3 +-
 drivers/media/dvb/mantis/mantis_dma.c              |    4 -
 drivers/media/dvb/mantis/mantis_evm.c              |    3 +-
 drivers/media/dvb/ngene/ngene-core.c               |    4 +-
 drivers/media/dvb/pluto2/pluto2.c                  |    8 -
 drivers/media/dvb/siano/smssdio.c                  |    4 +-
 drivers/media/dvb/siano/smsusb.c                   |    2 +
 drivers/media/dvb/ttpci/av7110_v4l.c               |   72 +-
 drivers/media/dvb/ttpci/budget-av.c                |    6 +-
 drivers/media/media-entity.c                       |   57 +-
 drivers/media/radio/Kconfig                        |    4 +-
 drivers/media/radio/dsbr100.c                      |  528 ++---
 drivers/media/radio/radio-gemtek.c                 |   25 +
 drivers/media/radio/radio-isa.c                    |  173 +-
 drivers/media/radio/radio-isa.h                    |    9 +
 drivers/media/radio/radio-keene.c                  |   36 +-
 drivers/media/radio/radio-mr800.c                  |  524 ++--
 drivers/media/radio/radio-rtrack2.c                |    1 +
 drivers/media/radio/radio-sf16fmi.c                |   14 +-
 drivers/media/radio/radio-sf16fmr2.c               |  144 +-
 drivers/media/radio/radio-timb.c                   |    2 +-
 drivers/media/radio/saa7706h.c                     |    2 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |  305 +--
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   65 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |  265 +-
 drivers/media/radio/si470x/radio-si470x.h          |   14 +-
 drivers/media/radio/tef6862.c                      |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    4 +
 drivers/media/rc/Kconfig                           |    1 +
 drivers/media/rc/ati_remote.c                      |  146 +-
 drivers/media/rc/fintek-cir.c                      |   13 +-
 drivers/media/rc/imon.c                            |    2 +-
 drivers/media/rc/ir-raw.c                          |    8 +-
 drivers/media/rc/ir-sanyo-decoder.c                |    4 +-
 drivers/media/rc/ite-cir.c                         |   14 +-
 drivers/media/rc/keymaps/Makefile                  |    3 +
 drivers/media/rc/keymaps/rc-asus-ps3-100.c         |   91 +
 drivers/media/rc/keymaps/rc-it913x-v2.c            |    2 +-
 .../media/rc/keymaps/rc-medion-x10-digitainer.c    |  123 +
 drivers/media/rc/keymaps/rc-medion-x10-or2x.c      |  108 +
 drivers/media/rc/mceusb.c                          |    5 +-
 drivers/media/rc/nuvoton-cir.c                     |   26 +-
 drivers/media/rc/rc-loopback.c                     |    1 -
 drivers/media/rc/redrat3.c                         |    2 +-
 drivers/media/video/Kconfig                        |   48 +-
 drivers/media/video/Makefile                       |    5 +-
 drivers/media/video/adp1653.c                      |    9 +-
 drivers/media/video/adv7180.c                      |  417 +++-
 drivers/media/video/adv7343.c                      |    4 +-
 drivers/media/video/aptina-pll.c                   |    5 +-
 drivers/media/video/arv.c                          |    7 +-
 drivers/media/video/as3645a.c                      |   10 +-
 drivers/media/video/atmel-isi.c                    |   18 +-
 drivers/media/video/au0828/Kconfig                 |    3 +-
 drivers/media/video/au0828/au0828-cards.c          |    2 +
 drivers/media/video/au0828/au0828-dvb.c            |   27 +-
 drivers/media/video/au0828/au0828-video.c          |   25 +-
 drivers/media/video/blackfin/bfin_capture.c        |    4 +
 drivers/media/video/bt8xx/bttv-driver.c            |    4 +-
 drivers/media/video/bw-qcam.c                      |  132 +-
 drivers/media/video/c-qcam.c                       |  140 +-
 drivers/media/video/cpia2/cpia2.h                  |   34 +-
 drivers/media/video/cpia2/cpia2_core.c             |  142 +-
 drivers/media/video/cpia2/cpia2_usb.c              |   78 +-
 drivers/media/video/cpia2/cpia2_v4l.c              |  850 ++----
 drivers/media/video/cpia2/cpia2dev.h               |   50 -
 drivers/media/video/cx18/cx18-alsa-main.c          |    1 +
 drivers/media/video/cx18/cx18-alsa-pcm.c           |   10 +-
 drivers/media/video/cx18/cx18-ioctl.c              |    2 +-
 drivers/media/video/cx18/cx18-mailbox.c            |    6 +-
 drivers/media/video/cx18/cx18-streams.c            |    3 -
 drivers/media/video/cx231xx/cx231xx-417.c          |   18 +-
 drivers/media/video/cx231xx/cx231xx-audio.c        |   18 +-
 drivers/media/video/cx231xx/cx231xx-avcore.c       |  148 +-
 drivers/media/video/cx231xx/cx231xx-core.c         |   76 +-
 drivers/media/video/cx231xx/cx231xx-vbi.c          |    6 +-
 drivers/media/video/cx231xx/cx231xx-video.c        |   20 +-
 drivers/media/video/cx23885/cx23885-cards.c        |    9 +
 drivers/media/video/cx23885/cx23885-core.c         |    7 +
 drivers/media/video/cx23885/cx23885-dvb.c          |    7 +
 drivers/media/video/cx23885/cx23885.h              |    1 +
 drivers/media/video/cx23885/cx23888-ir.c           |    4 +-
 drivers/media/video/cx25821/cx25821-alsa.c         |    2 -
 .../media/video/cx25821/cx25821-audio-upstream.c   |    3 +-
 drivers/media/video/cx25821/cx25821-core.c         |   14 +-
 drivers/media/video/cx25821/cx25821-i2c.c          |    3 +-
 drivers/media/video/cx25821/cx25821-medusa-video.c |   13 +-
 .../video/cx25821/cx25821-video-upstream-ch2.c     |    3 +-
 .../media/video/cx25821/cx25821-video-upstream.c   |    3 +-
 drivers/media/video/cx25821/cx25821-video.c        |   25 +-
 drivers/media/video/cx25821/cx25821-video.h        |    2 -
 drivers/media/video/cx25840/cx25840-ir.c           |    6 +-
 drivers/media/video/davinci/Kconfig                |    1 +
 drivers/media/video/davinci/vpbe_display.c         |    4 +
 drivers/media/video/davinci/vpfe_capture.c         |    2 +-
 drivers/media/video/davinci/vpif_capture.c         |    4 +
 drivers/media/video/davinci/vpif_display.c         |    4 +
 drivers/media/video/em28xx/Kconfig                 |    4 +-
 drivers/media/video/em28xx/Makefile                |    5 +-
 drivers/media/video/em28xx/em28xx-audio.c          |   11 +-
 drivers/media/video/em28xx/em28xx-cards.c          |   81 +-
 drivers/media/video/em28xx/em28xx-core.c           |   30 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |   11 +-
 drivers/media/video/em28xx/em28xx-i2c.c            |    3 -
 drivers/media/video/em28xx/em28xx-input.c          |  250 ++-
 drivers/media/video/em28xx/em28xx-video.c          |   13 +-
 drivers/media/video/em28xx/em28xx.h                |   60 +-
 drivers/media/video/et61x251/Kconfig               |   18 -
 drivers/media/video/et61x251/Makefile              |    4 -
 drivers/media/video/et61x251/et61x251.h            |  213 --
 drivers/media/video/et61x251/et61x251_core.c       | 2683 ------------------
 drivers/media/video/et61x251/et61x251_sensor.h     |  108 -
 drivers/media/video/et61x251/et61x251_tas5130d1b.c |  143 -
 drivers/media/video/fsl-viu.c                      |    4 +
 drivers/media/video/gspca/Makefile                 |    2 +-
 drivers/media/video/gspca/autogain_functions.c     |  178 ++
 drivers/media/video/gspca/autogain_functions.h     |    6 +-
 drivers/media/video/gspca/conex.c                  |    4 +-
 drivers/media/video/gspca/finepix.c                |   18 +-
 drivers/media/video/gspca/gl860/gl860.c            |    3 +
 drivers/media/video/gspca/gspca.c                  |  545 ++---
 drivers/media/video/gspca/gspca.h                  |   26 +-
 drivers/media/video/gspca/jl2005bcd.c              |   10 +-
 drivers/media/video/gspca/mars.c                   |  292 +--
 drivers/media/video/gspca/nw80x.c                  |    2 +
 drivers/media/video/gspca/ov519.c                  |   10 +-
 drivers/media/video/gspca/ov534.c                  |  146 +-
 drivers/media/video/gspca/pac207.c                 |  336 +--
 drivers/media/video/gspca/pac7302.c                |  185 +-
 drivers/media/video/gspca/pac7311.c                |  505 ++---
 drivers/media/video/gspca/sn9c20x.c                |  594 ++---
 drivers/media/video/gspca/sonixb.c                 |    2 +
 drivers/media/video/gspca/sonixj.c                 |    5 +-
 drivers/media/video/gspca/sq905.c                  |   12 +-
 drivers/media/video/gspca/sq905c.c                 |   10 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c        |   21 +-
 drivers/media/video/gspca/stv06xx/stv06xx.h        |    3 -
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c   |  143 +-
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h   |    7 +-
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c |  359 +--
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h |   12 +-
 drivers/media/video/gspca/stv06xx/stv06xx_sensor.h |    4 +-
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |  236 +--
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.h |    4 +-
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c |  198 +-
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h |    8 +-
 drivers/media/video/gspca/topro.c                  |    6 +-
 drivers/media/video/gspca/vicam.c                  |   13 +-
 drivers/media/video/gspca/zc3xx.c                  |  620 ++---
 drivers/media/video/hdpvr/hdpvr-control.c          |    2 +
 drivers/media/video/hdpvr/hdpvr-video.c            |    2 +-
 drivers/media/video/hexium_gemini.c                |  129 +-
 drivers/media/video/hexium_orion.c                 |   24 +-
 drivers/media/video/ivtv/ivtv-driver.c             |    4 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |    6 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |    8 +-
 drivers/media/video/ivtv/ivtv-streams.c            |    4 +
 drivers/media/video/ivtv/ivtvfb.c                  |    2 +
 drivers/media/video/m5mols/m5mols.h                |   81 +-
 drivers/media/video/m5mols/m5mols_capture.c        |   11 +-
 drivers/media/video/m5mols/m5mols_controls.c       |  479 +++-
 drivers/media/video/m5mols/m5mols_core.c           |   93 +-
 drivers/media/video/m5mols/m5mols_reg.h            |    1 +
 drivers/media/video/marvell-ccic/mcam-core.c       |    1 -
 drivers/media/video/mem2mem_testdev.c              |    6 +-
 drivers/media/video/meye.c                         |    2 +-
 drivers/media/video/msp3400-driver.c               |   15 +-
 drivers/media/video/mt9m032.c                      |    4 +-
 drivers/media/video/mt9p031.c                      |  161 +-
 drivers/media/video/mt9t112.c                      |    1 +
 drivers/media/video/mt9v032.c                      |    2 +-
 drivers/media/video/mx1_camera.c                   |   14 +-
 drivers/media/video/mx2_camera.c                   |   78 +-
 drivers/media/video/mx2_emmaprp.c                  |    8 +-
 drivers/media/video/mx3_camera.c                   |   41 +-
 drivers/media/video/mxb.c                          |  351 ++--
 drivers/media/video/mxb.h                          |   42 -
 drivers/media/video/omap1_camera.c                 |   22 +-
 drivers/media/video/omap24xxcam-dma.c              |   20 +-
 drivers/media/video/omap24xxcam.c                  |    3 +-
 drivers/media/video/omap24xxcam.h                  |   14 +-
 drivers/media/video/omap3isp/isp.c                 |   59 +-
 drivers/media/video/omap3isp/isp.h                 |    8 +-
 drivers/media/video/omap3isp/ispccdc.c             |  256 ++-
 drivers/media/video/omap3isp/ispccdc.h             |   12 +-
 drivers/media/video/omap3isp/ispccp2.c             |   24 +-
 drivers/media/video/omap3isp/ispcsi2.c             |   21 +-
 drivers/media/video/omap3isp/ispcsi2.h             |    1 -
 drivers/media/video/omap3isp/ispcsiphy.c           |    4 +-
 drivers/media/video/omap3isp/ispcsiphy.h           |   15 +-
 drivers/media/video/omap3isp/isppreview.c          |  634 +++--
 drivers/media/video/omap3isp/isppreview.h          |   76 +-
 drivers/media/video/omap3isp/ispqueue.h            |    2 +-
 drivers/media/video/omap3isp/ispresizer.c          |  139 +-
 drivers/media/video/omap3isp/ispstat.c             |    2 +-
 drivers/media/video/omap3isp/ispvideo.c            |  303 ++-
 drivers/media/video/omap3isp/ispvideo.h            |    5 +
 drivers/media/video/ov5642.c                       |    2 -
 drivers/media/video/pms.c                          |  239 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    6 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |  193 +--
 drivers/media/video/pvrusb2/pvrusb2-hdw.h          |    9 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         | 1343 +++++-----
 drivers/media/video/pwc/pwc-if.c                   |  191 +-
 drivers/media/video/pwc/pwc-v4l.c                  |  145 +-
 drivers/media/video/pwc/pwc.h                      |   21 +-
 drivers/media/video/pxa_camera.c                   |   15 +-
 drivers/media/video/s2255drv.c                     |   11 +-
 drivers/media/video/s5p-fimc/Kconfig               |   48 +
 drivers/media/video/s5p-fimc/Makefile              |    6 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |  506 +++--
 drivers/media/video/s5p-fimc/fimc-core.c           | 1159 ++-------
 drivers/media/video/s5p-fimc/fimc-core.h           |  272 +--
 drivers/media/video/s5p-fimc/fimc-lite-reg.c       |  300 ++
 drivers/media/video/s5p-fimc/fimc-lite-reg.h       |  150 +
 drivers/media/video/s5p-fimc/fimc-lite.c           | 1576 +++++++++++
 drivers/media/video/s5p-fimc/fimc-lite.h           |  213 ++
 drivers/media/video/s5p-fimc/fimc-m2m.c            |  824 ++++++
 drivers/media/video/s5p-fimc/fimc-mdevice.c        |  476 +++-
 drivers/media/video/s5p-fimc/fimc-mdevice.h        |   18 +-
 drivers/media/video/s5p-fimc/fimc-reg.c            |  616 +++--
 drivers/media/video/s5p-fimc/fimc-reg.h            |  326 +++
 drivers/media/video/s5p-fimc/mipi-csis.c           |   21 +-
 drivers/media/video/s5p-fimc/regs-fimc.h           |  301 --
 drivers/media/video/s5p-g2d/g2d.c                  |   69 +-
 drivers/media/video/s5p-g2d/g2d.h                  |    1 -
 drivers/media/video/s5p-jpeg/jpeg-core.c           |   68 +-
 drivers/media/video/s5p-jpeg/jpeg-core.h           |    2 -
 drivers/media/video/s5p-mfc/s5p_mfc.c              |   81 +-
 drivers/media/video/s5p-mfc/s5p_mfc_common.h       |    2 -
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c         |   16 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c          |    6 +-
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c          |   28 +-
 drivers/media/video/s5p-tv/hdmi_drv.c              |  480 ++--
 drivers/media/video/s5p-tv/hdmiphy_drv.c           |  225 ++-
 drivers/media/video/s5p-tv/mixer.h                 |    3 +-
 drivers/media/video/s5p-tv/mixer_drv.c             |    2 +-
 drivers/media/video/s5p-tv/mixer_reg.c             |   15 +-
 drivers/media/video/s5p-tv/mixer_video.c           |   10 +-
 drivers/media/video/s5p-tv/regs-hdmi.h             |    1 +
 drivers/media/video/saa7134/saa7134-cards.c        |   45 +
 drivers/media/video/saa7134/saa7134-dvb.c          |   39 +
 drivers/media/video/saa7134/saa7134-input.c        |    7 +
 drivers/media/video/saa7134/saa7134-video.c        |    2 +-
 drivers/media/video/saa7134/saa7134.h              |    1 +
 drivers/media/video/saa7164/saa7164-vbi.c          |    4 +-
 drivers/media/video/saa7164/saa7164.h              |    5 -
 drivers/media/video/sh_mobile_ceu_camera.c         |   92 +-
 drivers/media/video/sh_vou.c                       |    4 +
 drivers/media/video/smiapp-pll.c                   |  418 +++
 drivers/media/video/smiapp-pll.h                   |  103 +
 drivers/media/video/smiapp/Kconfig                 |    6 +
 drivers/media/video/smiapp/Makefile                |    5 +
 drivers/media/video/smiapp/smiapp-core.c           | 2894 ++++++++++++++++++++
 drivers/media/video/smiapp/smiapp-limits.c         |  132 +
 drivers/media/video/smiapp/smiapp-limits.h         |  128 +
 drivers/media/video/smiapp/smiapp-quirk.c          |  306 +++
 drivers/media/video/smiapp/smiapp-quirk.h          |   83 +
 drivers/media/video/smiapp/smiapp-reg-defs.h       |  503 ++++
 drivers/media/video/smiapp/smiapp-reg.h            |  122 +
 drivers/media/video/smiapp/smiapp-regs.c           |  273 ++
 drivers/media/video/smiapp/smiapp-regs.h           |   49 +
 drivers/media/video/smiapp/smiapp.h                |  252 ++
 drivers/media/video/sn9c102/sn9c102_core.c         |    4 +-
 drivers/media/video/soc_camera.c                   |   55 +-
 drivers/media/video/soc_mediabus.c                 |   54 +
 drivers/media/video/sta2x11_vip.c                  | 1550 +++++++++++
 drivers/media/video/sta2x11_vip.h                  |   40 +
 drivers/media/video/stk-webcam.c                   |    8 +-
 drivers/media/video/tda9840.c                      |   75 +-
 drivers/media/video/tlg2300/pd-video.c             |    1 -
 drivers/media/video/tm6000/tm6000-input.c          |    3 +-
 drivers/media/video/tm6000/tm6000-stds.c           |    2 -
 drivers/media/video/tm6000/tm6000-video.c          |   14 +-
 drivers/media/video/tm6000/tm6000.h                |    2 -
 drivers/media/video/tuner-core.c                   |   15 +-
 drivers/media/video/tvp5150.c                      |   11 +-
 drivers/media/video/tvp7002.c                      |  105 +-
 drivers/media/video/usbvision/usbvision-core.c     |   12 +-
 drivers/media/video/usbvision/usbvision-video.c    |    4 +
 drivers/media/video/uvc/uvc_ctrl.c                 |  330 ++-
 drivers/media/video/uvc/uvc_queue.c                |   43 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |   50 +-
 drivers/media/video/uvc/uvcvideo.h                 |   26 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |   15 +-
 drivers/media/video/v4l2-ctrls.c                   |  302 ++-
 drivers/media/video/v4l2-dev.c                     |  218 ++-
 drivers/media/video/v4l2-event.c                   |   71 +-
 drivers/media/video/v4l2-ioctl.c                   |  662 ++---
 drivers/media/video/v4l2-subdev.c                  |  143 +-
 drivers/media/video/via-camera.c                   |   15 +-
 drivers/media/video/videobuf-core.c                |    3 +-
 drivers/media/video/videobuf-dma-contig.c          |  199 +-
 drivers/media/video/videobuf-dvb.c                 |    3 +-
 drivers/media/video/videobuf2-core.c               |   50 +-
 drivers/media/video/vivi.c                         |  223 ++-
 drivers/media/video/w9966.c                        |   94 +-
 drivers/media/video/zoran/zoran_device.c           |    2 -
 drivers/media/video/zoran/zoran_driver.c           |   20 +-
 drivers/media/video/zr364xx.c                      |    2 -
 drivers/staging/android/ashmem.c                   |    2 +-
 drivers/staging/media/as102/as102_fe.c             |    2 -
 drivers/staging/media/as102/as102_fw.c             |    5 +-
 drivers/staging/media/as102/as10x_cmd.c            |   28 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |    4 +
 drivers/staging/media/easycap/easycap_main.c       | 1662 ++++++-----
 drivers/staging/media/go7007/go7007-v4l2.c         |    2 -
 drivers/staging/media/go7007/s2250-loader.c        |    2 +
 drivers/staging/media/lirc/lirc_imon.c             |    4 -
 drivers/staging/media/lirc/lirc_sasem.c            |    4 -
 drivers/usb/gadget/uvc_queue.c                     |    2 +-
 drivers/usb/gadget/uvc_v4l2.c                      |    2 +-
 include/linux/Kbuild                               |    1 +
 include/linux/dvb/frontend.h                       |   51 +-
 include/linux/dvb/version.h                        |    2 +-
 {drivers/input => include/linux}/fixp-arith.h      |    0
 include/linux/v4l2-dv-timings.h                    |  816 ++++++
 include/linux/v4l2-subdev.h                        |   41 +
 include/linux/videodev2.h                          |  372 ++-
 include/media/media-entity.h                       |    5 +-
 include/media/mt9p031.h                            |   19 +-
 include/media/omap3isp.h                           |   29 +
 include/media/rc-map.h                             |    3 +
 include/media/s5p_fimc.h                           |   16 +
 include/media/saa7146.h                            |    4 +-
 include/media/saa7146_vv.h                         |   25 +-
 include/media/sh_mobile_ceu.h                      |    1 +
 include/media/smiapp.h                             |   84 +
 include/media/soc_camera.h                         |    6 +-
 include/media/soc_mediabus.h                       |   21 +
 include/media/v4l2-ctrls.h                         |   40 +-
 include/media/v4l2-dev.h                           |   25 +
 include/media/v4l2-event.h                         |   24 +-
 include/media/v4l2-ioctl.h                         |    6 +
 include/media/v4l2-subdev.h                        |   55 +-
 include/media/videobuf-dma-contig.h                |   10 +
 kernel/kfifo.c                                     |    1 +
 sound/i2c/other/tea575x-tuner.c                    |    3 +
 465 files changed, 39196 insertions(+), 16784 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-crop.svg
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-full.dia
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-full.svg
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
 create mode 100644 Documentation/video4linux/4CCs.txt
 create mode 100644 drivers/media/common/tuners/fc0011.c
 create mode 100644 drivers/media/common/tuners/fc0011.h
 create mode 100644 drivers/media/common/tuners/fc0012-priv.h
 create mode 100644 drivers/media/common/tuners/fc0012.c
 create mode 100644 drivers/media/common/tuners/fc0012.h
 create mode 100644 drivers/media/common/tuners/fc0013-priv.h
 create mode 100644 drivers/media/common/tuners/fc0013.c
 create mode 100644 drivers/media/common/tuners/fc0013.h
 create mode 100644 drivers/media/common/tuners/fc001x-common.h
 create mode 100644 drivers/media/common/tuners/tua9001.c
 create mode 100644 drivers/media/common/tuners/tua9001.h
 create mode 100644 drivers/media/common/tuners/tua9001_priv.h
 create mode 100644 drivers/media/dvb/dvb-usb/af9035.c
 create mode 100644 drivers/media/dvb/dvb-usb/af9035.h
 create mode 100644 drivers/media/dvb/frontends/af9033.c
 create mode 100644 drivers/media/dvb/frontends/af9033.h
 create mode 100644 drivers/media/dvb/frontends/af9033_priv.h
 create mode 100644 drivers/media/dvb/frontends/au8522_common.c
 create mode 100644 drivers/media/dvb/frontends/lg2160.c
 create mode 100644 drivers/media/dvb/frontends/lg2160.h
 create mode 100644 drivers/media/rc/keymaps/rc-asus-ps3-100.c
 create mode 100644 drivers/media/rc/keymaps/rc-medion-x10-digitainer.c
 create mode 100644 drivers/media/rc/keymaps/rc-medion-x10-or2x.c
 delete mode 100644 drivers/media/video/cpia2/cpia2dev.h
 delete mode 100644 drivers/media/video/et61x251/Kconfig
 delete mode 100644 drivers/media/video/et61x251/Makefile
 delete mode 100644 drivers/media/video/et61x251/et61x251.h
 delete mode 100644 drivers/media/video/et61x251/et61x251_core.c
 delete mode 100644 drivers/media/video/et61x251/et61x251_sensor.h
 delete mode 100644 drivers/media/video/et61x251/et61x251_tas5130d1b.c
 create mode 100644 drivers/media/video/gspca/autogain_functions.c
 delete mode 100644 drivers/media/video/mxb.h
 create mode 100644 drivers/media/video/s5p-fimc/Kconfig
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite-reg.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite-reg.h
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite.h
 create mode 100644 drivers/media/video/s5p-fimc/fimc-m2m.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-reg.h
 delete mode 100644 drivers/media/video/s5p-fimc/regs-fimc.h
 create mode 100644 drivers/media/video/smiapp-pll.c
 create mode 100644 drivers/media/video/smiapp-pll.h
 create mode 100644 drivers/media/video/smiapp/Kconfig
 create mode 100644 drivers/media/video/smiapp/Makefile
 create mode 100644 drivers/media/video/smiapp/smiapp-core.c
 create mode 100644 drivers/media/video/smiapp/smiapp-limits.c
 create mode 100644 drivers/media/video/smiapp/smiapp-limits.h
 create mode 100644 drivers/media/video/smiapp/smiapp-quirk.c
 create mode 100644 drivers/media/video/smiapp/smiapp-quirk.h
 create mode 100644 drivers/media/video/smiapp/smiapp-reg-defs.h
 create mode 100644 drivers/media/video/smiapp/smiapp-reg.h
 create mode 100644 drivers/media/video/smiapp/smiapp-regs.c
 create mode 100644 drivers/media/video/smiapp/smiapp-regs.h
 create mode 100644 drivers/media/video/smiapp/smiapp.h
 create mode 100644 drivers/media/video/sta2x11_vip.c
 create mode 100644 drivers/media/video/sta2x11_vip.h
 rename {drivers/input => include/linux}/fixp-arith.h (100%)
 create mode 100644 include/linux/v4l2-dv-timings.h
 create mode 100644 include/media/smiapp.h


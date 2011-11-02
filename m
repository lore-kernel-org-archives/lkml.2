Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1KBJE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 05:04:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62150 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1KBJEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 05:04:54 -0400
Date: Wed, 2 Nov 2011 10:04:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v3.2-rc1] media drivers/core updates
In-Reply-To: <4EAE976C.3020607@redhat.com>
Message-ID: <Pine.LNX.4.64.1111020957580.18080@axis700.grange>
References: <4EAE976C.3020607@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:pSktOQPp+pyDGR+GAKtyHMjuuMUcsA3s4UZCzDmPY9M
 hf70YZ7JIHvcnd8t2fY0VIcwhJ8r6PYWIMXnVz4x/5NKCSwLvj
 LUq9OUkyZiB5mbczwHuLkfIZkn8ectc9A79nDYwST/YFB548CE
 Ec0YmEuLtdBi6S1/yMxxhf31ONM/nANkMU3XNzZPuU6g5alH3Y
 Q7GzKRzd/wFHWhkZ21IqtPJEdjMRX1gRRK5C6CEarAtrMScoS0
 2eBnkFn3rpGJxxKrWqoamD6RFmntwyZeml2U0NX2i2AXrxWt71
 QwOz+CXb1pWYax7tOKGQZ4VqLONYWqXAQ6rCfogwDCZZpQGUq4
 HFKkps+kfv6HvTzmPdHkrWPP6zdPtFrYq0ZVb773gHl04yoAwD
 E1gysvZBoyCBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro

On Mon, 31 Oct 2011, Mauro Carvalho Chehab wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi Linus,
> 
> Please pull from:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
> 
> For the latest improvements at the media subsystem, including:
> 	dvb-core: several fixes and addition for DVB turbo delivery system
> 		  (used on North American satellite streams);
> 	dvb-usb: add support for multiple frontends;
> 	ati-remote: migrate to rc-core subsystem;
> 	new dvb-usb drivers:it913x, mxl111sf and pctv452e;
> 	new frontends: a8293, it913x-fe, lnbp22 and tda10071;
> 	Alsa driver for cx23885-based cards;
> 	new gspca driver: topro;
> 	new sensor drivers: mt9p031, mt9t001;
> 	new driver for Samsung SoC s5p fimc;
> 	drivers moved from staging: tda6000 and altera-stapl;
> 	several fixes, card additions and improvements at the existing drivers.

Could you, please, confirm, that there's not going to be even an attempt 
to push V4L patches from my tree up for 3.2, as requested more than a 
month ago:

http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/38854

and re-requested a couple of times since then? It would really be a major 
inconvenience to have those patches lying around until 3.3, there are 101 
of them, many of them will inevitably fail to apply then. Fixing them 
will cause breakage, re-testing on multiple systems with multiple hardware 
configurations and in multiple scenarious will be a very time-consuming 
operation.

Thanks
Guennadi

> 
> Thanks!
> Mauro
> 
> - -
> 
> Latest commit at the branch: bac2dacd5fb9ddad093d7a2dc5ab44e764874821 [media] pctv452e: Remove bogus code
> 
> The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:
> 
>   Linux 3.1 (2011-10-24 09:10:05 +0200)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
> 
> Al Cooper (1):
>       [media] media: Fix a UVC performance problem on systems with non-coherent DMA
> 
> Andreas Oberritter (12):
>       [media] DVB: dvb_frontend: fix stale parameters on initial frontend event
>       [media] DVB: dvb_frontend: avoid possible race condition on first event
>       [media] DVB: dvb_frontend: clear stale events on FE_SET_FRONTEND
>       [media] DVB: dvb_frontend: update locking in dvb_frontend_{add, get_event}
>       [media] DVB: Add SYS_TURBO for north american turbo code FEC
>       [media] DVB: dvb_frontend: Fix compatibility criteria for satellite receivers
>       [media] DVB: gp8psk-fe: use SYS_TURBO
>       [media] DVB: improve documentation for satellite delivery systems
>       [media] DVB: Change API version in documentation: 3 -> 5.4
>       [media] DVB: dvb_frontend: remove static assignments from dtv_property_cache_sync()
>       [media] DVB: increment minor version after addition of SYS_TURBO
>       [media] DVB: dvb_frontend: check function pointers on reinitialize
> 
> Andrzej Pietrasiewicz (1):
>       [media] media: mem2mem: eliminate possible NULL pointer dereference
> 
> Andy Shevchenko (3):
>       [media] adp1653: check platform_data before usage
>       [media] adp1653: check error code of adp1653_init_controls
>       [media] adp1653: set media entity type
> 
> Andy Walls (1):
>       [media] cx23885, cx25840: Provide IR Rx timeout event reports
> 
> Anssi Hannula (7):
>       [media] move ati_remote driver from input/misc to media/rc
>       [media] ati_remote: migrate to the rc subsystem
>       [media] ati_remote: parent input devices to usb interface
>       [media] ati_remote: fix check for a weird byte
>       [media] ati_remote: add keymap for Medion X10 RF remote
>       [media] ati_remote: add support for SnapStream Firefly remote
>       [media] ati_remote: update Kconfig description
> 
> Antti Palosaari (14):
>       [media] dvb-usb: prepare for multi-frontend support (MFE)
>       [media] dvb-usb: multi-frontend support (MFE)
>       [media] anysee: use multi-frontend (MFE)
>       [media] em28xx: use MFE lock for PCTV nanoStick T2 290e
>       [media] af9015: map remote for Leadtek WinFast DTV2000DS
>       [media] af9015: use logic or instead of sum numbers
>       [media] a8293: Allegro A8293 SEC driver
>       [media] tda10071: NXP TDA10071 DVB-S/S2 driver
>       [media] em28xx: add support for PCTV DVB-S2 Stick 460e [2013:024f]
>       [media] get_dvb_firmware: add dvb-fe-tda10071.fw
>       [media] get_dvb_firmware: update tda10071 file url
>       [media] tda10071: do not download last byte of fw
>       [media] tda10071: change sleeps to more suitable ones
>       [media] get_dvb_firmware: whitespace fix
> 
> Arnaud Lacombe (1):
>       [media] drivers/media: do not use EXTRA_CFLAGS
> 
> Arne Caspari (1):
>       [media] uvcvideo: Detect The Imaging Source CCD cameras by vendor and product ID
> 
> Arvydas Sidorenko (3):
>       [media] drivers/media/video/stk-webcam.c: webcam LED bug fix
>       [media] drivers/media/video/stk-webcam.c: coding style issue
>       [media] stk-webcam.c: webcam LED bug fix
> 
> Benjamin Larsson (1):
>       [media] get_dvb_firmware: Firmware extraction for IT9135 based devices
> 
> Chris Rankin (13):
>       [media] Add missing OK key to PCTV IR keymap
>       [media] em28xx: pass correct buffer size to snprintf
>       [media] em28xx: use atomic bit operations for devices-in-use mask
>       [media] em28xx: clean up resources should init fail
>       [media] em28xx: move printk lines outside mutex lock
>       [media] em28xx: don't sleep on disconnect
>       [media] EM28xx - Fix memory leak on disconnect or error
>       [media] em28xx: ERROR: "em28xx_add_into_devlist" [drivers/media/video/em28xx/em28xx.ko] undefined!
>       [media] em28xx: Fix em28xx_devused cleanup logic on error
>       [media] em28xx: fix race on disconnect
>       [media] em28xx: fix deadlock when unplugging and replugging a DVB adapter
>       [media] em28xx: remove unused prototypes
>       [media] em28xx: replug locking cleanup
> 
> Christian Gmeiner (1):
>       [media] adv7175: Make use of media bus pixel codes
> 
> Dan Carpenter (6):
>       [media] dib7000p: return error code on allocation failure
>       [media] dib9000: return error code on failure
>       [media] ddbridge: fix ddb_ioctl()
>       [media] mxl111sf: fix a couple precedence bugs
>       [media] dib9000: release a lock on error
>       [media] rc/ir-lirc-codec: cleanup __user tags
> 
> Daniel Drake (1):
>       [media] mmp_camera: add MODULE_ALIAS
> 
> Doron Cohen (1):
>       [media] siano: apply debug flag to module level
> 
> Edward Sheldrake (1):
>       [media] drxd: fix divide error
> 
> Erik Andrén (5):
>       [media] gspca-stv06xx: Simplify register writes by avoiding special data structures
>       [media] gspca-stv06xx: Simplify stv_init struct and vv6410 bridge init
>       [media] gspca-stv06xx: Fix sensor init indentation
>       [media] gspca-stv06xx: Remove writes to read-only registers
>       [media] gspca-stv06xx: Triple frame rate by decreasing the scan rate
> 
> Florent AUDEBERT (1):
>       [media] stb0899: Removed an extra byte sent at init on DiSEqC bus
> 
> Frank Schaefer (1):
>       [media] gspca - sn9c20x: Fix status LED device 0c45:62b3
> 
> Guy Martin (1):
>       [media] stv090x: set status bits when there is no lock
> 
> Hans Petter Selasky (1):
>       [media] Increase a timeout, so that bad scheduling does not accidentially cause a timeout
> 
> Hans Verkuil (25):
>       [media] radio-si4713.c: fix compiler warning
>       [media] mt20xx.c: fix compiler warnings
>       [media] wl128x: fix compiler warning + wrong write() return
>       [media] saa7146: fix compiler warning
>       [media] ddbridge: fix compiler warnings
>       [media] mxl5005s: fix compiler warning
>       [media] af9005-fe: fix compiler warning
>       [media] tvaudio: fix compiler warnings
>       [media] az6027: fix compiler warnings
>       [media] mantis: fix compiler warnings
>       [media] drxd_hard: fix compiler warnings
>       [media] vpx3220, bt819: fix compiler warnings
>       [media] si470x: fix compile warning
>       [media] dvb_frontend: fix compile warning
>       [media] vivi: fill in colorspace
>       [media] ivtv: fill in service_set
>       [media] v4l2-ioctl: more -ENOTTY fixes
>       [media] videodev2.h: add V4L2_CTRL_FLAG_VOLATILE
>       [media] v4l2-ctrls: replace is_volatile with V4L2_CTRL_FLAG_VOLATILE
>       [media] v4l2-ctrls: implement new volatile autocluster scheme
>       [media] v4l2-controls.txt: update auto cluster documentation
>       [media] pwc: switch to the new auto-cluster volatile handling
>       [media] vivi: add support for VIDIOC_LOG_STATUS
>       [media] pwc: add support for VIDIOC_LOG_STATUS
>       [media] saa7115: use the new auto cluster support
> 
> Hatim Ali (1):
>       [media] s5p-tv: Add PM_RUNTIME dependency
> 
> Igor M. Liplianin (4):
>       [media] cx23885: fix type error
>       [media] altera-stapl: it is time to move out from staging
>       [media] dvb: Add support for pctv452e
>       [media] pctv452e: Remove bogus code
> 
> Jarod Wilson (13):
>       [media] imon: rate-limit send_packet spew
>       [media] mceusb: command/response updates from MS docs
>       [media] mceusb: give hardware time to reply to cmds
>       [media] mceusb: set wakeup bits for IR-based resume
>       [media] mceusb: issue device resume cmd when needed
>       [media] mceusb: query device for firmware emulator version
>       [media] mceusb: get misc port data from hardware
>       [media] mceusb: flash LED (emu v2+ only) to signal end of init
>       [media] mceusb: report actual tx frequencies
>       [media] mceusb: update version, copyright, author
>       [media] redrat3: remove unused dev struct members
>       [media] em28xx: add em28xx_ prefix to functions
>       [media] imon: don't parse scancodes until intf configured
> 
> Javier Martin (1):
>       [media] mt9p031: Aptina (Micron) MT9P031 5MP sensor driver
> 
> Javier Martinez Canillas (1):
>       [media] tvp5150: Add video format registers configuration values
> 
> Jean-François Moine (21):
>       [media] gspca - ov519: Fix LED inversion of some ov519 webcams
>       [media] gspca - sonixj: Fix the darkness of sensor om6802 in 320x240
>       [media] gspca - jeilinj: Cleanup code
>       [media] gspca - sonixj: Adjust the contrast control
>       [media] gspca - sonixj: Increase the exposure for sensor soi768
>       [media] gspca - sonixj: Cleanup source and remove useless instructions
>       [media] gspca - kinect: Remove the gspca_debug definition
>       [media] gspca - ov534_9: Use the new control mechanism
>       [media] gspca - ov534_9: New sensor ov9712 and new webcam 05a9:8065
>       [media] gspca - main: Fix the isochronous transfer interval
>       [media] gspca - main: Better values for V4L2_FMT_FLAG_COMPRESSED
>       [media] gspca - benq: Remove the useless function sd_isoc_init
>       [media] gspca - main: Use a better altsetting for image transfer
>       [media] gspca - main: Handle the xHCI error on usb_set_interface()
>       [media] gspca - topro: New subdriver for Topro webcams
>       [media] gspca - spca1528: Increase the status waiting time
>       [media] gspca - spca1528: Add some comments and update copyright
>       [media] gspca - spca1528: Change the JPEG quality of the images
>       [media] gspca - spca1528: Don't force the USB transfer alternate setting
>       [media] gspca - main: Version change to 2.14.0
>       [media] gspca - main: Display the subdriver name and version at probe time
> 
> Joe Perches (15):
>       [media] tda18271: Use printk extension %pV
>       [media] tda18212: Use standard logging, remove tda18212_priv.h
>       [media] saa7146: Use current logging styles
>       [media] rc-core.h: Surround macro with do {} while (0)
>       [media] ene_ir: Use current logging styles
>       [media] winbond-cir: Use current logging styles
>       [media] bt8xx: Use current logging styles
>       [media] et61x251: Use current logging styles
>       [media] gl860: Use current logging styles
>       [media] m5602: Use current logging styles
>       [media] finepix: Use current logging styles
>       [media] pac207: Use current logging styles
>       [media] sn9c20x: Use current logging styles
>       [media] t613: Use current logging styles
>       [media] gspca: Use current logging styles
> 
> Jonathan Corbet (1):
>       [media] videobuf2: Do not unconditionally map S/G buffers into kernel space
> 
> Jonghun Han (1):
>       [media] media: DocBook: Fix trivial typo in Sub-device Interface
> 
> Jose Alberto Reguero (3):
>       [media] tda827x: improve recection with limit frequencies
>       [media] ttusb2: add support for the dvb-t part of CT-3650 v3
>       [media] ttusb2: TT CT-3650 CI support
> 
> Julia Lawall (3):
>       [media] drivers/media/dvb/dvb-usb/usb-urb.c: adjust array index
>       [media] drivers/media/video/hexium_gemini.c: delete useless initialization
>       [media] drivers/media/video/zr364xx.c: add missing cleanup code
> 
> Julian Scheel (1):
>       [media] Add support for new revision of KNC 1 DVB-C cards. Using tda10024 instead of tda10023, which is compatible to tda10023 driver
> 
> Kamil Debski (1):
>       [media] media: s5p-mfc: fix section mismatch
> 
> Laurent Pinchart (7):
>       [media] omap3isp: Don't accept pipelines with no video source as valid
>       [media] omap3isp: Move platform data definitions from isp.h to media/omap3isp.h
>       [media] omap3isp: Don't fail streamon when the sensor doesn't implement s_stream
>       [media] omap3isp: video: Avoid crashes when pipeline set stream operation fails
>       [media] mt9t001: Aptina (Micron) MT9T001 3MP sensor driver
>       [media] uvcvideo: Remove deprecated UVCIOC ioctls
>       USB: export video.h to the includes available for userspace
> 
> Luiz Ramos (1):
>       [media] Fix wrong register mask in gspca/sonixj.c
> 
> Lutz Sammer (2):
>       [media] TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder
>       [media] stb0899: Fix slow and not locking DVB-S transponder(s)
> 
> Malcolm Priestley (4):
>       [media] it913x_fe: frontend and tuner driver v1.05
>       [media] it9137: Fimrware retrival information for Kworld UB499-2T T09 (id 1b80:e409)
>       [media] it913x: Driver for Kworld UB499-2T (id 1b80:e409) v1.05
>       [media] it913x-fe changes to power up and down of tuner
> 
> Manjunath Hadli (1):
>       [media] davinci vpbe: remove unused macro
> 
> Marek Szyprowski (8):
>       [media] MAINTAINERS: add entries for s5p-mfc and s5p-tv drivers
>       [media] media: vb2: add a check if queued userptr buffer is large enough
>       [media] media: vb2: fix handling MAPPED buffer flag
>       [media] media: vb2: change plane sizes array to unsigned int[]
>       [media] media: vb2: dma contig allocator: use dma_addr instread of paddr
>       [media] media: vb2: change queue initialization order
>       [media] staging: dt3155v4l: fix build break
>       [media] media: vb2: fix incorrect return value
> 
> Marko Ristola (1):
>       [media] Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt
> 
> Martin Hostettler (1):
>       [media] v4l subdev: add dispatching for VIDIOC_DBG_G_REGISTER and VIDIOC_DBG_S_REGISTER
> 
> Mats Randgaard (2):
>       [media] TVP7002: Return V4L2_DV_INVALID if any of the errors occur
>       [media] TVP7002: Changed register values
> 
> Mauro Carvalho Chehab (22):
>       [media] rc-main: Fix device de-registration logic
>       [media] em28xx: Fix IR unregister logic
>       v4l2-ioctl: properly return -EINVAL when parameters are wrong
>       [media] tuner_xc2028: Allow selection of the frequency adjustment code for XC3028
>       [media] tuner/xc2028: Fix frequency offset for radio mode
>       [media] tm6000: Don't try to use a non-existing interface
>       [media] dvb-core, tda18271c2dd: define get_if_frequency() callback
>       Merge tag 'v3.1-rc6' into staging/for_v3.2
>       [media] tm6000: Fix some CodingStyle issues
>       [media] move tm6000 to drivers/media/video
>       [media] rc tables: include linux/module.h
>       Revert "[media] siano: apply debug flag to module level"
>       [media] saa7115: Fix standards detection
>       [media] pvrusb2: implement VIDIOC_QUERYSTD
>       [media] v4l2-ioctl: Fill the default value for VIDIOC_QUERYSTD
>       [media] saa7115: Trust that V4L2 core will fill the mask
>       [media] pvrusb2: initialize standards mask before detecting standard
>       [media] videodev2: Reorganize standard macros and add a few more macros
>       [media] msp3400: Add standards detection to the driver
>       [media] em28xx: Add VIDIOC_QUERYSTD support
>       [media] cx23885: Don't use memset on vidioc_ callbacks
>       [media] em28xx: implement VIDIOC_ENUM_FRAMESIZES
> 
> Michael Grzeschik (1):
>       [media] mt9m111: move lastpage to struct mt9m111 for multi instances
> 
> Michael Jones (1):
>       [media] omap3isp: queue: fail QBUF if user buffer is too small
> 
> Michael Krufky (19):
>       [media] dvb-usb: add ATSC support for the Hauppauge WinTV-Aero-M
>       [media] dvb-usb: refactor MFE code for individual streaming config per frontend
>       [media] dvb-usb: fix streaming failure on channel change
>       [media] dvb-usb: improve sanity check of adap->active_fe in dvb_usb_ctrl_feed
>       [media] mxl111sf: use adap->num_frontends_initialized to determine which frontend is being attached
>       [media] dib0700: fix WARNING: please, no spaces at the start of a line
>       [media] dib0700: fix WARNING: suspect code indent for conditional statements
>       [media] dib0700: fix ERROR: space required before that '&'
>       [media] dib0700: fix ERROR: space required after that ','
>       [media] dibusb-common: fix ERROR: space required after that ','
>       [media] dibusb-mb: fix ERROR: space required after that ','
>       [media] ttusb2: fix ERROR: space required after that ','
>       [media] dvb-usb-dvb: ERROR: space required after that ','
>       [media] cxusb: fix ERROR: do not use assignment in if condition
>       [media] dibusb-common: fix ERROR: do not use assignment in if condition
>       [media] dibusb-mb: fix ERROR: do not use assignment in if condition
>       [media] digitv: fix ERROR: do not use assignment in if condition
>       [media] m920x: fix ERROR: do not use assignment in if condition
>       [media] opera1: fix ERROR: do not use assignment in if condition
> 
> Michael Olbrich (1):
>       [media] v4l: mem2mem: add wait_{prepare,finish} ops to m2m_testdev
> 
> Mijhail Moreyra (4):
>       [media] cx23885: Add ALSA support
>       [media] cx23885: add definitions for HVR1500 to support audio
>       [media] cx23885: correct the contrast, saturation and hue controls
>       [media] cx23885: hooks the alsa changes into the video subsystem
> 
> Ming Lei (1):
>       [media] uvcvideo: Set alternate setting 0 on resume if the bus has been reset
> 
> Olivier Grenie (2):
>       [media] dib0700: protect the dib0700 buffer access
>       [media] dib0700: correct error message
> 
> Patrick Boettcher (1):
>       [media] DiBcom: protect the I2C bufer access
> 
> Paul Gortmaker (1):
>       [media] drivers/media: fix dependencies in video mt9t001/mt9p031
> 
> Pekka Enberg (1):
>       [media] media, rc: Use static inline functions to kill warnings
> 
> Randy Dunlap (1):
>       [media] [-mmotm] media: video/adp1653.c needs module.h
> 
> Renzo Dani (1):
>       [media] update az6027 firmware URL
> 
> Sakari Ailus (3):
>       [media] v4l: Move event documentation from SUBSCRIBE_EVENT to DQEVENT
>       [media] v4l: events: Define V4L2_EVENT_FRAME_SYNC
>       [media] omap3isp: ccdc: Use generic frame sync event instead of private HS_VS event
> 
> Simon Farnsworth (1):
>       [media] cx18: Fix videobuf capture
> 
> Stephan Lachowsky (1):
>       [media] uvcvideo: Add a mapping for H.264 payloads
> 
> Steve Kerrison (1):
>       [media] CXD2820R: Replace i2c message translation with repeater gate control
> 
> Steven Toth (29):
>       [media] saa7164: Adding support for HVR2200 card id 0x8953
>       [media] cx23885: convert call clients into subdevices
>       [media] cx23885: minor function renaming to ensure uniformity
>       [media] cx23885: setup the dma mapping for raw audio support
>       [media] cx23885: add two additional defines to simplify VBI register bitmap handling
>       [media] cx23885: initial support for VBI with the cx23885
>       [media] cx23885: initialize VBI support in the core, add IRQ support, register vbi device
>       [media] cx23885: minor printk cleanups and device registration
>       [media] cx25840: enable raw cc processing only for the cx23885 hardware
>       [media] cx23885: vbi line window adjustments
>       [media] cx23885: add vbi buffer formatting, window changes and video core changes
>       [media] cx23885: Ensure the VBI pixel format is established correctly
>       [media] cx23885: ensure video is streaming before allowing vbi to stream
>       [media] cx23885: remove channel dump diagnostics when a vbi buffer times out
>       [media] cx23885: Ensure VBI buffers timeout quickly - bugfix for vbi hangs during streaming
>       [media] cx23885: Name an internal i2c part and declare a bitfield by name
>       [media] cx25840: Enable support for non-tuner LR1/LR2 audio inputs
>       [media] cx23885: Allow the audio mux config to be specified on a per input basis
>       [media] cx23885: Enable audio line in support from the back panel
>       [media] cx25840: Ensure AUDIO6 and AUDIO7 trigger line-in baseband use
>       [media] cx23885: Initial support for the MPX-885 mini-card
>       [media] cx23885: fixes related to maximum number of inputs and range checking
>       [media] cx23885: add generic functions for dealing with audio input selection
>       [media] cx23885: hook the audio selection functions into the main driver
>       [media] cx23885: v4l2 api compliance, set the audioset field correctly
>       [media] cx23885: Removed a spurious function cx23885_set_scale()
>       [media] cx23885: Avoid stopping the risc engine during buffer timeout
>       [media] cx23885: Avoid incorrect error handling and reporting
>       [media] cx23885: Stop the risc video fifo before reconfiguring it
> 
> Sylwester Nawrocki (31):
>       [media] s5p-fimc: Add runtime PM support in the mem-to-mem driver
>       [media] s5p-csis: Handle all available power supplies
>       [media] s5p-csis: Rework the system suspend/resume helpers
>       [media] s5p-fimc: Add media entity initialization
>       [media] s5p-fimc: Remove registration of video nodes from probe()
>       [media] s5p-fimc: Remove sclk_cam clock handling
>       [media] s5p-fimc: Limit number of available inputs to one
>       [media] s5p-fimc: Remove sensor management code from FIMC capture driver
>       [media] s5p-fimc: Remove v4l2_device from video capture and m2m driver
>       [media] s5p-fimc: Add the media device driver
>       [media] s5p-fimc: Conversion to use struct v4l2_fh
>       [media] s5p-fimc: Convert to the new control framework
>       [media] s5p-fimc: Add media operations in the capture entity driver
>       [media] s5p-fimc: Add PM helper function for streaming control
>       [media] s5p-fimc: Correct color format enumeration
>       [media] s5p-fimc: Convert to use media pipeline operations
>       [media] s5p-fimc: Add subdev for the FIMC processing block
>       [media] s5p-fimc: Add support for JPEG capture
>       [media] s5p-fimc: Add v4l2_device notification support for single frame capture
>       [media] s5p-fimc: Use consistent names for the buffer list functions
>       [media] s5p-fimc: Add runtime PM support in the camera capture driver
>       [media] s5p-fimc: Correct crop offset alignment on exynos4
>       [media] s5p-fimc: Remove single-planar capability flags
>       [media] sr030pc30: Remove empty s_stream op
>       [media] noon010pc30: Conversion to the media controller API
>       [media] noon010pc30: Improve s_power operation handling
>       [media] v4l: Move SR030PC30, NOON010PC30, M5MOLS drivers to the right location
>       [media] noon010pc30: Remove g_chip_ident operation handler
>       [media] v4l2: Add polarity flag definitions for the parallel bus FIELD signal
>       [media] s5p-fimc: Convert to use generic media bus polarity flags
>       [media] m5mols: Remove superfluous irq field from the platform data struct
> 
> Thierry Reding (18):
>       [media] tuner/xc2028: Add I2C flush callback
>       [media] tm6000: Miscellaneous cleanups
>       [media] tm6000: Use correct input in radio mode
>       [media] tm6000: Implement I2C flush callback
>       [media] tm6000: Flesh out the IRQ callback
>       [media] tm6000: Rename active interface register
>       [media] tm6000: Disable video interface in radio mode
>       [media] tm6000: Rework standard register tables
>       [media] tm6000: Add locking for USB transfers
>       [media] tm6000: Properly count device usage
>       [media] tm6000: Initialize isochronous transfers only once
>       [media] tm6000: Execute lightweight reset on close
>       [media] tm6000: Do not use video buffers in radio mode
>       [media] tm6000: Plug memory leak on PCM free
>       [media] tm6000: Enable audio clock in radio mode
>       [media] tm6000: Enable radio mode for Cinergy Hybrid XE
>       [media] tm6000: Add fast USB access quirk
>       [media] tm6000: Enable fast USB quirk on Cinergy Hybrid
> 
> Thomas Meyer (1):
>       [media] davinci vpbe: Use resource_size()
> 
> Tomasz Stanislawski (3):
>       [media] media: v4l: remove single to multiplane conversion
>       [media] s5p-tv: hdmi: use DVI mode
>       [media] s5p-tv: fix mbus configuration
> 
> Tony Jago (1):
>       [media] saa7164: Add support for another HVR2200 hardware revision
> 
> Wolfram Sang (1):
>       [media] gspca - zc3xx: New webcam 03f0:1b07 HP Premium Starter Cam
> 
> Yang Ruirui (1):
>       [media] v4l2: uvcvideo use after free bug fix
> 
> Yu Tang (1):
>       [media] media: vb2: fix userptr VMA release seq
> 
> istvan_v@mailbox.hu (1):
>       [media] cx88: notch filter control fixes
> 
> tvboxspy (5):
>       [media] STV0288 frontend provide wider carrier search and DVB-S2 drop out. resend
>       [media] [1/2,ver,1.89] DM04/QQBOX Interupt Urb and Timing changes
>       [media] [2/2,ver,1.90] DM04/QQBOX Reduce USB buffer size
>       [media] it913x: add remote control support
>       [media] it913x-fe: correct tuner settings
> 
>  Documentation/DocBook/media/dvb/dvbproperty.xml    |   24 +-
>  Documentation/DocBook/media/dvb/intro.xml          |    2 +-
>  Documentation/DocBook/media/v4l/compat.xml         |    8 +
>  Documentation/DocBook/media/v4l/dev-subdev.xml     |    2 +-
>  Documentation/DocBook/media/v4l/v4l2.xml           |    9 +-
>  Documentation/DocBook/media/v4l/vidioc-dqevent.xml |  129 +
>  .../DocBook/media/v4l/vidioc-queryctrl.xml         |    9 +
>  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |  123 +-
>  Documentation/dvb/get_dvb_firmware                 |   51 +-
>  Documentation/dvb/it9137.txt                       |    9 +
>  Documentation/feature-removal-schedule.txt         |   23 -
>  .../video4linux/CARDLIST.tm6000                    |    0
>  Documentation/video4linux/gspca.txt                |    4 +
>  Documentation/video4linux/omap3isp.txt             |    9 +-
>  Documentation/video4linux/v4l2-controls.txt        |   43 +-
>  MAINTAINERS                                        |   18 +
>  drivers/input/misc/Kconfig                         |   16 -
>  drivers/input/misc/Makefile                        |    1 -
>  drivers/media/common/saa7146_core.c                |   74 +-
>  drivers/media/common/saa7146_fops.c                |  118 +-
>  drivers/media/common/saa7146_hlp.c                 |   14 +-
>  drivers/media/common/saa7146_i2c.c                 |   60 +-
>  drivers/media/common/saa7146_vbi.c                 |   48 +-
>  drivers/media/common/saa7146_video.c               |  183 +-
>  drivers/media/common/tuners/Makefile               |    4 +-
>  drivers/media/common/tuners/mt20xx.c               |   24 +-
>  drivers/media/common/tuners/mxl5005s.c             |   22 +-
>  drivers/media/common/tuners/tda18212.c             |   31 +-
>  drivers/media/common/tuners/tda18271-common.c      |   32 +-
>  drivers/media/common/tuners/tda18271-fe.c          |    2 +-
>  drivers/media/common/tuners/tda18271-priv.h        |   39 +-
>  drivers/media/common/tuners/tda827x.c              |    8 +-
>  drivers/media/common/tuners/tuner-xc2028.c         |   18 +-
>  drivers/media/common/tuners/tuner-xc2028.h         |    1 +
>  drivers/media/dvb/b2c2/Makefile                    |    4 +-
>  drivers/media/dvb/bt8xx/Makefile                   |    8 +-
>  drivers/media/dvb/ddbridge/Makefile                |    8 +-
>  drivers/media/dvb/ddbridge/ddbridge-core.c         |   43 +-
>  drivers/media/dvb/dm1105/Makefile                  |    2 +-
>  drivers/media/dvb/dvb-core/dvb_frontend.c          |   95 +-
>  drivers/media/dvb/dvb-core/dvb_frontend.h          |    1 +
>  drivers/media/dvb/dvb-usb/Kconfig                  |   28 +
>  drivers/media/dvb/dvb-usb/Makefile                 |   15 +-
>  drivers/media/dvb/dvb-usb/a800.c                   |    4 +-
>  drivers/media/dvb/dvb-usb/af9005-fe.c              |    2 -
>  drivers/media/dvb/dvb-usb/af9005.c                 |    5 +-
>  drivers/media/dvb/dvb-usb/af9015.c                 |   70 +-
>  drivers/media/dvb/dvb-usb/anysee.c                 |  337 +-
>  drivers/media/dvb/dvb-usb/anysee.h                 |    1 +
>  drivers/media/dvb/dvb-usb/au6610.c                 |    9 +-
>  drivers/media/dvb/dvb-usb/az6027.c                 |   26 +-
>  drivers/media/dvb/dvb-usb/ce6230.c                 |    9 +-
>  drivers/media/dvb/dvb-usb/cinergyT2-core.c         |    5 +-
>  drivers/media/dvb/dvb-usb/cxusb.c                  |  142 +-
>  drivers/media/dvb/dvb-usb/dib0700_core.c           |   99 +-
>  drivers/media/dvb/dvb-usb/dib0700_devices.c        |  377 +-
>  drivers/media/dvb/dvb-usb/dibusb-common.c          |   27 +-
>  drivers/media/dvb/dvb-usb/dibusb-mb.c              |   31 +-
>  drivers/media/dvb/dvb-usb/dibusb-mc.c              |    3 +
>  drivers/media/dvb/dvb-usb/digitv.c                 |   16 +-
>  drivers/media/dvb/dvb-usb/dtt200u.c                |   14 +-
>  drivers/media/dvb/dvb-usb/dtv5100.c                |   11 +-
>  drivers/media/dvb/dvb-usb/dvb-usb-dvb.c            |  153 +-
>  drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    4 +
>  drivers/media/dvb/dvb-usb/dvb-usb-init.c           |   41 +-
>  drivers/media/dvb/dvb-usb/dvb-usb-urb.c            |   28 +-
>  drivers/media/dvb/dvb-usb/dvb-usb.h                |   37 +-
>  drivers/media/dvb/dvb-usb/dw2102.c                 |  115 +-
>  drivers/media/dvb/dvb-usb/ec168.c                  |    9 +-
>  drivers/media/dvb/dvb-usb/friio.c                  |    7 +-
>  drivers/media/dvb/dvb-usb/gl861.c                  |    9 +-
>  drivers/media/dvb/dvb-usb/gp8psk-fe.c              |   17 +-
>  drivers/media/dvb/dvb-usb/gp8psk.c                 |    5 +-
>  drivers/media/dvb/dvb-usb/it913x.c                 |  651 +++
>  drivers/media/dvb/dvb-usb/lmedm04.c                |   60 +-
>  drivers/media/dvb/dvb-usb/m920x.c                  |   58 +-
>  drivers/media/dvb/dvb-usb/mxl111sf-gpio.c          |  763 +++
>  drivers/media/dvb/dvb-usb/mxl111sf-gpio.h          |   56 +
>  drivers/media/dvb/dvb-usb/mxl111sf-i2c.c           |  851 ++++
>  drivers/media/dvb/dvb-usb/mxl111sf-i2c.h           |   35 +
>  drivers/media/dvb/dvb-usb/mxl111sf-phy.c           |  342 ++
>  drivers/media/dvb/dvb-usb/mxl111sf-phy.h           |   53 +
>  drivers/media/dvb/dvb-usb/mxl111sf-reg.h           |  179 +
>  drivers/media/dvb/dvb-usb/mxl111sf-tuner.c         |  476 ++
>  drivers/media/dvb/dvb-usb/mxl111sf-tuner.h         |   89 +
>  drivers/media/dvb/dvb-usb/mxl111sf.c               |  864 ++++
>  drivers/media/dvb/dvb-usb/mxl111sf.h               |  158 +
>  drivers/media/dvb/dvb-usb/nova-t-usb2.c            |    4 +-
>  drivers/media/dvb/dvb-usb/opera1.c                 |   13 +-
>  drivers/media/dvb/dvb-usb/pctv452e.c               | 1079 +++++
>  drivers/media/dvb/dvb-usb/technisat-usb2.c         |   28 +-
>  drivers/media/dvb/dvb-usb/ttusb2.c                 |  407 ++-
>  drivers/media/dvb/dvb-usb/umt-010.c                |    8 +-
>  drivers/media/dvb/dvb-usb/usb-urb.c                |    4 +-
>  drivers/media/dvb/dvb-usb/vp702x.c                 |    5 +-
>  drivers/media/dvb/dvb-usb/vp7045.c                 |    5 +-
>  drivers/media/dvb/frontends/Kconfig                |   30 +
>  drivers/media/dvb/frontends/Makefile               |    8 +-
>  drivers/media/dvb/frontends/a8293.c                |  184 +
>  .../tda18212_priv.h => dvb/frontends/a8293.h}      |   39 +-
>  drivers/media/dvb/frontends/cxd2820r.h             |    9 -
>  drivers/media/dvb/frontends/cxd2820r_c.c           |    1 -
>  drivers/media/dvb/frontends/cxd2820r_core.c        |   80 +-
>  drivers/media/dvb/frontends/cxd2820r_priv.h        |    1 -
>  drivers/media/dvb/frontends/cxd2820r_t.c           |    1 -
>  drivers/media/dvb/frontends/cxd2820r_t2.c          |    1 -
>  drivers/media/dvb/frontends/dib0070.c              |   37 +-
>  drivers/media/dvb/frontends/dib0090.c              |   70 +-
>  drivers/media/dvb/frontends/dib7000m.c             |   27 +-
>  drivers/media/dvb/frontends/dib7000p.c             |   34 +-
>  drivers/media/dvb/frontends/dib8000.c              |   72 +-
>  drivers/media/dvb/frontends/dib9000.c              |  167 +-
>  drivers/media/dvb/frontends/dibx000_common.c       |   76 +-
>  drivers/media/dvb/frontends/dibx000_common.h       |    1 +
>  drivers/media/dvb/frontends/drxd_hard.c            |   24 +-
>  drivers/media/dvb/frontends/drxk_hard.c            |   10 +-
>  drivers/media/dvb/frontends/it913x-fe-priv.h       |  336 ++
>  drivers/media/dvb/frontends/it913x-fe.c            |  839 ++++
>  drivers/media/dvb/frontends/it913x-fe.h            |  196 +
>  drivers/media/dvb/frontends/lnbp22.c               |  148 +
>  drivers/media/dvb/frontends/lnbp22.h               |   57 +
>  drivers/media/dvb/frontends/stb0899_algo.c         |    3 +
>  drivers/media/dvb/frontends/stb0899_drv.c          |    6 +-
>  drivers/media/dvb/frontends/stv0288.c              |   29 +-
>  drivers/media/dvb/frontends/stv090x.c              |   35 +-
>  drivers/media/dvb/frontends/tda10048.c             |   37 +-
>  drivers/media/dvb/frontends/tda10048.h             |    8 +
>  drivers/media/dvb/frontends/tda10071.c             | 1269 +++++
>  drivers/media/dvb/frontends/tda10071.h             |   81 +
>  drivers/media/dvb/frontends/tda10071_priv.h        |  122 +
>  drivers/media/dvb/frontends/tda18271c2dd.c         |    4 +-
>  drivers/media/dvb/mantis/Makefile                  |    2 +-
>  drivers/media/dvb/mantis/hopper_cards.c            |    6 +-
>  drivers/media/dvb/mantis/mantis_cards.c            |    6 +-
>  drivers/media/dvb/mantis/mantis_common.h           |    5 +-
>  drivers/media/dvb/mantis/mantis_dma.c              |   92 +-
>  drivers/media/dvb/mantis/mantis_vp1041.c           |    1 -
>  drivers/media/dvb/ngene/Makefile                   |    8 +-
>  drivers/media/dvb/pluto2/Makefile                  |    2 +-
>  drivers/media/dvb/pt1/Makefile                     |    2 +-
>  drivers/media/dvb/siano/Makefile                   |    4 +-
>  drivers/media/dvb/ttpci/Makefile                   |    4 +-
>  drivers/media/dvb/ttpci/av7110_v4l.c               |   32 +-
>  drivers/media/dvb/ttpci/budget-av.c                |   47 +-
>  drivers/media/dvb/ttpci/budget-ci.c                |    1 -
>  drivers/media/dvb/ttpci/budget-core.c              |    2 +
>  drivers/media/dvb/ttpci/budget.h                   |    1 +
>  drivers/media/dvb/ttpci/ttpci-eeprom.c             |   29 +
>  drivers/media/dvb/ttpci/ttpci-eeprom.h             |    1 +
>  drivers/media/dvb/ttusb-budget/Makefile            |    2 +-
>  drivers/media/dvb/ttusb-dec/Makefile               |    2 +-
>  drivers/media/radio/Makefile                       |    2 +-
>  drivers/media/radio/radio-si4713.c                 |    4 -
>  drivers/media/radio/radio-wl1273.c                 |    2 +-
>  drivers/media/radio/si470x/radio-si470x-usb.c      |    2 -
>  drivers/media/radio/wl128x/fmdrv_v4l2.c            |    6 +-
>  drivers/media/rc/Kconfig                           |   23 +-
>  drivers/media/rc/Makefile                          |    1 +
>  drivers/{input/misc => media/rc}/ati_remote.c      |  301 +-
>  drivers/media/rc/ene_ir.c                          |   73 +-
>  drivers/media/rc/ene_ir.h                          |   19 +-
>  drivers/media/rc/imon.c                            |   36 +-
>  drivers/media/rc/ir-lirc-codec.c                   |    9 +-
>  drivers/media/rc/keymaps/Makefile                  |    3 +
>  drivers/media/rc/keymaps/rc-ati-x10.c              |  104 +
>  drivers/media/rc/keymaps/rc-medion-x10.c           |  117 +
>  drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c     |    1 +
>  drivers/media/rc/keymaps/rc-snapstream-firefly.c   |  107 +
>  drivers/media/rc/mceusb.c                          |  410 ++-
>  drivers/media/rc/rc-core-priv.h                    |   14 +-
>  drivers/media/rc/rc-main.c                         |   29 +-
>  drivers/media/rc/redrat3.c                         |    7 -
>  drivers/media/rc/winbond-cir.c                     |    6 +-
>  drivers/media/video/Kconfig                        |   49 +-
>  drivers/media/video/Makefile                       |    9 +-
>  drivers/media/video/adp1653.c                      |   20 +-
>  drivers/media/video/adv7175.c                      |   62 +
>  drivers/media/video/atmel-isi.c                    |   24 +-
>  drivers/media/video/au0828/Makefile                |    8 +-
>  drivers/media/video/bt819.c                        |    2 +-
>  drivers/media/video/bt8xx/Makefile                 |    6 +-
>  drivers/media/video/bt8xx/bttv-cards.c             |  242 +-
>  drivers/media/video/bt8xx/bttv-driver.c            |  294 +-
>  drivers/media/video/bt8xx/bttv-gpio.c              |    4 +-
>  drivers/media/video/bt8xx/bttv-i2c.c               |   56 +-
>  drivers/media/video/bt8xx/bttv-input.c             |   37 +-
>  drivers/media/video/bt8xx/bttv-risc.c              |   25 +-
>  drivers/media/video/bt8xx/bttv-vbi.c               |    9 +-
>  drivers/media/video/bt8xx/bttvp.h                  |   18 +-
>  drivers/media/video/cx18/Makefile                  |    6 +-
>  drivers/media/video/cx18/cx18-driver.h             |    5 +-
>  drivers/media/video/cx18/cx18-fileops.c            |    2 -
>  drivers/media/video/cx18/cx18-ioctl.c              |   18 +-
>  drivers/media/video/cx18/cx18-mailbox.c            |    2 +-
>  drivers/media/video/cx18/cx18-streams.c            |   13 +
>  drivers/media/video/cx231xx/Makefile               |   10 +-
>  drivers/media/video/cx23885/Kconfig                |    2 +-
>  drivers/media/video/cx23885/Makefile               |   12 +-
>  drivers/media/video/cx23885/cx23885-alsa.c         |  535 +++
>  drivers/media/video/cx23885/cx23885-cards.c        |   55 +-
>  drivers/media/video/cx23885/cx23885-core.c         |   99 +-
>  drivers/media/video/cx23885/cx23885-dvb.c          |    2 +-
>  drivers/media/video/cx23885/cx23885-i2c.c          |    1 +
>  drivers/media/video/cx23885/cx23885-reg.h          |    3 +
>  drivers/media/video/cx23885/cx23885-vbi.c          |   72 +-
>  drivers/media/video/cx23885/cx23885-video.c        |  358 ++-
>  drivers/media/video/cx23885/cx23885.h              |   56 +
>  drivers/media/video/cx23885/cx23888-ir.c           |   12 +-
>  drivers/media/video/cx25840/Makefile               |    2 +-
>  drivers/media/video/cx25840/cx25840-audio.c        |   10 +-
>  drivers/media/video/cx25840/cx25840-core.c         |   19 +
>  drivers/media/video/cx25840/cx25840-ir.c           |   12 +-
>  drivers/media/video/cx88/Makefile                  |    8 +-
>  drivers/media/video/cx88/cx88-core.c               |    3 -
>  drivers/media/video/cx88/cx88-video.c              |    2 +-
>  drivers/media/video/davinci/vpbe_display.c         |    1 -
>  drivers/media/video/davinci/vpbe_osd.c             |    2 +-
>  drivers/media/video/em28xx/Kconfig                 |    2 +
>  drivers/media/video/em28xx/Makefile                |    8 +-
>  drivers/media/video/em28xx/em28xx-cards.c          |  155 +-
>  drivers/media/video/em28xx/em28xx-core.c           |   45 +-
>  drivers/media/video/em28xx/em28xx-dvb.c            |  117 +-
>  drivers/media/video/em28xx/em28xx-input.c          |    6 +-
>  drivers/media/video/em28xx/em28xx-video.c          |   58 +-
>  drivers/media/video/em28xx/em28xx.h                |    3 +-
>  drivers/media/video/et61x251/et61x251.h            |   66 +-
>  drivers/media/video/et61x251/et61x251_core.c       |    2 +
>  drivers/media/video/et61x251/et61x251_tas5130d1b.c |    2 +
>  drivers/media/video/gspca/Kconfig                  |   10 +
>  drivers/media/video/gspca/Makefile                 |    2 +
>  drivers/media/video/gspca/benq.c                   |   31 +-
>  drivers/media/video/gspca/conex.c                  |    6 +-
>  drivers/media/video/gspca/cpia1.c                  |    7 +-
>  drivers/media/video/gspca/etoms.c                  |    6 +-
>  drivers/media/video/gspca/finepix.c                |    8 +-
>  drivers/media/video/gspca/gl860/Makefile           |    2 +-
>  drivers/media/video/gspca/gl860/gl860.c            |    8 +-
>  drivers/media/video/gspca/gspca.c                  |  287 +-
>  drivers/media/video/gspca/gspca.h                  |   22 +-
>  drivers/media/video/gspca/jeilinj.c                |   20 +-
>  drivers/media/video/gspca/kinect.c                 |   41 +-
>  drivers/media/video/gspca/konica.c                 |   16 +-
>  drivers/media/video/gspca/m5602/Makefile           |    2 +-
>  drivers/media/video/gspca/m5602/m5602_core.c       |    9 +-
>  drivers/media/video/gspca/m5602/m5602_mt9m111.c    |   28 +-
>  drivers/media/video/gspca/m5602/m5602_ov7660.c     |   21 +-
>  drivers/media/video/gspca/m5602/m5602_ov9650.c     |   19 +-
>  drivers/media/video/gspca/m5602/m5602_po1030.c     |   21 +-
>  drivers/media/video/gspca/m5602/m5602_s5k4aa.c     |   35 +-
>  drivers/media/video/gspca/m5602/m5602_s5k83a.c     |   30 +-
>  drivers/media/video/gspca/mars.c                   |    6 +-
>  drivers/media/video/gspca/mr97310a.c               |   24 +-
>  drivers/media/video/gspca/nw80x.c                  |    9 +-
>  drivers/media/video/gspca/ov519.c                  |   41 +-
>  drivers/media/video/gspca/ov534.c                  |   12 +-
>  drivers/media/video/gspca/ov534_9.c                |  516 +--
>  drivers/media/video/gspca/pac207.c                 |   14 +-
>  drivers/media/video/gspca/pac7302.c                |   15 +-
>  drivers/media/video/gspca/pac7311.c                |   15 +-
>  drivers/media/video/gspca/se401.c                  |   46 +-
>  drivers/media/video/gspca/sn9c2028.c               |   14 +-
>  drivers/media/video/gspca/sn9c20x.c                |   76 +-
>  drivers/media/video/gspca/sonixj.c                 |   45 +-
>  drivers/media/video/gspca/spca1528.c               |   34 +-
>  drivers/media/video/gspca/spca500.c                |    6 +-
>  drivers/media/video/gspca/spca501.c                |    4 +-
>  drivers/media/video/gspca/spca505.c                |    8 +-
>  drivers/media/video/gspca/spca508.c                |    6 +-
>  drivers/media/video/gspca/spca561.c                |    4 +-
>  drivers/media/video/gspca/sq905.c                  |   17 +-
>  drivers/media/video/gspca/sq905c.c                 |   10 +-
>  drivers/media/video/gspca/sq930x.c                 |   21 +-
>  drivers/media/video/gspca/stk014.c                 |   16 +-
>  drivers/media/video/gspca/stv0680.c                |    6 +-
>  drivers/media/video/gspca/stv06xx/Makefile         |    2 +-
>  drivers/media/video/gspca/stv06xx/stv06xx.c        |   18 +-
>  drivers/media/video/gspca/stv06xx/stv06xx.h        |    6 +-
>  drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c   |   10 +-
>  drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c |    4 +-
>  drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |    4 +-
>  drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c |   32 +-
>  drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h |   56 +-
>  drivers/media/video/gspca/sunplus.c                |   10 +-
>  drivers/media/video/gspca/t613.c                   |   12 +-
>  drivers/media/video/gspca/topro.c                  | 4989 ++++++++++++++++++++
>  drivers/media/video/gspca/vc032x.c                 |   13 +-
>  drivers/media/video/gspca/vicam.c                  |   12 +-
>  drivers/media/video/gspca/w996Xcf.c                |    8 +-
>  drivers/media/video/gspca/xirlink_cit.c            |   14 +-
>  drivers/media/video/gspca/zc3xx.c                  |   15 +-
>  drivers/media/video/hdpvr/Makefile                 |    4 +-
>  drivers/media/video/hexium_gemini.c                |   44 +-
>  drivers/media/video/hexium_orion.c                 |   38 +-
>  drivers/media/video/ivtv/Makefile                  |    8 +-
>  drivers/media/video/ivtv/ivtv-ioctl.c              |   15 +-
>  drivers/media/video/m5mols/m5mols_core.c           |    6 +-
>  drivers/media/video/marvell-ccic/mcam-core.c       |   12 +-
>  drivers/media/video/marvell-ccic/mmp-driver.c      |    1 +
>  drivers/media/video/mem2mem_testdev.c              |   16 +-
>  drivers/media/video/msp3400-driver.c               |   20 +
>  drivers/media/video/msp3400-driver.h               |    2 +-
>  drivers/media/video/msp3400-kthreads.c             |   86 +-
>  drivers/media/video/mt9m111.c                      |    9 +-
>  drivers/media/video/mt9p031.c                      |  964 ++++
>  drivers/media/video/mt9t001.c                      |  836 ++++
>  drivers/media/video/mx3_camera.c                   |    4 +-
>  drivers/media/video/mxb.c                          |   80 +-
>  drivers/media/video/noon010pc30.c                  |  263 +-
>  drivers/media/video/omap3isp/Makefile              |    4 +-
>  drivers/media/video/omap3isp/isp.c                 |    6 +-
>  drivers/media/video/omap3isp/isp.h                 |   85 +-
>  drivers/media/video/omap3isp/ispccdc.c             |   11 +-
>  drivers/media/video/omap3isp/ispccp2.c             |    4 +-
>  drivers/media/video/omap3isp/ispqueue.c            |    4 +
>  drivers/media/video/omap3isp/ispvideo.c            |   22 +-
>  drivers/media/video/pvrusb2/Makefile               |    8 +-
>  drivers/media/video/pvrusb2/pvrusb2-hdw.c          |    7 +
>  drivers/media/video/pvrusb2/pvrusb2-hdw.h          |    3 +
>  drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    8 +
>  drivers/media/video/pwc/pwc-if.c                   |    4 +-
>  drivers/media/video/pwc/pwc-v4l.c                  |  136 +-
>  drivers/media/video/s5p-fimc/Makefile              |    2 +-
>  drivers/media/video/s5p-fimc/fimc-capture.c        | 1462 ++++--
>  drivers/media/video/s5p-fimc/fimc-core.c           | 1134 +++---
>  drivers/media/video/s5p-fimc/fimc-core.h           |  221 +-
>  drivers/media/video/s5p-fimc/fimc-mdevice.c        |  858 ++++
>  drivers/media/video/s5p-fimc/fimc-mdevice.h        |  118 +
>  drivers/media/video/s5p-fimc/fimc-reg.c            |   90 +-
>  drivers/media/video/s5p-fimc/mipi-csis.c           |   90 +-
>  drivers/media/video/s5p-fimc/regs-fimc.h           |    9 +-
>  drivers/media/video/s5p-mfc/s5p_mfc.c              |   15 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c          |   18 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c          |   36 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.c          |   14 +-
>  drivers/media/video/s5p-tv/Kconfig                 |    2 +-
>  drivers/media/video/s5p-tv/hdmi_drv.c              |   15 +-
>  drivers/media/video/s5p-tv/mixer.h                 |    2 -
>  drivers/media/video/s5p-tv/mixer_grp_layer.c       |    2 +-
>  drivers/media/video/s5p-tv/mixer_reg.c             |   11 +-
>  drivers/media/video/s5p-tv/mixer_video.c           |   24 +-
>  drivers/media/video/s5p-tv/mixer_vp_layer.c        |    4 +-
>  drivers/media/video/s5p-tv/regs-hdmi.h             |    4 +
>  drivers/media/video/s5p-tv/regs-mixer.h            |    1 +
>  drivers/media/video/s5p-tv/sdo_drv.c               |    1 +
>  drivers/media/video/saa7115.c                      |   53 +-
>  drivers/media/video/saa7134/Makefile               |    8 +-
>  drivers/media/video/saa7164/Makefile               |   10 +-
>  drivers/media/video/saa7164/saa7164-cards.c        |  128 +
>  drivers/media/video/saa7164/saa7164-dvb.c          |    2 +
>  drivers/media/video/saa7164/saa7164.h              |    2 +
>  drivers/media/video/sh_mobile_ceu_camera.c         |    6 +-
>  drivers/media/video/sr030pc30.c                    |    6 -
>  drivers/media/video/stk-webcam.c                   |   29 +-
>  drivers/media/video/tlg2300/Makefile               |    8 +-
>  drivers/{staging => media/video}/tm6000/Kconfig    |    0
>  drivers/{staging => media/video}/tm6000/Makefile   |    0
>  .../{staging => media/video}/tm6000/tm6000-alsa.c  |    9 +-
>  .../{staging => media/video}/tm6000/tm6000-cards.c |   44 +-
>  .../{staging => media/video}/tm6000/tm6000-core.c  |  108 +-
>  .../{staging => media/video}/tm6000/tm6000-dvb.c   |   18 +-
>  .../{staging => media/video}/tm6000/tm6000-i2c.c   |   21 +-
>  .../{staging => media/video}/tm6000/tm6000-input.c |    2 +-
>  .../{staging => media/video}/tm6000/tm6000-regs.h  |    6 +-
>  drivers/media/video/tm6000/tm6000-stds.c           |  659 +++
>  .../video}/tm6000/tm6000-usb-isoc.h                |    2 +-
>  .../{staging => media/video}/tm6000/tm6000-video.c |  122 +-
>  drivers/{staging => media/video}/tm6000/tm6000.h   |   15 +-
>  drivers/media/video/tvaudio.c                      |    9 +-
>  drivers/media/video/tvp5150_reg.h                  |   17 +-
>  drivers/media/video/tvp7002.c                      |   14 +-
>  drivers/media/video/usbvision/Makefile             |    4 +-
>  drivers/media/video/uvc/uvc_driver.c               |   15 +-
>  drivers/media/video/uvc/uvc_v4l2.c                 |   54 +-
>  drivers/media/video/uvc/uvc_video.c                |   27 +-
>  drivers/media/video/uvc/uvcvideo.h                 |  106 +-
>  drivers/media/video/v4l2-ctrls.c                   |  104 +-
>  drivers/media/video/v4l2-device.c                  |    2 +
>  drivers/media/video/v4l2-ioctl.c                   |  525 +--
>  drivers/media/video/v4l2-mem2mem.c                 |   18 +-
>  drivers/media/video/v4l2-subdev.c                  |   19 +
>  drivers/media/video/videobuf2-core.c               |  205 +-
>  drivers/media/video/videobuf2-dma-contig.c         |   16 +-
>  drivers/media/video/videobuf2-dma-sg.c             |    6 -
>  drivers/media/video/videobuf2-memops.c             |    6 +-
>  drivers/media/video/vivi.c                         |   23 +-
>  drivers/media/video/vpx3220.c                      |    2 +-
>  drivers/media/video/zr364xx.c                      |    3 +
>  drivers/misc/Kconfig                               |    1 +
>  drivers/misc/Makefile                              |    1 +
>  drivers/{staging => misc}/altera-stapl/Kconfig     |    2 +
>  drivers/misc/altera-stapl/Makefile                 |    3 +
>  .../{staging => misc}/altera-stapl/altera-comp.c   |    0
>  .../{staging => misc}/altera-stapl/altera-exprt.h  |    0
>  .../{staging => misc}/altera-stapl/altera-jtag.c   |    2 +-
>  .../{staging => misc}/altera-stapl/altera-jtag.h   |    0
>  .../{staging => misc}/altera-stapl/altera-lpt.c    |    0
>  drivers/{staging => misc}/altera-stapl/altera.c    |    2 +-
>  drivers/staging/Kconfig                            |    4 -
>  drivers/staging/Makefile                           |    2 -
>  drivers/staging/altera-stapl/Makefile              |    3 -
>  drivers/staging/dt3155v4l/dt3155v4l.c              |    4 +-
>  drivers/staging/tm6000/README                      |   22 -
>  drivers/staging/tm6000/TODO                        |    8 -
>  drivers/staging/tm6000/tm6000-stds.c               |  679 ---
>  include/linux/dvb/frontend.h                       |    1 +
>  include/linux/dvb/version.h                        |    2 +-
>  include/linux/omap3isp.h                           |    2 -
>  include/linux/usb/Kbuild                           |    1 +
>  include/linux/videodev2.h                          |   92 +-
>  include/media/m5mols.h                             |    4 +-
>  include/media/mt9p031.h                            |   19 +
>  include/media/mt9t001.h                            |    8 +
>  include/media/omap3isp.h                           |  140 +
>  include/media/rc-core.h                            |    7 +-
>  include/media/rc-map.h                             |    3 +
>  include/media/s5p_fimc.h                           |   18 +-
>  include/media/saa7146.h                            |   36 +-
>  include/media/v4l2-chip-ident.h                    |    3 -
>  include/media/v4l2-ctrls.h                         |   15 +-
>  include/media/v4l2-mediabus.h                      |   12 +-
>  include/media/videobuf2-core.h                     |   23 +-
>  include/media/videobuf2-dma-contig.h               |    6 +-
>  .../staging/altera-stapl => include/misc}/altera.h |    0
>  423 files changed, 27949 insertions(+), 6634 deletions(-)
>  create mode 100644 Documentation/dvb/it9137.txt
>  rename drivers/staging/tm6000/CARDLIST => Documentation/video4linux/CARDLIST.tm6000 (100%)
>  create mode 100644 drivers/media/dvb/dvb-usb/it913x.c
>  create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-gpio.c
>  create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-gpio.h
>  create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-i2c.c
>  create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-i2c.h
>  create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-phy.c
>  create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-phy.h
>  create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-reg.h
>  create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
>  create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-tuner.h
>  create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf.c
>  create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf.h
>  create mode 100644 drivers/media/dvb/dvb-usb/pctv452e.c
>  create mode 100644 drivers/media/dvb/frontends/a8293.c
>  rename drivers/media/{common/tuners/tda18212_priv.h => dvb/frontends/a8293.h} (58%)
>  create mode 100644 drivers/media/dvb/frontends/it913x-fe-priv.h
>  create mode 100644 drivers/media/dvb/frontends/it913x-fe.c
>  create mode 100644 drivers/media/dvb/frontends/it913x-fe.h
>  create mode 100644 drivers/media/dvb/frontends/lnbp22.c
>  create mode 100644 drivers/media/dvb/frontends/lnbp22.h
>  create mode 100644 drivers/media/dvb/frontends/tda10071.c
>  create mode 100644 drivers/media/dvb/frontends/tda10071.h
>  create mode 100644 drivers/media/dvb/frontends/tda10071_priv.h
>  rename drivers/{input/misc => media/rc}/ati_remote.c (77%)
>  create mode 100644 drivers/media/rc/keymaps/rc-ati-x10.c
>  create mode 100644 drivers/media/rc/keymaps/rc-medion-x10.c
>  create mode 100644 drivers/media/rc/keymaps/rc-snapstream-firefly.c
>  create mode 100644 drivers/media/video/cx23885/cx23885-alsa.c
>  create mode 100644 drivers/media/video/gspca/topro.c
>  create mode 100644 drivers/media/video/mt9p031.c
>  create mode 100644 drivers/media/video/mt9t001.c
>  create mode 100644 drivers/media/video/s5p-fimc/fimc-mdevice.c
>  create mode 100644 drivers/media/video/s5p-fimc/fimc-mdevice.h
>  rename drivers/{staging => media/video}/tm6000/Kconfig (100%)
>  rename drivers/{staging => media/video}/tm6000/Makefile (100%)
>  rename drivers/{staging => media/video}/tm6000/tm6000-alsa.c (97%)
>  rename drivers/{staging => media/video}/tm6000/tm6000-cards.c (97%)
>  rename drivers/{staging => media/video}/tm6000/tm6000-core.c (91%)
>  rename drivers/{staging => media/video}/tm6000/tm6000-dvb.c (95%)
>  rename drivers/{staging => media/video}/tm6000/tm6000-i2c.c (95%)
>  rename drivers/{staging => media/video}/tm6000/tm6000-input.c (99%)
>  rename drivers/{staging => media/video}/tm6000/tm6000-regs.h (99%)
>  create mode 100644 drivers/media/video/tm6000/tm6000-stds.c
>  rename drivers/{staging => media/video}/tm6000/tm6000-usb-isoc.h (97%)
>  rename drivers/{staging => media/video}/tm6000/tm6000-video.c (96%)
>  rename drivers/{staging => media/video}/tm6000/tm6000.h (98%)
>  rename drivers/{staging => misc}/altera-stapl/Kconfig (77%)
>  create mode 100644 drivers/misc/altera-stapl/Makefile
>  rename drivers/{staging => misc}/altera-stapl/altera-comp.c (100%)
>  rename drivers/{staging => misc}/altera-stapl/altera-exprt.h (100%)
>  rename drivers/{staging => misc}/altera-stapl/altera-jtag.c (99%)
>  rename drivers/{staging => misc}/altera-stapl/altera-jtag.h (100%)
>  rename drivers/{staging => misc}/altera-stapl/altera-lpt.c (100%)
>  rename drivers/{staging => misc}/altera-stapl/altera.c (99%)
>  delete mode 100644 drivers/staging/altera-stapl/Makefile
>  delete mode 100644 drivers/staging/tm6000/README
>  delete mode 100644 drivers/staging/tm6000/TODO
>  delete mode 100644 drivers/staging/tm6000/tm6000-stds.c
>  create mode 100644 include/media/mt9p031.h
>  create mode 100644 include/media/mt9t001.h
>  create mode 100644 include/media/omap3isp.h
>  rename {drivers/staging/altera-stapl => include/misc}/altera.h (100%)
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQIcBAEBAgAGBQJOrpdhAAoJEGO08Bl/PELnVK8QAKdWs2IeXNZrjYxcPxIDnQrJ
> mSe4A9M60PhhlLre53tonFlZZ705cUDLcBPzFIugyFHKCQWOLZFXux325UlWtMLY
> N/+tjrwKCh9vJnafIgMpsISdyIwG1hjL4Wq6kyZs7xrQFT/l57GrIEWf8Y+QXxxj
> wd4Tn5R270QF3bO6YzltocvxzLqQ3XZVvIqvAgZimxhVjKTRaOBOCb6ckPuXlp8t
> ReByHPaBHFEGKxNSIzFIaT26BevouNJoEQ3ReRZD+eLJ83QZ5daF8ZAT4n2tCZMU
> qg7VS+4h7m8gqccstSvqzrNqbVDeAQlJ8+pSG6OwkTG8DHHbWybRxhqzRWUPHd8s
> bVVfjxxYYY0TWole/dattYYzuXi/NO8g3Ag7OKATLS3C19oyeUSyE8DoCVhbchX1
> rCHdwcOaKR5zsKyUbo63KXEO4+OUynkO9fVTsbiWmcM/bhBXeuHolNIUngeG6eKm
> 8fICEdrPyw/AkBNzH7Dc1kwGU/d0rZViweOOhSzA659z188Z/mhGMN+jauv58t1v
> hesR51DS+jL3JqXMGeuAtJj2oDV7PeljmI917Y6YzFTzhBjou5X8cPEvgLCb7W2n
> WPU1SIbonieyYlEbENsJFGntowO7ntZp+SHXomfjz0PM/Rcg5G+XWFq8YnduYGSl
> yQ/8nRfRJAJ+rCMpGE+Z
> =HJl5
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

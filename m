Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032726Ab2CST4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:56:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48876 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032756Ab2CST4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:56:01 -0400
Date: Mon, 19 Mar 2012 12:55:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] big staging merge for 3.4-rc1
Message-ID: <20120319195557.GC9883@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b05ee6bf9e6c7acc38dca1466b63bb24ae5df6f3:

  Merge tag 'staging-3.3-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging (2012-02-09 13:52:18 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.3

for you to fetch changes up to bc01caf53da4de53361376734707336de8fff839:

  staging/zmem: Use lockdep_assert_held instead of spin_is_locked (2012-03-16 14:47:41 -0700)

----------------------------------------------------------------
staging driver merge for 3.4-rc1

Here is the big drivers/staging/ merge for 3.4-rc1

Lots of new driver updates here, with the addition of a few new ones, and only
one moving out of the staging tree to the "real" part of the kernel (the hyperv
scsi driver, acked by the scsi maintainer).

There are also loads of cleanups, fixes, and other minor things in here, all
self-contained in the drivers/staging/ tree.

Overall we reversed the recent trend by adding more lines than we removed:
 379 files changed, 37952 insertions(+), 14153 deletions(-)

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (2):
      staging: sep: Fix warnings caused by sizeof() types
      staging: Fix SEP build

Alexandru Guduleasa (1):
      staging/comedi/drivers fix spelling errors

Andi Kleen (1):
      staging/zmem: Use lockdep_assert_held instead of spin_is_locked

Andrea Righi (1):
      staging: zcache: avoid AB-BA deadlock condition

Andrew Miller (13):
      Staging: media: lirc: lirc_sasem.c: fixed long line coding style issue
      Staging: rtl8187se: r8180_core.c: Cleaned up if statement
      Staging: rtl8187se: r8180_core.c: Removed trailing spaces
      Staging: rtl8187se: r8180_core.c: Fix some spacing issues
      Staging: rtl8187se: r8180_core.c: Fix some long line issues
      Staging: rtl8187se: r8180_dm.c: Removed spaces before tab stop
      Staging: rtl8187se: r8180_dm.c: Fix brackets
      Staging: rtl8187se: r8180_dm.c Fixed indentation issues
      Staging: rtl8187se: r8180_dm.c: Fix spacing issues
      Staging: rtl8187se: r8180_dm.c: Fix comments
      Staging: rtl8187se: r8180_dm.c: Removed old comments
      Staging: rtl8187se: r8180_wx.c: Removed old comments
      Staging: rtl8187se: r8180_wx.c: Cleaned up comments

Andy Green (1):
      staging: android-alarm: Add needed module.h includes

Andy Gross (3):
      staging: drm/omap: Disable DMM debugfs for OMAP3
      staging: drm/omap: Validate debugfs device
      staging: drm/omap: Get DMM resources from hwmod

Anton Vorontsov (4):
      staging: android/lowmemorykiller: Don't grab tasklist_lock
      staging: android/lowmemorykiller: Better mm handling
      staging: android/lowmemorykiller: No need for task->signal check
      staging: android/lowmemorykiller: Do not kill kernel threads

Arve Hjønnevåg (4):
      staging: android-alarm: Add android alarm driver & in-kernel alarm interface
      staging: android-alarm: Don't use save_time_delta.
      staging: android-alarm: Update hrtimer if alarm at the head of the queue is reprogrammed
      Staging: android: binder: Fix use-after-free bug

Axel Lin (1):
      staging:iio:dac: Fix kcalloc parameters swapped

Bart Westgeest (3):
      staging: usbip: removed unused structure field
      staging: usbip: changed function return type to void
      staging: usbip: removed #if 0'd out code

Chris Ball (1):
      staging: Update TODO for rts5139 and rts_pstor

Chris Kelly (12):
      staging: ozwpan: Added driver entry code
      staging: ozwpan: Added basic L2 protocol support
      staging: ozwpan: Added device state support
      staging: ozwpan: Added USB HCD implementation
      staging: ozwpan: Added USB service to protocol
      staging: ozwpan: Added character device support
      staging: ozwpan: Added event logging support
      staging: ozwpan: Added debug support
      staging: ozwpan: Plumbed in Kconfig and Kbuild
      staging: ozwpan: Reduced size of oz_evtlist structure.
      staging: ozwpan: added TODO file.
      staging: ozwpan: added maintainer for ozwpan driver

Colin Cross (9):
      staging: android: ram_console: move footer strings
      staging: android: ram_console: drop early buffer support
      staging: android: ram_console: drop verbose ram_console support
      staging: android: ram_console: split out persistent ram
      staging: android: persistent_ram: refactor ecc support
      staging: android: persistent_ram: handle reserving and mapping memory
      staging: android: persistent_ram: make persistent_ram_write atomic
      staging: android: persistent_ram: add notrace to persistent_ram_write
      staging: android: ram_console: fix crash in ram_console_late_init

Dan Carpenter (7):
      staging: precedence bug in crystalhd_stop_tx_dma_engine()
      Staging: sbe-2t3e3: logical || vs bitwise |
      Staging: wlan-ng: cap the ssid length
      Staging: comedi: logical || vs bitwise |
      Staging: wlan-ng: memsetting the wrong amount of data
      Staging: wlan-ng: still setting wrong data
      Staging: ozwpan: prevent bogus dereference

Dan Magenheimer (14):
      staging: ramster: cluster/messaging foundation
      staging: ramster: local compression + tmem
      staging: ramster: ramster-specific changes to cluster code
      staging: ramster: ramster-specific changes to zcache/tmem
      staging: ramster: ramster-specific new files
      staging: ramster: enable as staging driver
      staging: ramster: enable as staging driver
      staging: ramster: cluster/messaging foundation
      staging: ramster: local compression + tmem
      staging: ramster: xvmalloc allocation files
      staging: ramster: ramster-specific changes to zcache/tmem
      staging: ramster: ramster-specific new files
      staging: ramster: build ramster properly when CONFIG_OCFS2=m|y
      staging: ramster: Dont build ramster when CONFIGFS_FS=m

Danny Kukawka (2):
      Staging: sm7xx/smtcfb.c included linux/module.h twice
      Staging: et131x: unify return value of .ndo_set_mac_address if address is invalid

David Daney (1):
      staging/octeon: Fix PHY binding in octeon-ethernet driver.

David Rientjes (1):
      staging: android, lowmemorykiller: convert to use oom_score_adj

Devin J. Pohly (1):
      staging: mei: fix typo in error code return

Dima Zavin (1):
      staging: android: ram_console: set CON_ANYTIME console flag

Gerard Ryan (1):
      Staging: bcm: fix CodingStyle warnings/errors reported by checkpatch.pl in led_control.h

Gerard Snitselaar (1):
      staging: vme: fix section mismatches in linux-next 20120314

Grant Grundler (1):
      staging:iio:tsl2563 rewrite probe error handling

Greg Dietsche (1):
      staging: android: ram_console use kmemdup instead of kmalloc

Greg Kroah-Hartman (8):
      staging: ramster: delete the driver
      Merge tag 'staging-3.3-rc3' into staging-next
      staging: clean up Greg's email address in some TODO files
      Staging: ramster: mark BROKEN
      Merge branch 'work-next' into staging-next
      staging: ozwpan: remove debug allocator
      Staging: android: lowmemorykiller.c
      Staging: android: ram_console.c:

Hitoshi NAKAMORI (1):
      Staging: frontier: Fix checkpatch.pl issue.

Ian Abbott (8):
      staging: comedi: ni_pcimio: Add support for NI PXIe-6251
      staging: comedi: dt2801: do INSN_CONFIG properly for DIO subdevice.
      staging: comedi: me4000: Check for unsupported INSN_CONFIG.
      staging: comedi: adv_pci_dio: Advantech PCI-1739U support
      staging: comedi: ni_pcidio: Mark buffer for writing when setting up DMA.
      staging: comedi: ni_pcidio: Grab MITE spinlock while preparing DMA.
      staging: comedi: ni_pcidio: Add comedi_poll support
      staging: comedi: ni_pcidio: Support trailing edge external trigger

JP Abgrall (1):
      staging: android-alarm: Fix bad index when canceling alarms[]

Jesper Juhl (4):
      staging, vt6656/wpactl.c: A basic style cleanup
      staging, vt6656/wpactl.c: Fix mem leak in wpa_ioctl()
      staging, media, easycap: Fix mem leak in easycap_usb_probe()
      Staging, rtl8192e, softmac: remove redundant memset and fix mem leak

Joe Perches (2):
      telephony: Move to staging
      staging: tidspbridge: Rename module from bridgedriver to tidspbridge

Johannes Thumshirn (1):
      Staging: android: timed_gpio: Removed spaces before tabs

John Stultz (6):
      staging: android-alarm: Fix include compile issues
      staging: android-alarm: Fix namespace collision with upstreamed alarmtimers
      staging: android-alarm: HACK: wakelock workaround
      staging: android-alarm: Reenable android alarm driver
      staging: android-alarm: Fixup minor pr_alarm warnings
      staging: android-alarm: Support old drivers via preprocessor aliasing

Jonathan Cameron (10):
      staging:iio:adc:ad7192 unwind use of is_visible for attribute group.
      staging:iio:dds:ad9834 unwind use of is_visible for attrs.
      staging:iio:dac:ad5446 unwind use of is_visible for attrs.
      staging:iio:adc:ad7606 unwind use of is_visible for attrs.
      staging:iio:adc:adt7310/7410 sticking plaster fix for broken event attrs.
      staging:iio:core set the iio_dev.info pointer to null on unregister under lock.
      staging:iio:core add in kernel interface mapping and getting IIO channels.
      staging:iio: move iio data return types into types.h for use by inkern
      staging:iio::hwmon interface client driver.
      staging:iio:Documentation in kernel pull description.

Jorgyano Vieira (6):
      Staging: crystalhd: crystalhd_misc: improved debug macros
      Staging: crystalhd: crystalhd_misc: Get rid of unused macro
      Staging: crystalhd: Get rid of unecessary BCMLOG_ENTER macro
      Staging: crystalhd: Add global header
      Staging: crystalhd: Replace the local includes with global header
      Staging: crystalhd: Remove unused header bc_dts_types.h

Josenivaldo Benito Jr (2):
      Staging: sm7xx: smtcfb.c: fixed a pointer declaration coding style
      Staging: sm7xx: smtcfb.h: fix sparse error

Julia Lawall (1):
      drivers/staging: adjust double test

Julian Andres Klode (3):
      staging: nvec: Fix typo s/I2C_SL_NEWL/I2C_SL_NEWSL/
      staging: nvec: Use gpio_request_one() instead of gpio_request()
      staging: nvec: Fix Kconfig dependencies

Justin P. Mattock (4):
      drivers:staging:android Typos: fix some comments that have typos in them.
      drivers:staging:et131x Fix some typo's in staging et131x.
      drivers:staging:iio Fix typos and comments in staging iio.
      drivers:staging:mei Fix some typos in staging/mei

K. Y. Srinivasan (16):
      Staging: hv: storvsc: Cleanup some comments
      Staging: hv: storvsc: Cleanup storvsc_probe()
      Staging: hv: storvsc: Cleanup storvsc_queuecommand()
      Staging: hv: storvsc: Introduce defines for srb status codes
      Staging: hv: storvsc: Cleanup storvsc_host_reset_handler()
      Staging: hv: storvsc: Move and cleanup storvsc_remove()
      Staging: hv: storvsc: Add a comment to explain life-cycle management
      Staging: hv: storvsc: Get rid of the on_io_completion in hv_storvsc_request
      Staging: hv: storvsc: Rename the context field in hv_storvsc_request
      Staging: hv: storvsc: Miscellaneous cleanup of storvsc driver
      Staging: hv: storvsc: Cleanup the code for generating protocol version
      Staging: hv: storvsc: Cleanup some protocol related constants
      Staging: hv: storvsc: Get rid of some unused defines
      Staging: hv: storvsc: Consolidate the request structure
      Staging: hv: storvsc: Consolidate all the wire protocol definitions
      Staging: hv: storvsc: Move the storage driver out of the staging area

Kashyap Gada (1):
      Staging: ft1000: ft1000-pcmia: fix space required after that ', ' in ft1000_proc.c

Kevin McKinney (10):
      Staging: bcm: Fix an integer overflow in IOCTL_BCM_NVM_READ/WRITE
      Staging: bcm: Fix coding style issues in CmHost.c
      Staging: bcm: Replace dated variable __FUNCTION__.
      Staging: bcm: Remove typedef from CmHost.c and use enum.
      Staging: bcm: Remove assignment from if statement and reverse if logic for readability.
      Staging: bcm: Replace variables and function outputs defined as INT with int.
      Staging: bcm: Alter name, datatype, and default value of iterator variables.
      Staging: bcm: Move directives for the preprocessor statement to enum value in led_control.h
      Staging: bcm: fix possible NULL dereference of psfLocalSet in CmHost.c
      Staging: bcm: fix possible memory leak of 'pstAddIndication' in CmHost.c and removes a whitespace

Larry Finger (6):
      staging: r8712u: Simplify semaphores
      staging: r8712u: Add missing initialization and remove configuration parameter CONFIG_R8712_AP
      staging: r8712u: Fix regression introduced by commit a5ee652
      staging: r8712u: Fix regression caused by commit 8c213fa
      staging: r8712u: Fix regression in signal level after commit c6dc001
      staging: r8712u: Fix Smatch warning

Lars-Peter Clausen (21):
      staging:iio: Setup buffer access functions when allocating the buffer
      staging:iio: Update iio_event_interface documentation
      staging:iio: Factor out event handling into its own file
      staging:iio:events: Use kfifo for event queue
      staging:iio:events: Use waitqueue lock to protect event queue
      staging:iio:events: Add poll support
      staging:iio:events: Use non-atmoic bitops
      staging:iio:events: Remove obsolete documentation
      staging:iio: Rename IIO_EVENT_CODE_EXTRACT_NUM to IIO_EVENT_CODE_EXTRACT_CHAN
      staging:iio: Add missing event code extract macros
      staging:iio: Add event monitor example application
      staging:iio: Use dev_pm_ops
      staging:iio: Convert remaining drivers to module_spi_driver
      staging:iio: Add extended IIO channel info
      staging:iio:dac:ad5064: Convert to extended channel info attributes
      staging:iio:dac:ad5064: Prepare driver for the addition of chip variants
      staging:iio:dac:ad5064: Add AD5025/AD5045/AD5065 support
      staging:iio:dac:ad5064: Add AD5628/AD5648/AD5668 support
      staging:iio:dac:ad5064: Add AD5666 support
      staging:iio: Remove declaration for non existing function
      staging:iio: Fix compile error without CONFIG_DEBUG_FS

Marc Dietrich (6):
      staging: nvec: ps2: add suspend/resume functions
      staging: nvec: ps2: let the start/stop streaming commands be called by the start/stop functions of serio
      staging: nvec: ps2: tell nvec to send 6 byte long messages
      staging: nvec: ps2: add some more debug functions
      staging: nvec: ps2: disable/enable mouse on suspend/resume
      staging: nvec: ps2: change serio type to passthrough

Marcos Paulo de Souza (7):
      staging: vt6656: iwctl.c: Remove commented code
      staging: vt6656: iwctl.c: Remove useless function
      staging: vt6656: Remove return statement of iwctl_giwmode
      staging: vt6656: Remove return statement of iwctl_giwrange
      staging: vt6656: iwctl.c: Remove return statement of iwctl_giwessid
      staging: vt6656: iwctl.c: Remove return statement of iwctl_giwrate
      staging: vt6656: iwctl.c: Rewrite siwrts funciton

Mark A. Allyn (6):
      staging: sep: Add new PCI identifier
      staging: sep: Basic infrastructure for SEP DMA access to non CPU regions
      staging: sep: Add interfaces for the new functions
      staging: sep: update initialisation
      staging: sep: NULL out pointers, mark debug code DEBUG to fix warnings
      staging: sep: reworked crypto layer

Mark Allyn (1):
      staging: sep: SEP update

Mark Einon (1):
      staging: et131x: use netif_rx_ni() for packet receive

Markus Grabner (3):
      staging: line6: removed obsolete code
      staging: line6: use source select control for UX2 devices
      staging: line6: separate handling of buffer allocation and stream startup

Martin Krause (2):
      Staging rtl8712: Remove double USB device IDs
      Staging: rtl8712/rtl8192u: move USB device ID within staging drivers.

Masanari Iida (5):
      staging: Fix typo in mei/interrupt.c
      staging: Fix typo in ieee80211_rx.c
      staging: Fix typo in bssdb.c
      staging: Fix typo in unioxx5.c
      staging: crystalhd: Fix typo in crystalhd_hw.c

Michael Hennerich (4):
      iio: core: constitfy available_scan_mask
      staging: iio: core: Introduce debugfs support, add support for direct register access
      staging: iio: core: Avoid NULL pointer de-ref in case indio_dev->setup_ops are not in use
      staging: iio: Convert platform_drivers to use module_platform_driver

Márton Németh (1):
      staging: rts5139: fix pointer coding style

Nick Kralevich (1):
      staging: android: ram_console: honor dmesg_restrict

Nitin Gupta (4):
      staging: zsmalloc: zsmalloc memory allocation library
      staging: zram: replace xvmalloc with zsmalloc
      staging: zram: remove xvmalloc
      staging: zram: Rename module parameter

Olof Johansson (2):
      staging:iio: isl29018: add of_match table for device-tree probing
      staging:iio: ak8975: add of_match table for device-tree probing

Omar Ramirez Luna (3):
      staging: tidspbridge: fix bridge_open memory leaks
      staging: tidspbridge: always compile dsp wdt code
      staging: tidspbridge: detect wdt3 feature at runtime

Paul E. McKenney (1):
      staging: android/lowmemorykiller: Don't unregister notifier from atomic context

Peter Huewe (12):
      staging/xgifb: Remove unsupported mode LCD_320x480
      staging/xgifb: Include sis headers
      staging/xgifb: Use structs and defines from the sis headers
      staging/xgifb: Remove remaining duplicate structs and defines
      staging/xgifb: Include sis initdef.h header
      staging/xgifb: Rename panel defines and remove duplicated defines
      staging/xgifb: Rename Set* defines and remove duplicated defines
      staging/xgifb: Rename remaining sis initdef.h defines and remove duplicates
      staging/xgifb: Rename XGI specific initdef.h defines
      staging/xgifb: Use TVCLKBASE_315 as a base address
      staging/xgifb: remove remaining duplicate initdef.h defines
      staging: asus_oled: Remove superfluous loop

Praneeth Kumar Bajjuri (1):
      staging: android-alarm: Disable Android alarm driver by default

Rabin Vincent (1):
      staging: logger: hold mutex while removing reader

Randy Dunlap (1):
      staging: ozwpan depends on NET

Rob Clark (10):
      staging: drm/omap: get supported color formats from ovl
      staging: drm/omap: add a workqueue
      staging: drm/omap: call omap_gem_roll() in non-atomic ctx
      staging: drm/omap: some minor fb cleanups
      staging: drm/omap: defer unpin until scanout completes
      staging: drm/omap: debugfs for object and fb tracking
      staging: drm/omap: mmap of tiled buffers with stride >4kb
      staging: drm/omap: avoid multiple planes having same z-order
      staging: drm/omap: send page-flip event after endwin
      staging: drm/omap: use current time for page-flip event

Roland Stigge (1):
      staging: iio: LPC32xx: ADC driver

Sam Hansen (5):
      staging: vme: code convention fix
      staging: xgifb: pr_fmt kbuild macro
      staging: xgifb: checkpatch cleanup braces
      staging: xgifb: checkpatch cleanup __func__
      staging: xgifb: checkpatch cleanup printk() -> pr_lvl()

Santosh Nayak (1):
      Staging: usbip: Remove commented code.

Sebastiaan de Haan (1):
      staging: wlan-ng: p80211netdev.c: fixed checkpatch error

Seth Jennings (13):
      staging: zcache: crypto API support
      staging: add zsmalloc to Kconfig/Makefile
      staging: zcache: fix serialization bug in zv stats
      staging: zcache: replace xvmalloc with zsmalloc
      staging: fix powerpc linux-next break on zsmalloc
      staging: zcache: fix length type mismatch
      staging: zcache: fix memory corruption bug
      staging: zcache: make zcache builtin only
      staging: zsmalloc: move object/handle masking defines
      staging: zsmalloc: add ZS_MAX_PAGES_PER_ZSPAGE
      staging: zsmalloc: calculate MAX_PHYSMEM_BITS if not defined
      staging: zsmalloc: change ZS_MIN_ALLOC_SIZE
      staging: zsmalloc: remove SPARSEMEM dep from Kconfig

Stephen Boyd (1):
      staging: ram_console: Fix section mismatches

Szymon Janc (18):
      Staging: quickstart: Some style, whitespaces and typos fixes
      Staging: quickstart: Prefix remaining functions names with quickstart_
      Staging: quickstart: Move some code to avoid forward declarations
      Staging: quickstart: Make quickstart_input static
      Staging: quickstart: Cleanup quickstart_acpi_ghid
      Staging: quickstart: Cleanup quickstart_acpi_remove
      Staging: quickstart: Cleanup quickstart_acpi_add
      Staging: quickstart: Cleanup quickstart_acpi_config
      Staging: quickstart: Use switch-case in quickstart_acpi_notify
      Staging: quickstart: Remove unused defines
      Staging: quickstart: Get rid of quickstart_data struct
      Staging: quickstart: Use list.h API for buttons list
      Staging: quickstart: Use %u for printing button id
      Staging: quickstart: Rename quickstart_btn to quickstart_button
      Staging: quickstart: Use pr_err and pr_info for logs
      Staging: quickstart: Use scnprintf in quickstart_pressed_button_show
      Staging: quickstart: Bump driver version to 1.04
      Staging: quickstart: Fix compilation warning on 64 bit arch

Thomas Meyer (3):
      Staging: android: ram_console: Use resource_size function
      Staging: bcm: Use memdup_user rather than duplicating its implementation
      staging: drm/omap: Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(..

Tim Bird (5):
      staging: android: logger: Change logger_offset() from macro to function
      staging: android: logger: simplify and optimize get_entry_len
      staging: android: logger: reorder prepare_to_wait and mutex_lock
      staging: android: logger: clarify code in clock_interval
      staging: android: logger: clarify non-update of w_off in do_write_log_from_user

Tomas Winkler (11):
      staging: fix the build breakage cuased by telephony drivers
      staging/mei: update copyright year to 2012
      staging/mei: normalize prototypes of all read buffers
      staging/mei: add mei user space example
      staging/mei: TODO : how to handle example code after unstaging
      staging/mei: fix hbm_host_version_response structure
      staging/mei: mei-amt-version - make all function static and used
      staging: mei: kill struct hbm_cmd bit fields
      staging/mei: don't use read buffer for writing
      staging/mei: propagate error codes up in the write flow
      staging: mei: remove driver internal versioning

Tracey Dent (2):
      drivers/staging/android/ashmem.c: Cleanups
      drivers/staging/android/timed_gpio.c: Stlye fixes

Víctor Manuel Jáquez Leal (29):
      staging: tidspbridge: more readable code
      staging: tidspbridge: remove unused header
      staging: tidspbridge: Lindent to drv_interface.c
      staging: tidspbridge: silence the compiler
      staging: tidspbridge: remove header inclusions
      staging: tidspbridge: remove trivial assert
      staging: tidspbridge: clean up bridge_mmap()
      staging: tidspbridge: use the driver name string
      staging: tidspbridge: remove DBC_ENSURE and DBC_REQUIRED
      staging: tidspbridge: remove DBC_ASSERT macro
      staging: tidspbridge: remove dbc.h
      staging: tidspbridge: remove CONFIG_TIDSPBRIDGE_DEBUG
      staging: tidspbridge: remove drv_init() and drv_exit()
      staging: tidspbridge: remove cod_init() and cod_exit()
      staging: tidspbridge: remove proc_init() and proc_exit()
      staging: tidspbridge: remove node_init() and node_exit()
      staging: tidspbridge: remove disp_init() and disp_exit()
      staging: tidspbridge: remove strm_init() and strm_exit()
      staging: tidspbridge: remove rmm_init() and rmm_exit()
      staging: tidspbridge: remove chnl_init() and chnl_exit()
      staging: tidspbridge: remove msg_mod_init() and msg_exit()
      staging: tidspbridge: remove io_init() and io_exit()
      staging: tidspbridge: remove cmm_init() and cmm_exit()
      staging: tidspbridge: remove dmm_init() and dmm_exit()
      staging: tidspbridge: remove dev_init() and dev_exit()
      staging: tidspbridge: simplify mgr_init()
      staging: tidspbridge: remove gh_init() and gh_exit()
      staging: tidspbridge: remove ref counting in nldr.c
      staging: tidspbridge: remove nldr_init() and nldr_exit()

Zhengwang Ruan (1):
      Staging:android: Change type for binder_debug_no_lock switch to bool

mahendra singh meena (1):
      Staging: vt6655: Fix brace coding style issues in ioctl.c

 MAINTAINERS                                        |    5 +
 drivers/Kconfig                                    |    2 -
 drivers/Makefile                                   |    1 -
 drivers/scsi/Kconfig                               |    7 +
 drivers/scsi/Makefile                              |    3 +
 drivers/{staging/hv => scsi}/storvsc_drv.c         | 1300 +++---
 drivers/staging/Kconfig                            |   10 +-
 drivers/staging/Makefile                           |    6 +-
 drivers/staging/android/Kconfig                    |   86 +-
 drivers/staging/android/Makefile                   |    3 +
 drivers/staging/android/TODO                       |    2 +-
 drivers/staging/android/alarm-dev.c                |  297 ++
 drivers/staging/android/alarm.c                    |  601 +++
 drivers/staging/android/android_alarm.h            |  121 +
 drivers/staging/android/ashmem.c                   |    4 +-
 drivers/staging/android/binder.c                   |    9 +-
 drivers/staging/android/logger.c                   |   78 +-
 drivers/staging/android/lowmemorykiller.c          |   91 +-
 drivers/staging/android/persistent_ram.c           |  470 ++
 drivers/staging/android/persistent_ram.h           |   78 +
 drivers/staging/android/ram_console.c              |  420 +-
 drivers/staging/android/timed_gpio.c               |    6 +-
 drivers/staging/android/timed_gpio.h               |    6 +-
 drivers/staging/asus_oled/asus_oled.c              |   19 +-
 drivers/staging/bcm/Bcmchar.c                      |   41 +-
 drivers/staging/bcm/CmHost.c                       | 3113 ++++++--------
 drivers/staging/bcm/led_control.h                  |   80 +-
 drivers/staging/comedi/Kconfig                     |    5 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |   29 +-
 drivers/staging/comedi/drivers/dt2801.c            |   12 +-
 drivers/staging/comedi/drivers/dt9812.c            |    4 +-
 drivers/staging/comedi/drivers/me4000.c            |   12 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |   61 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |   27 +-
 drivers/staging/comedi/drivers/unioxx5.c           |    2 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |   42 +-
 drivers/staging/crystalhd/bc_dts_glob_lnx.h        |    3 +-
 drivers/staging/crystalhd/bc_dts_types.h           |   40 -
 drivers/staging/crystalhd/crystalhd.h              |   14 +
 drivers/staging/crystalhd/crystalhd_cmds.c         |    3 +-
 drivers/staging/crystalhd/crystalhd_cmds.h         |    4 +-
 drivers/staging/crystalhd/crystalhd_hw.c           |   11 +-
 drivers/staging/crystalhd/crystalhd_hw.h           |    3 +-
 drivers/staging/crystalhd/crystalhd_lnx.c          |    7 +-
 drivers/staging/crystalhd/crystalhd_lnx.h          |    5 +-
 drivers/staging/crystalhd/crystalhd_misc.c         |    5 +-
 drivers/staging/crystalhd/crystalhd_misc.h         |   34 +-
 drivers/staging/et131x/README                      |    2 +-
 drivers/staging/et131x/et131x.c                    |   10 +-
 drivers/staging/et131x/et131x.h                    |    4 +-
 drivers/staging/frontier/alphatrack.c              |    2 +-
 drivers/staging/frontier/tranzport.c               |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |    6 +-
 drivers/staging/hv/Kconfig                         |    5 -
 drivers/staging/hv/Makefile                        |    3 -
 drivers/staging/hv/TODO                            |    5 -
 drivers/staging/iio/Documentation/device.txt       |    2 +-
 .../staging/iio/Documentation/iio_event_monitor.c  |  241 ++
 drivers/staging/iio/Documentation/inkernel.txt     |   58 +
 drivers/staging/iio/Kconfig                        |    9 +-
 drivers/staging/iio/Makefile                       |    4 +-
 drivers/staging/iio/accel/adis16201_ring.c         |    2 -
 drivers/staging/iio/accel/adis16203_ring.c         |    2 -
 drivers/staging/iio/accel/adis16204_ring.c         |    2 -
 drivers/staging/iio/accel/adis16209_ring.c         |    2 -
 drivers/staging/iio/accel/adis16240_ring.c         |    2 -
 drivers/staging/iio/accel/lis3l02dq.h              |    2 -
 drivers/staging/iio/accel/lis3l02dq_ring.c         |    4 +-
 drivers/staging/iio/accel/sca3000.h                |    2 +-
 drivers/staging/iio/adc/Kconfig                    |    9 +
 drivers/staging/iio/adc/Makefile                   |    1 +
 drivers/staging/iio/adc/ad7192.c                   |   45 +-
 drivers/staging/iio/adc/ad7291.c                   |   14 +-
 drivers/staging/iio/adc/ad7298_ring.c              |    3 -
 drivers/staging/iio/adc/ad7476_ring.c              |    4 +-
 drivers/staging/iio/adc/ad7606_core.c              |   83 +-
 drivers/staging/iio/adc/ad7606_par.c               |   13 +-
 drivers/staging/iio/adc/ad7606_ring.c              |    2 -
 drivers/staging/iio/adc/ad7793.c                   |    2 -
 drivers/staging/iio/adc/ad7887_ring.c              |    2 -
 drivers/staging/iio/adc/ad799x_core.c              |    4 +-
 drivers/staging/iio/adc/ad799x_ring.c              |    4 +-
 drivers/staging/iio/adc/adt7310.c                  |   21 +-
 drivers/staging/iio/adc/adt7410.c                  |   21 +-
 drivers/staging/iio/adc/lpc32xx_adc.c              |  237 +
 drivers/staging/iio/adc/max1363_core.c             |   50 +-
 drivers/staging/iio/adc/max1363_ring.c             |    2 -
 drivers/staging/iio/addac/adt7316-i2c.c            |   18 +-
 drivers/staging/iio/addac/adt7316-spi.c            |   18 +-
 drivers/staging/iio/addac/adt7316.c                |   11 +-
 drivers/staging/iio/addac/adt7316.h                |    9 +-
 drivers/staging/iio/buffer.h                       |    2 -
 drivers/staging/iio/cdc/ad7150.c                   |   10 +-
 drivers/staging/iio/consumer.h                     |   96 +
 drivers/staging/iio/dac/Kconfig                    |    7 +-
 drivers/staging/iio/dac/ad5064.c                   |  369 +-
 drivers/staging/iio/dac/ad5360.c                   |    4 +-
 drivers/staging/iio/dac/ad5380.c                   |    4 +-
 drivers/staging/iio/dac/ad5421.c                   |   13 +-
 drivers/staging/iio/dac/ad5446.c                   |   35 +-
 drivers/staging/iio/dac/ad5764.c                   |   13 +-
 drivers/staging/iio/dac/max517.c                   |   18 +-
 drivers/staging/iio/dds/ad9834.c                   |   53 +-
 drivers/staging/iio/driver.h                       |   34 +
 drivers/staging/iio/events.h                       |    4 +-
 drivers/staging/iio/gyro/adis16260_ring.c          |    2 -
 drivers/staging/iio/iio.h                          |   70 +-
 drivers/staging/iio/iio_core.h                     |    4 +
 drivers/staging/iio/iio_dummy_evgen.c              |    2 +-
 drivers/staging/iio/iio_hwmon.c                    |  232 +
 drivers/staging/iio/iio_simple_dummy_buffer.c      |    2 -
 drivers/staging/iio/impedance-analyzer/ad5933.c    |    3 -
 drivers/staging/iio/imu/adis16400_ring.c           |    2 -
 drivers/staging/iio/industrialio-buffer.c          |    6 +-
 drivers/staging/iio/industrialio-core.c            |  658 +--
 drivers/staging/iio/industrialio-event.c           |  453 ++
 drivers/staging/iio/inkern.c                       |  292 ++
 drivers/staging/iio/kfifo_buf.c                    |   46 +-
 drivers/staging/iio/kfifo_buf.h                    |    2 -
 drivers/staging/iio/light/isl29018.c               |    7 +
 drivers/staging/iio/light/tsl2563.c                |   65 +-
 drivers/staging/iio/light/tsl2583.c                |   19 +-
 drivers/staging/iio/machine.h                      |   24 +
 drivers/staging/iio/magnetometer/ak8975.c          |    8 +
 drivers/staging/iio/magnetometer/hmc5843.c         |   26 +-
 drivers/staging/iio/meter/ade7758_ring.c           |    4 +-
 drivers/staging/iio/meter/meter.h                  |    2 +-
 drivers/staging/iio/ring_sw.c                      |   26 +-
 drivers/staging/iio/ring_sw.h                      |    5 -
 drivers/staging/iio/trigger/iio-trig-bfin-timer.c  |   12 +-
 drivers/staging/iio/trigger/iio-trig-gpio.c        |   12 +-
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |   12 +-
 drivers/staging/iio/types.h                        |    4 +
 drivers/staging/keucr/TODO                         |    2 +-
 drivers/staging/line6/capture.c                    |   54 +-
 drivers/staging/line6/capture.h                    |    2 +-
 drivers/staging/line6/driver.c                     |    2 +-
 drivers/staging/line6/pcm.c                        |  109 +-
 drivers/staging/line6/pcm.h                        |  167 +-
 drivers/staging/line6/playback.c                   |   68 +-
 drivers/staging/line6/playback.h                   |    2 +-
 drivers/staging/line6/toneport.c                   |   12 +-
 drivers/staging/line6/usbdefs.h                    |   44 +-
 drivers/staging/media/easycap/easycap_main.c       |    1 +
 drivers/staging/media/lirc/lirc_sasem.c            |   17 +-
 drivers/staging/mei/TODO                           |    3 +
 drivers/staging/mei/hw.h                           |   47 +-
 drivers/staging/mei/init.c                         |   24 +-
 drivers/staging/mei/interface.c                    |   72 +-
 drivers/staging/mei/interface.h                    |    7 +-
 drivers/staging/mei/interrupt.c                    |  106 +-
 drivers/staging/mei/iorw.c                         |   17 +-
 drivers/staging/mei/main.c                         |   14 +-
 drivers/staging/mei/mei-amt-version.c              |  481 +++
 drivers/staging/mei/mei.h                          |  127 +-
 drivers/staging/mei/mei.txt                        |    6 +-
 drivers/staging/mei/mei_dev.h                      |   10 +-
 drivers/staging/mei/mei_version.h                  |   31 -
 drivers/staging/mei/wd.c                           |    8 +-
 drivers/staging/nvec/Kconfig                       |    6 +-
 drivers/staging/nvec/nvec.c                        |   19 +-
 drivers/staging/nvec/nvec_ps2.c                    |   53 +-
 drivers/staging/octeon/ethernet-mdio.c             |    4 +-
 drivers/staging/omapdrm/omap_crtc.c                |   37 +-
 drivers/staging/omapdrm/omap_debugfs.c             |   97 +-
 drivers/staging/omapdrm/omap_dmm_tiler.c           |   91 +-
 drivers/staging/omapdrm/omap_dmm_tiler.h           |   15 +-
 drivers/staging/omapdrm/omap_drv.c                 |   16 +
 drivers/staging/omapdrm/omap_drv.h                 |   19 +-
 drivers/staging/omapdrm/omap_fb.c                  |  124 +-
 drivers/staging/omapdrm/omap_fbdev.c               |   26 +-
 drivers/staging/omapdrm/omap_gem.c                 |  172 +-
 drivers/staging/omapdrm/omap_gem_helpers.c         |    2 +-
 drivers/staging/omapdrm/omap_plane.c               |  197 +-
 drivers/staging/ozwpan/Kbuild                      |   19 +
 drivers/staging/ozwpan/Kconfig                     |    9 +
 drivers/staging/ozwpan/README                      |   25 +
 drivers/staging/ozwpan/TODO                        |   12 +
 drivers/staging/ozwpan/ozappif.h                   |   46 +
 drivers/staging/ozwpan/ozcdev.c                    |  521 +++
 drivers/staging/ozwpan/ozcdev.h                    |   18 +
 drivers/staging/ozwpan/ozconfig.h                  |   27 +
 drivers/staging/ozwpan/ozeltbuf.c                  |  339 ++
 drivers/staging/ozwpan/ozeltbuf.h                  |   70 +
 drivers/staging/ozwpan/ozevent.c                   |  116 +
 drivers/staging/ozwpan/ozevent.h                   |   31 +
 drivers/staging/ozwpan/ozeventdef.h                |   47 +
 drivers/staging/ozwpan/ozhcd.c                     | 2256 ++++++++++
 drivers/staging/ozwpan/ozhcd.h                     |   15 +
 drivers/staging/ozwpan/ozmain.c                    |   58 +
 drivers/staging/ozwpan/ozpd.c                      |  832 ++++
 drivers/staging/ozwpan/ozpd.h                      |  121 +
 drivers/staging/ozwpan/ozproto.c                   |  957 +++++
 drivers/staging/ozwpan/ozproto.h                   |   69 +
 drivers/staging/ozwpan/ozprotocol.h                |  372 ++
 drivers/staging/ozwpan/oztrace.c                   |   36 +
 drivers/staging/ozwpan/oztrace.h                   |   35 +
 drivers/staging/ozwpan/ozurbparanoia.c             |   53 +
 drivers/staging/ozwpan/ozurbparanoia.h             |   19 +
 drivers/staging/ozwpan/ozusbif.h                   |   43 +
 drivers/staging/ozwpan/ozusbsvc.c                  |  245 ++
 drivers/staging/ozwpan/ozusbsvc.h                  |   32 +
 drivers/staging/ozwpan/ozusbsvc1.c                 |  437 ++
 drivers/staging/quickstart/quickstart.c            |  370 +-
 drivers/staging/ramster/Kconfig                    |   17 +
 drivers/staging/ramster/Makefile                   |    1 +
 drivers/staging/ramster/TODO                       |   13 +
 drivers/staging/ramster/cluster/Makefile           |    3 +
 drivers/staging/ramster/cluster/heartbeat.c        |  464 ++
 drivers/staging/ramster/cluster/heartbeat.h        |   87 +
 drivers/staging/ramster/cluster/masklog.c          |  155 +
 drivers/staging/ramster/cluster/masklog.h          |  220 +
 drivers/staging/ramster/cluster/nodemanager.c      |  992 +++++
 drivers/staging/ramster/cluster/nodemanager.h      |   88 +
 .../staging/ramster/cluster/ramster_nodemanager.h  |   39 +
 drivers/staging/ramster/cluster/tcp.c              | 2256 ++++++++++
 drivers/staging/ramster/cluster/tcp.h              |  159 +
 drivers/staging/ramster/cluster/tcp_internal.h     |  248 ++
 drivers/staging/ramster/r2net.c                    |  401 ++
 drivers/staging/ramster/ramster.h                  |  118 +
 drivers/staging/ramster/tmem.c                     |  851 ++++
 drivers/staging/ramster/tmem.h                     |  244 ++
 drivers/staging/{zram => ramster}/xvmalloc.c       |    0
 drivers/staging/{zram => ramster}/xvmalloc.h       |    0
 drivers/staging/{zram => ramster}/xvmalloc_int.h   |    0
 drivers/staging/ramster/zcache-main.c              | 3320 ++++++++++++++
 drivers/staging/ramster/zcache.h                   |   22 +
 drivers/staging/rtl8187se/r8180_core.c             |  111 +-
 drivers/staging/rtl8187se/r8180_dm.c               | 1792 +++-----
 drivers/staging/rtl8187se/r8180_wx.c               |  286 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |    2 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |    3 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |    1 -
 drivers/staging/rtl8712/Kconfig                    |    7 -
 drivers/staging/rtl8712/drv_types.h                |    1 -
 drivers/staging/rtl8712/os_intfs.c                 |    6 -
 drivers/staging/rtl8712/osdep_service.h            |   17 -
 drivers/staging/rtl8712/rtl8712_recv.c             |    2 -
 drivers/staging/rtl8712/rtl871x_io.c               |    1 -
 drivers/staging/rtl8712/rtl871x_io.h               |    1 -
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |    8 +-
 drivers/staging/rtl8712/rtl871x_pwrctrl.c          |   11 +-
 drivers/staging/rtl8712/rtl871x_pwrctrl.h          |    1 -
 drivers/staging/rtl8712/rtl871x_recv.c             |    1 -
 drivers/staging/rtl8712/rtl871x_recv.h             |    3 -
 drivers/staging/rtl8712/rtl871x_sta_mgt.c          |    4 -
 drivers/staging/rtl8712/rtl871x_xmit.c             |    3 -
 drivers/staging/rtl8712/rtl871x_xmit.h             |    3 -
 drivers/staging/rtl8712/sta_info.h                 |    4 -
 drivers/staging/rtl8712/usb_intf.c                 |    9 +-
 drivers/staging/rts5139/TODO                       |    6 +-
 drivers/staging/rts5139/ms.h                       |    4 +-
 drivers/staging/rts5139/rts51x_chip.c              |   14 +-
 drivers/staging/rts5139/rts51x_chip.h              |    6 +-
 drivers/staging/rts5139/rts51x_fop.h               |    2 +-
 drivers/staging/rts5139/rts51x_transport.c         |    2 +-
 drivers/staging/rts5139/rts51x_transport.h         |    2 +-
 drivers/staging/rts5139/sd_cprm.c                  |    2 +-
 drivers/staging/rts_pstor/TODO                     |    6 +-
 drivers/staging/sbe-2t3e3/intr.c                   |    2 +-
 drivers/staging/sep/Kconfig                        |    3 +-
 drivers/staging/sep/Makefile                       |    5 +-
 drivers/staging/sep/TODO                           |    5 +-
 drivers/staging/sep/sep_crypto.c                   | 4058 ++++++++++++++++++
 drivers/staging/sep/sep_crypto.h                   |  359 ++
 drivers/staging/sep/sep_dev.h                      |   98 +-
 drivers/staging/sep/sep_driver.c                   | 2932 -------------
 drivers/staging/sep/sep_driver_api.h               |  293 +-
 drivers/staging/sep/sep_driver_config.h            |   79 +-
 drivers/staging/sep/sep_driver_hw_defs.h           |  185 +-
 drivers/staging/sep/sep_main.c                     | 4518 ++++++++++++++++++++
 drivers/staging/sep/sep_trace_events.h             |  188 +
 drivers/staging/slicoss/README                     |    2 +-
 drivers/staging/sm7xx/smtcfb.c                     |    3 +-
 drivers/staging/sm7xx/smtcfb.h                     |    2 +-
 drivers/{ => staging}/telephony/Kconfig            |    0
 drivers/{ => staging}/telephony/Makefile           |    0
 drivers/staging/telephony/TODO                     |   10 +
 drivers/{ => staging}/telephony/ixj-ver.h          |    0
 drivers/{ => staging}/telephony/ixj.c              |    0
 drivers/{ => staging}/telephony/ixj.h              |    0
 drivers/{ => staging}/telephony/ixj_pcmcia.c       |    0
 drivers/{ => staging}/telephony/phonedev.c         |    0
 drivers/staging/tidspbridge/Kconfig                |   22 -
 drivers/staging/tidspbridge/Makefile               |    4 +-
 drivers/staging/tidspbridge/core/chnl_sm.c         |   34 +-
 drivers/staging/tidspbridge/core/dsp-clock.c       |    3 -
 drivers/staging/tidspbridge/core/io_sm.c           |   29 +-
 drivers/staging/tidspbridge/core/msg_sm.c          |    3 -
 drivers/staging/tidspbridge/core/tiomap3430.c      |   19 +-
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    1 -
 drivers/staging/tidspbridge/core/tiomap_io.c       |   18 -
 drivers/staging/tidspbridge/core/wdt.c             |   24 +-
 drivers/staging/tidspbridge/gen/gh.c               |   18 -
 drivers/staging/tidspbridge/gen/uuidutil.c         |    7 -
 .../tidspbridge/include/dspbridge/_chnl_sm.h       |    4 -
 .../staging/tidspbridge/include/dspbridge/chnl.h   |   29 -
 .../staging/tidspbridge/include/dspbridge/cmm.h    |   30 -
 .../staging/tidspbridge/include/dspbridge/cod.h    |   29 -
 .../staging/tidspbridge/include/dspbridge/dbc.h    |   46 -
 .../staging/tidspbridge/include/dspbridge/dev.h    |   27 -
 .../staging/tidspbridge/include/dspbridge/disp.h   |   31 -
 .../staging/tidspbridge/include/dspbridge/dmm.h    |    4 -
 .../staging/tidspbridge/include/dspbridge/drv.h    |   23 -
 drivers/staging/tidspbridge/include/dspbridge/gh.h |    2 -
 drivers/staging/tidspbridge/include/dspbridge/io.h |   29 -
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |    2 -
 .../staging/tidspbridge/include/dspbridge/msg.h    |   27 -
 .../staging/tidspbridge/include/dspbridge/nldr.h   |    2 -
 .../tidspbridge/include/dspbridge/nldrdefs.h       |   34 -
 .../staging/tidspbridge/include/dspbridge/node.h   |   41 -
 .../tidspbridge/include/dspbridge/nodepriv.h       |    1 -
 .../staging/tidspbridge/include/dspbridge/proc.h   |   28 -
 .../staging/tidspbridge/include/dspbridge/rmm.h    |   25 -
 .../staging/tidspbridge/include/dspbridge/strm.h   |   38 +-
 drivers/staging/tidspbridge/pmgr/chnl.c            |   47 -
 drivers/staging/tidspbridge/pmgr/cmm.c             |   97 +-
 drivers/staging/tidspbridge/pmgr/cod.c             |  103 -
 drivers/staging/tidspbridge/pmgr/dbll.c            |  125 +-
 drivers/staging/tidspbridge/pmgr/dev.c             |  182 -
 drivers/staging/tidspbridge/pmgr/dmm.c             |   46 -
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   82 +-
 drivers/staging/tidspbridge/pmgr/io.c              |   45 -
 drivers/staging/tidspbridge/pmgr/msg.c             |   38 -
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |  103 +-
 drivers/staging/tidspbridge/rmgr/disp.c            |   69 -
 drivers/staging/tidspbridge/rmgr/drv.c             |   74 -
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |  366 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.h   |   28 -
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |    5 -
 drivers/staging/tidspbridge/rmgr/mgr.c             |   45 +-
 drivers/staging/tidspbridge/rmgr/nldr.c            |   99 -
 drivers/staging/tidspbridge/rmgr/node.c            |  129 -
 drivers/staging/tidspbridge/rmgr/proc.c            |  119 -
 drivers/staging/tidspbridge/rmgr/rmm.c             |   56 -
 drivers/staging/tidspbridge/rmgr/strm.c            |  114 +-
 drivers/staging/usbip/stub.h                       |    1 -
 drivers/staging/usbip/stub_dev.c                   |    2 -
 drivers/staging/usbip/stub_rx.c                    |    9 -
 drivers/staging/usbip/usbip_common.c               |   11 +-
 drivers/staging/usbip/usbip_common.h               |    2 +-
 drivers/staging/usbip/vhci_hcd.c                   |   41 -
 drivers/staging/usbip/vhci_rx.c                    |    3 +-
 drivers/staging/vme/devices/vme_pio2.h             |    4 +-
 drivers/staging/vme/devices/vme_pio2_gpio.c        |    4 +-
 drivers/staging/vme/vme.h                          |    2 +-
 drivers/staging/vt6655/bssdb.c                     |    4 +-
 drivers/staging/vt6655/ioctl.c                     |   23 +-
 drivers/staging/vt6656/bssdb.c                     |    4 +-
 drivers/staging/vt6656/iwctl.c                     |  230 +-
 drivers/staging/vt6656/iwctl.h                     |   13 +-
 drivers/staging/vt6656/main_usb.c                  |   13 +-
 drivers/staging/vt6656/wpactl.c                    |  937 ++--
 drivers/staging/wlan-ng/cfg80211.c                 |    2 +-
 drivers/staging/wlan-ng/p80211netdev.c             |    2 +-
 drivers/staging/wlan-ng/prism2mgmt.c               |    1 +
 drivers/staging/xgifb/XGI_main.h                   |   78 +-
 drivers/staging/xgifb/XGI_main_26.c                |  208 +-
 drivers/staging/xgifb/XGIfb.h                      |    2 +-
 drivers/staging/xgifb/vb_def.h                     |  178 +-
 drivers/staging/xgifb/vb_init.c                    |   20 +-
 drivers/staging/xgifb/vb_setmode.c                 |  836 ++--
 drivers/staging/xgifb/vb_struct.h                  |   79 +-
 drivers/staging/xgifb/vb_table.h                   |  346 +-
 drivers/staging/xgifb/vgatypes.h                   |    9 +
 drivers/staging/zcache/Kconfig                     |   13 +-
 drivers/staging/zcache/tmem.h                      |    2 +-
 drivers/staging/zcache/zcache-main.c               |  237 +-
 drivers/staging/zram/Kconfig                       |   10 +-
 drivers/staging/zram/Makefile                      |    1 -
 drivers/staging/zram/zram_drv.c                    |  116 +-
 drivers/staging/zram/zram_drv.h                    |   12 +-
 drivers/staging/zram/zram_sysfs.c                  |    4 +-
 drivers/staging/zsmalloc/Kconfig                   |   14 +
 drivers/staging/zsmalloc/Makefile                  |    3 +
 drivers/staging/zsmalloc/zsmalloc-main.c           |  745 ++++
 drivers/staging/zsmalloc/zsmalloc.h                |   31 +
 drivers/staging/zsmalloc/zsmalloc_int.h            |  155 +
 379 files changed, 37952 insertions(+), 14153 deletions(-)
 rename drivers/{staging/hv => scsi}/storvsc_drv.c (84%)
 create mode 100644 drivers/staging/android/alarm-dev.c
 create mode 100644 drivers/staging/android/alarm.c
 create mode 100644 drivers/staging/android/android_alarm.h
 create mode 100644 drivers/staging/android/persistent_ram.c
 create mode 100644 drivers/staging/android/persistent_ram.h
 delete mode 100644 drivers/staging/crystalhd/bc_dts_types.h
 create mode 100644 drivers/staging/crystalhd/crystalhd.h
 delete mode 100644 drivers/staging/hv/Kconfig
 delete mode 100644 drivers/staging/hv/Makefile
 delete mode 100644 drivers/staging/hv/TODO
 create mode 100644 drivers/staging/iio/Documentation/iio_event_monitor.c
 create mode 100644 drivers/staging/iio/Documentation/inkernel.txt
 create mode 100644 drivers/staging/iio/adc/lpc32xx_adc.c
 create mode 100644 drivers/staging/iio/consumer.h
 create mode 100644 drivers/staging/iio/driver.h
 create mode 100644 drivers/staging/iio/iio_hwmon.c
 create mode 100644 drivers/staging/iio/industrialio-event.c
 create mode 100644 drivers/staging/iio/inkern.c
 create mode 100644 drivers/staging/iio/machine.h
 create mode 100644 drivers/staging/mei/mei-amt-version.c
 delete mode 100644 drivers/staging/mei/mei_version.h
 create mode 100644 drivers/staging/ozwpan/Kbuild
 create mode 100644 drivers/staging/ozwpan/Kconfig
 create mode 100644 drivers/staging/ozwpan/README
 create mode 100644 drivers/staging/ozwpan/TODO
 create mode 100644 drivers/staging/ozwpan/ozappif.h
 create mode 100644 drivers/staging/ozwpan/ozcdev.c
 create mode 100644 drivers/staging/ozwpan/ozcdev.h
 create mode 100644 drivers/staging/ozwpan/ozconfig.h
 create mode 100644 drivers/staging/ozwpan/ozeltbuf.c
 create mode 100644 drivers/staging/ozwpan/ozeltbuf.h
 create mode 100644 drivers/staging/ozwpan/ozevent.c
 create mode 100644 drivers/staging/ozwpan/ozevent.h
 create mode 100644 drivers/staging/ozwpan/ozeventdef.h
 create mode 100644 drivers/staging/ozwpan/ozhcd.c
 create mode 100644 drivers/staging/ozwpan/ozhcd.h
 create mode 100644 drivers/staging/ozwpan/ozmain.c
 create mode 100644 drivers/staging/ozwpan/ozpd.c
 create mode 100644 drivers/staging/ozwpan/ozpd.h
 create mode 100644 drivers/staging/ozwpan/ozproto.c
 create mode 100644 drivers/staging/ozwpan/ozproto.h
 create mode 100644 drivers/staging/ozwpan/ozprotocol.h
 create mode 100644 drivers/staging/ozwpan/oztrace.c
 create mode 100644 drivers/staging/ozwpan/oztrace.h
 create mode 100644 drivers/staging/ozwpan/ozurbparanoia.c
 create mode 100644 drivers/staging/ozwpan/ozurbparanoia.h
 create mode 100644 drivers/staging/ozwpan/ozusbif.h
 create mode 100644 drivers/staging/ozwpan/ozusbsvc.c
 create mode 100644 drivers/staging/ozwpan/ozusbsvc.h
 create mode 100644 drivers/staging/ozwpan/ozusbsvc1.c
 create mode 100644 drivers/staging/ramster/Kconfig
 create mode 100644 drivers/staging/ramster/Makefile
 create mode 100644 drivers/staging/ramster/TODO
 create mode 100644 drivers/staging/ramster/cluster/Makefile
 create mode 100644 drivers/staging/ramster/cluster/heartbeat.c
 create mode 100644 drivers/staging/ramster/cluster/heartbeat.h
 create mode 100644 drivers/staging/ramster/cluster/masklog.c
 create mode 100644 drivers/staging/ramster/cluster/masklog.h
 create mode 100644 drivers/staging/ramster/cluster/nodemanager.c
 create mode 100644 drivers/staging/ramster/cluster/nodemanager.h
 create mode 100644 drivers/staging/ramster/cluster/ramster_nodemanager.h
 create mode 100644 drivers/staging/ramster/cluster/tcp.c
 create mode 100644 drivers/staging/ramster/cluster/tcp.h
 create mode 100644 drivers/staging/ramster/cluster/tcp_internal.h
 create mode 100644 drivers/staging/ramster/r2net.c
 create mode 100644 drivers/staging/ramster/ramster.h
 create mode 100644 drivers/staging/ramster/tmem.c
 create mode 100644 drivers/staging/ramster/tmem.h
 rename drivers/staging/{zram => ramster}/xvmalloc.c (100%)
 rename drivers/staging/{zram => ramster}/xvmalloc.h (100%)
 rename drivers/staging/{zram => ramster}/xvmalloc_int.h (100%)
 create mode 100644 drivers/staging/ramster/zcache-main.c
 create mode 100644 drivers/staging/ramster/zcache.h
 create mode 100644 drivers/staging/sep/sep_crypto.c
 create mode 100644 drivers/staging/sep/sep_crypto.h
 delete mode 100644 drivers/staging/sep/sep_driver.c
 create mode 100644 drivers/staging/sep/sep_main.c
 create mode 100644 drivers/staging/sep/sep_trace_events.h
 rename drivers/{ => staging}/telephony/Kconfig (100%)
 rename drivers/{ => staging}/telephony/Makefile (100%)
 create mode 100644 drivers/staging/telephony/TODO
 rename drivers/{ => staging}/telephony/ixj-ver.h (100%)
 rename drivers/{ => staging}/telephony/ixj.c (100%)
 rename drivers/{ => staging}/telephony/ixj.h (100%)
 rename drivers/{ => staging}/telephony/ixj_pcmcia.c (100%)
 rename drivers/{ => staging}/telephony/phonedev.c (100%)
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbc.h
 delete mode 100644 drivers/staging/tidspbridge/rmgr/drv_interface.h
 create mode 100644 drivers/staging/zsmalloc/Kconfig
 create mode 100644 drivers/staging/zsmalloc/Makefile
 create mode 100644 drivers/staging/zsmalloc/zsmalloc-main.c
 create mode 100644 drivers/staging/zsmalloc/zsmalloc.h
 create mode 100644 drivers/staging/zsmalloc/zsmalloc_int.h

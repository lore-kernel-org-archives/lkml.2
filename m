Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0FWNCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 09:02:55 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58323 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0FWNCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 09:02:53 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: Greg KH <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
       Hebbar Shivananda <x0hebbar@ti.com>,
       Ramos Falcon Ernesto <ernesto@ti.com>, Anna Suman <s-anna@ti.com>,
       Kanigeri Hari <h-kanigeri2@ti.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, Gupta Ramesh <grgupta@ti.com>,
       Guzman Lugo Fernando <fernando.lugo@ti.com>,
       Tony Lindgren <tony@atomide.com>,
       Ameya Palande <ameya.palande@nokia.com>,
       Gomez Castellanos Ivan <ivan.gomez@ti.com>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Armando Uribe De Leon <x0095078@ti.com>,
       Deepak Chitriki <deepak.chitriki@ti.com>, Menon Nishanth <nm@ti.com>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Pitney Gilbert <gpitney@ti.com>, Bhavin Shah <bshah@ti.com>,
       Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 00/11] staging: add ti dspbridge driver
Date: Wed, 23 Jun 2010 16:01:54 +0300
Message-Id: <1277298125-17991-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TI's DSP Bridge driver to the staging area.

TI's DSP Bridge driver supplies a direct link between 
host applications and DSP tasks running on a remote processor.

Please pull from:

git://wizery.com/pub/tidspbridge.git for-greg

The patches will be sent as a follow-on to this message to lkml and l-o for
people to see.

The patches are the result of a staging relocation and a linux-next
rebase of 85343cd5491260881b34ab7bb7cdc8fdeef078e4 at
git://dev.omapzoom.org/pub/scm/tidspbridge/kernel-dspbridge.git dspbridge

For more information about TI's DSP Bridge, check out the 
submitted documentation and also:
http://omapzoom.org/gf/project/omapbridge/docman/?subdir=3

The DSP/Bridge project wish to thank all of its contributors;
current bridge driver is the result of the work of all of them.

The following is an alphabetical order of all contributors (that we
know of. If by any chance we forgot to mention anyone, please let
us know, thanks!):

	Suman Anna
	Sripal Bagadia
	Felipe Balbi
	Ohad Ben-Cohen
	Phil Carmody
	Deepak Chitriki
	Felipe Contreras
	Hiroshi Doyu
	Seth Forshee
	Ivan Gomez Castellanos
	Mark Grosen
	Ramesh Gupta G
	Fernando Guzman Lugo
	Axel Haslam
	Janet Head
	Shivananda Hebbar
	Hari Kanigeri
	Tony Lindgren
	Antonio Luna
	Hari Nagalla
	Nishanth Menon
	Ameya Palande
	Vijay Pasam
	Gilbert Pitney
	Omar Ramirez Luna
	Ernesto Ramos
	Chris Ring
	Larry Schiefer
	Rebecca Schultz Zavin
	Bhavin Shah
	Andy Shevchenko
	Jeff Taylor
	Roman Tereshonkov
	Armando Uribe de Leon
	Nischal Varide
	Wenbiao Wang

Thanks,

Ohad Ben-Cohen (1):
  staging: ti dspbridge: add TODO file

Omar Ramirez Luna (10):
  staging: ti dspbridge: add driver documentation
  staging: ti dspbridge: add core driver sources
  staging: ti dspbridge: add platform manager code
  staging: ti dspbridge: add resource manager
  staging: ti dspbridge: add MMU support
  staging: ti dspbridge: add generic utilities
  staging: ti dspbridge: add services
  staging: ti dspbridge: add DOFF binaries loader
  staging: ti dspbridge: add header files
  staging: ti dspbridge: enable driver building

 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 .../staging/tidspbridge/Documentation/CONTRIBUTORS |   82 +
 drivers/staging/tidspbridge/Documentation/README   |   70 +
 .../staging/tidspbridge/Documentation/error-codes  |  157 +
 drivers/staging/tidspbridge/Kconfig                |   88 +
 drivers/staging/tidspbridge/Makefile               |   34 +
 drivers/staging/tidspbridge/TODO                   |   18 +
 drivers/staging/tidspbridge/core/_cmm.h            |   45 +
 drivers/staging/tidspbridge/core/_deh.h            |   35 +
 drivers/staging/tidspbridge/core/_msg_sm.h         |  142 +
 drivers/staging/tidspbridge/core/_tiomap.h         |  377 +++
 drivers/staging/tidspbridge/core/_tiomap_pwr.h     |   85 +
 drivers/staging/tidspbridge/core/chnl_sm.c         | 1015 ++++++
 drivers/staging/tidspbridge/core/dsp-clock.c       |  421 +++
 drivers/staging/tidspbridge/core/io_sm.c           | 2410 +++++++++++++++
 drivers/staging/tidspbridge/core/mmu_fault.c       |  139 +
 drivers/staging/tidspbridge/core/mmu_fault.h       |   36 +
 drivers/staging/tidspbridge/core/msg_sm.c          |  673 ++++
 drivers/staging/tidspbridge/core/tiomap3430.c      | 1887 ++++++++++++
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |  604 ++++
 drivers/staging/tidspbridge/core/tiomap_io.c       |  458 +++
 drivers/staging/tidspbridge/core/tiomap_io.h       |  104 +
 drivers/staging/tidspbridge/core/ue_deh.c          |  303 ++
 drivers/staging/tidspbridge/core/wdt.c             |  150 +
 drivers/staging/tidspbridge/dynload/cload.c        | 1960 ++++++++++++
 .../staging/tidspbridge/dynload/dload_internal.h   |  351 +++
 drivers/staging/tidspbridge/dynload/doff.h         |  344 +++
 drivers/staging/tidspbridge/dynload/getsection.c   |  416 +++
 drivers/staging/tidspbridge/dynload/header.h       |   55 +
 drivers/staging/tidspbridge/dynload/module_list.h  |  159 +
 drivers/staging/tidspbridge/dynload/params.h       |  226 ++
 drivers/staging/tidspbridge/dynload/reloc.c        |  484 +++
 drivers/staging/tidspbridge/dynload/reloc_table.h  |  102 +
 .../tidspbridge/dynload/reloc_table_c6000.c        |  257 ++
 drivers/staging/tidspbridge/dynload/tramp.c        | 1143 +++++++
 .../tidspbridge/dynload/tramp_table_c6000.c        |  164 +
 drivers/staging/tidspbridge/gen/gb.c               |  167 +
 drivers/staging/tidspbridge/gen/gh.c               |  213 ++
 drivers/staging/tidspbridge/gen/gs.c               |   89 +
 drivers/staging/tidspbridge/gen/uuidutil.c         |  223 ++
 drivers/staging/tidspbridge/hw/EasiGlobal.h        |   41 +
 drivers/staging/tidspbridge/hw/GlobalTypes.h       |  308 ++
 drivers/staging/tidspbridge/hw/MMUAccInt.h         |   76 +
 drivers/staging/tidspbridge/hw/MMURegAcM.h         |  226 ++
 drivers/staging/tidspbridge/hw/hw_defs.h           |   60 +
 drivers/staging/tidspbridge/hw/hw_mmu.c            |  587 ++++
 drivers/staging/tidspbridge/hw/hw_mmu.h            |  161 +
 .../tidspbridge/include/dspbridge/_chnl_sm.h       |  181 ++
 .../tidspbridge/include/dspbridge/brddefs.h        |   39 +
 .../staging/tidspbridge/include/dspbridge/cfg.h    |  222 ++
 .../tidspbridge/include/dspbridge/cfgdefs.h        |   81 +
 .../staging/tidspbridge/include/dspbridge/chnl.h   |  130 +
 .../tidspbridge/include/dspbridge/chnldefs.h       |   67 +
 .../tidspbridge/include/dspbridge/chnlpriv.h       |  101 +
 .../staging/tidspbridge/include/dspbridge/clk.h    |  101 +
 .../staging/tidspbridge/include/dspbridge/cmm.h    |  386 +++
 .../tidspbridge/include/dspbridge/cmmdefs.h        |  105 +
 .../staging/tidspbridge/include/dspbridge/cod.h    |  369 +++
 .../staging/tidspbridge/include/dspbridge/dbc.h    |   46 +
 .../staging/tidspbridge/include/dspbridge/dbdcd.h  |  358 +++
 .../tidspbridge/include/dspbridge/dbdcddef.h       |   78 +
 .../staging/tidspbridge/include/dspbridge/dbdefs.h |  546 ++++
 .../tidspbridge/include/dspbridge/dbldefs.h        |  140 +
 .../staging/tidspbridge/include/dspbridge/dbll.h   |   59 +
 .../tidspbridge/include/dspbridge/dblldefs.h       |  496 +++
 .../staging/tidspbridge/include/dspbridge/dbtype.h |   88 +
 .../tidspbridge/include/dspbridge/dehdefs.h        |   32 +
 .../staging/tidspbridge/include/dspbridge/dev.h    |  702 +++++
 .../tidspbridge/include/dspbridge/devdefs.h        |   26 +
 .../staging/tidspbridge/include/dspbridge/disp.h   |  204 ++
 .../tidspbridge/include/dspbridge/dispdefs.h       |   35 +
 .../staging/tidspbridge/include/dspbridge/dmm.h    |   75 +
 .../staging/tidspbridge/include/dspbridge/drv.h    |  522 ++++
 .../tidspbridge/include/dspbridge/drvdefs.h        |   25 +
 .../tidspbridge/include/dspbridge/dspapi-ioctl.h   |  475 +++
 .../staging/tidspbridge/include/dspbridge/dspapi.h |  167 +
 .../tidspbridge/include/dspbridge/dspchnl.h        |   72 +
 .../tidspbridge/include/dspbridge/dspdefs.h        | 1128 +++++++
 .../staging/tidspbridge/include/dspbridge/dspdeh.h |   47 +
 .../staging/tidspbridge/include/dspbridge/dspdrv.h |   62 +
 .../staging/tidspbridge/include/dspbridge/dspio.h  |   41 +
 .../tidspbridge/include/dspbridge/dspioctl.h       |   73 +
 .../staging/tidspbridge/include/dspbridge/dspmsg.h |   56 +
 .../tidspbridge/include/dspbridge/dynamic_loader.h |  492 +++
 drivers/staging/tidspbridge/include/dspbridge/gb.h |   79 +
 .../tidspbridge/include/dspbridge/getsection.h     |  108 +
 drivers/staging/tidspbridge/include/dspbridge/gh.h |   32 +
 drivers/staging/tidspbridge/include/dspbridge/gs.h |   59 +
 .../tidspbridge/include/dspbridge/host_os.h        |   89 +
 drivers/staging/tidspbridge/include/dspbridge/io.h |  114 +
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |  309 ++
 .../staging/tidspbridge/include/dspbridge/iodefs.h |   36 +
 .../staging/tidspbridge/include/dspbridge/ldr.h    |   29 +
 .../staging/tidspbridge/include/dspbridge/list.h   |  225 ++
 .../staging/tidspbridge/include/dspbridge/mbx_sh.h |  198 ++
 .../tidspbridge/include/dspbridge/memdefs.h        |   30 +
 .../staging/tidspbridge/include/dspbridge/mgr.h    |  205 ++
 .../tidspbridge/include/dspbridge/mgrpriv.h        |   45 +
 .../staging/tidspbridge/include/dspbridge/msg.h    |   86 +
 .../tidspbridge/include/dspbridge/msgdefs.h        |   29 +
 .../staging/tidspbridge/include/dspbridge/nldr.h   |   55 +
 .../tidspbridge/include/dspbridge/nldrdefs.h       |  293 ++
 .../staging/tidspbridge/include/dspbridge/node.h   |  579 ++++
 .../tidspbridge/include/dspbridge/nodedefs.h       |   28 +
 .../tidspbridge/include/dspbridge/nodepriv.h       |  182 ++
 .../staging/tidspbridge/include/dspbridge/ntfy.h   |  217 ++
 .../staging/tidspbridge/include/dspbridge/proc.h   |  621 ++++
 .../tidspbridge/include/dspbridge/procpriv.h       |   25 +
 .../staging/tidspbridge/include/dspbridge/pwr.h    |  107 +
 .../staging/tidspbridge/include/dspbridge/pwr_sh.h |   33 +
 .../include/dspbridge/resourcecleanup.h            |   63 +
 .../staging/tidspbridge/include/dspbridge/rmm.h    |  181 ++
 .../staging/tidspbridge/include/dspbridge/rms_sh.h |   95 +
 .../tidspbridge/include/dspbridge/rmstypes.h       |   28 +
 .../tidspbridge/include/dspbridge/services.h       |   50 +
 .../staging/tidspbridge/include/dspbridge/std.h    |   94 +
 .../staging/tidspbridge/include/dspbridge/strm.h   |  404 +++
 .../tidspbridge/include/dspbridge/strmdefs.h       |   46 +
 .../staging/tidspbridge/include/dspbridge/sync.h   |  109 +
 .../tidspbridge/include/dspbridge/utildefs.h       |   39 +
 .../tidspbridge/include/dspbridge/uuidutil.h       |   62 +
 .../staging/tidspbridge/include/dspbridge/wdt.h    |   79 +
 drivers/staging/tidspbridge/pmgr/chnl.c            |  163 +
 drivers/staging/tidspbridge/pmgr/chnlobj.h         |   46 +
 drivers/staging/tidspbridge/pmgr/cmm.c             | 1172 +++++++
 drivers/staging/tidspbridge/pmgr/cod.c             |  658 ++++
 drivers/staging/tidspbridge/pmgr/dbll.c            | 1585 ++++++++++
 drivers/staging/tidspbridge/pmgr/dev.c             | 1171 +++++++
 drivers/staging/tidspbridge/pmgr/dmm.c             |  533 ++++
 drivers/staging/tidspbridge/pmgr/dspapi.c          | 1685 ++++++++++
 drivers/staging/tidspbridge/pmgr/io.c              |  142 +
 drivers/staging/tidspbridge/pmgr/ioobj.h           |   38 +
 drivers/staging/tidspbridge/pmgr/msg.c             |  129 +
 drivers/staging/tidspbridge/pmgr/msgobj.h          |   38 +
 drivers/staging/tidspbridge/rmgr/dbdcd.c           | 1506 +++++++++
 drivers/staging/tidspbridge/rmgr/disp.c            |  754 +++++
 drivers/staging/tidspbridge/rmgr/drv.c             | 1047 +++++++
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |  644 ++++
 drivers/staging/tidspbridge/rmgr/drv_interface.h   |   27 +
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |  142 +
 drivers/staging/tidspbridge/rmgr/mgr.c             |  374 +++
 drivers/staging/tidspbridge/rmgr/nldr.c            | 1999 ++++++++++++
 drivers/staging/tidspbridge/rmgr/node.c            | 3231 ++++++++++++++++++++
 drivers/staging/tidspbridge/rmgr/proc.c            | 1948 ++++++++++++
 drivers/staging/tidspbridge/rmgr/pwr.c             |  182 ++
 drivers/staging/tidspbridge/rmgr/rmm.c             |  535 ++++
 drivers/staging/tidspbridge/rmgr/strm.c            |  861 ++++++
 drivers/staging/tidspbridge/services/cfg.c         |  253 ++
 drivers/staging/tidspbridge/services/ntfy.c        |   31 +
 drivers/staging/tidspbridge/services/services.c    |   69 +
 drivers/staging/tidspbridge/services/sync.c        |  104 +
 152 files changed, 51105 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/tidspbridge/Documentation/CONTRIBUTORS
 create mode 100644 drivers/staging/tidspbridge/Documentation/README
 create mode 100644 drivers/staging/tidspbridge/Documentation/error-codes
 create mode 100644 drivers/staging/tidspbridge/Kconfig
 create mode 100644 drivers/staging/tidspbridge/Makefile
 create mode 100644 drivers/staging/tidspbridge/TODO
 create mode 100644 drivers/staging/tidspbridge/core/_cmm.h
 create mode 100644 drivers/staging/tidspbridge/core/_deh.h
 create mode 100644 drivers/staging/tidspbridge/core/_msg_sm.h
 create mode 100644 drivers/staging/tidspbridge/core/_tiomap.h
 create mode 100644 drivers/staging/tidspbridge/core/_tiomap_pwr.h
 create mode 100644 drivers/staging/tidspbridge/core/chnl_sm.c
 create mode 100644 drivers/staging/tidspbridge/core/dsp-clock.c
 create mode 100644 drivers/staging/tidspbridge/core/io_sm.c
 create mode 100644 drivers/staging/tidspbridge/core/mmu_fault.c
 create mode 100644 drivers/staging/tidspbridge/core/mmu_fault.h
 create mode 100644 drivers/staging/tidspbridge/core/msg_sm.c
 create mode 100644 drivers/staging/tidspbridge/core/tiomap3430.c
 create mode 100644 drivers/staging/tidspbridge/core/tiomap3430_pwr.c
 create mode 100644 drivers/staging/tidspbridge/core/tiomap_io.c
 create mode 100644 drivers/staging/tidspbridge/core/tiomap_io.h
 create mode 100644 drivers/staging/tidspbridge/core/ue_deh.c
 create mode 100644 drivers/staging/tidspbridge/core/wdt.c
 create mode 100644 drivers/staging/tidspbridge/dynload/cload.c
 create mode 100644 drivers/staging/tidspbridge/dynload/dload_internal.h
 create mode 100644 drivers/staging/tidspbridge/dynload/doff.h
 create mode 100644 drivers/staging/tidspbridge/dynload/getsection.c
 create mode 100644 drivers/staging/tidspbridge/dynload/header.h
 create mode 100644 drivers/staging/tidspbridge/dynload/module_list.h
 create mode 100644 drivers/staging/tidspbridge/dynload/params.h
 create mode 100644 drivers/staging/tidspbridge/dynload/reloc.c
 create mode 100644 drivers/staging/tidspbridge/dynload/reloc_table.h
 create mode 100644 drivers/staging/tidspbridge/dynload/reloc_table_c6000.c
 create mode 100644 drivers/staging/tidspbridge/dynload/tramp.c
 create mode 100644 drivers/staging/tidspbridge/dynload/tramp_table_c6000.c
 create mode 100644 drivers/staging/tidspbridge/gen/gb.c
 create mode 100644 drivers/staging/tidspbridge/gen/gh.c
 create mode 100644 drivers/staging/tidspbridge/gen/gs.c
 create mode 100644 drivers/staging/tidspbridge/gen/uuidutil.c
 create mode 100644 drivers/staging/tidspbridge/hw/EasiGlobal.h
 create mode 100644 drivers/staging/tidspbridge/hw/GlobalTypes.h
 create mode 100644 drivers/staging/tidspbridge/hw/MMUAccInt.h
 create mode 100644 drivers/staging/tidspbridge/hw/MMURegAcM.h
 create mode 100644 drivers/staging/tidspbridge/hw/hw_defs.h
 create mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.c
 create mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/_chnl_sm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/brddefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/cfg.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/chnl.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/chnldefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/chnlpriv.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/clk.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/cmm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/cmmdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/cod.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbc.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbdcd.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbdcddef.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbldefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbll.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbtype.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dehdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dev.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/devdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/disp.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dispdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dmm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/drv.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/drvdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspapi-ioctl.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspapi.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspchnl.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspdeh.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspdrv.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspio.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspioctl.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspmsg.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dynamic_loader.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/gb.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/getsection.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/gh.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/gs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/host_os.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/io.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/io_sm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/iodefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/ldr.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/list.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/mbx_sh.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/memdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/mgr.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/mgrpriv.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/msg.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/msgdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/nldr.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/node.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/nodedefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/nodepriv.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/ntfy.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/proc.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/procpriv.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/pwr.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/pwr_sh.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/resourcecleanup.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/rmm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/rms_sh.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/rmstypes.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/services.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/std.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/strm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/strmdefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/sync.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/utildefs.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/uuidutil.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/wdt.h
 create mode 100644 drivers/staging/tidspbridge/pmgr/chnl.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/chnlobj.h
 create mode 100644 drivers/staging/tidspbridge/pmgr/cmm.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/cod.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/dbll.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/dev.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/dmm.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/dspapi.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/io.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/ioobj.h
 create mode 100644 drivers/staging/tidspbridge/pmgr/msg.c
 create mode 100644 drivers/staging/tidspbridge/pmgr/msgobj.h
 create mode 100644 drivers/staging/tidspbridge/rmgr/dbdcd.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/disp.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/drv.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/drv_interface.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/drv_interface.h
 create mode 100644 drivers/staging/tidspbridge/rmgr/dspdrv.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/mgr.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/nldr.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/node.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/proc.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/pwr.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/rmm.c
 create mode 100644 drivers/staging/tidspbridge/rmgr/strm.c
 create mode 100644 drivers/staging/tidspbridge/services/cfg.c
 create mode 100644 drivers/staging/tidspbridge/services/ntfy.c
 create mode 100644 drivers/staging/tidspbridge/services/services.c
 create mode 100644 drivers/staging/tidspbridge/services/sync.c


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1BDVLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:11:05 -0500
Received: from kroah.org ([198.145.64.141]:36638 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1BDVLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:11:03 -0500
Date: Fri, 4 Feb 2011 13:10:32 -0800
From: Greg KH <greg@kroah.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel <devel@driverdev.osuosl.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        lk <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] staging: tidspbridge for 2.6.39
Message-ID: <20110204211032.GA14525@kroah.com>
References: <1296591184-31554-1-git-send-email-omar.ramirez@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296591184-31554-1-git-send-email-omar.ramirez@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 02:13:04PM -0600, Omar Ramirez Luna wrote:
> The following changes since commit c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470:
> 
>   Linux 2.6.38-rc1 (2011-01-18 15:14:02 -0800)
> 
> are available in the git repository at:
>   git://dev.omapzoom.org/pub/scm/tidspbridge/kernel-dspbridge.git tidspbridge-for-2.6.39
> 
> Armando Uribe (6):
>       staging: tidspbridge: Eliminate direct manipulation of OMAP_SYSC_BASE
>       staging: tidspbridge: Remove unused defined constants
>       staging: tidspbridge: Remove unused functions
>       staging: tidspbridge: Remove unused structs
>       staging: tidspbridge: Remove unused typedefs
>       staging: tidspbridge: Remove trivial header files
> 
> Felipe Contreras (1):
>       staging: tidspbridge: fix mgr_enum_node_info
> 
> Guzman Lugo, Fernando (2):
>       staging: tidspbridge: configure full L1 MMU range
>       staging: tidspbridge: make sync_wait_on_event interruptible
> 
> Ionut Nicu (13):
>       staging: tidspbridge: mgr_enum_node_info cleanup
>       staging: tidspbridge: fix kernel oops in bridge_io_get_proc_load
>       staging: tidspbridge: remove gs memory allocator
>       staging: tidspbridge: remove utildefs
>       staging: tidspbridge: switch to linux bitmap API
>       staging: tidspbridge: remove gb bitmap implementation
>       staging: tidspbridge: convert core to list_head
>       staging: tidspbridge: convert pmgr to list_head
>       staging: tidspbridge: convert rmgr to list_head
>       staging: tidspbridge: remove custom linked list
>       staging: tidspbridge: core code cleanup
>       staging: tidspbridge: pmgr code cleanup
>       staging: tidspbridge: rmgr/node.c code cleanup
> 
> Laurent Pinchart (1):
>       staging: tidspbridge: Fix atoi to support hexadecimal numbers correctly
> 
> Omar Ramirez Luna (2):
>       staging: tidspbridge: replace mbox callback with notifier_call
>       staging: tidspbridge: use the right type for list_is_last
> 
> Ramos Falcon, Ernesto (1):
>       staging: tidspbridge: remove code referred by OPT_ZERO_COPY_LOADER
> 
> Rene Sapiens (12):
>       staging: tidspbridge: set1 remove hungarian from structs
>       staging: tidspbridge: set2 remove hungarian from structs
>       staging: tidspbridge: set3 remove hungarian from structs
>       staging: tidspbridge: set4 remove hungarian from structs
>       staging: tidspbridge: set5 remove hungarian from structs
>       staging: tidspbridge: set6 remove hungarian from structs
>       staging: tidspbridge: set7 remove hungarian from structs
>       staging: tidspbridge: set8 remove hungarian from structs
>       staging: tidspbridge: set9 remove hungarian from structs
>       staging: tidspbridge: set10 remove hungarian from structs
>       staging: tidspbridge: set11 remove hungarian from structs
>       staging: tidspbridge: set12 remove hungarian from structs
> 
> Sapiens, Rene (1):
>       staging: tidspbridge: overwrite DSP error codes
> 
>  drivers/staging/tidspbridge/Makefile               |    2 +-
>  drivers/staging/tidspbridge/TODO                   |    1 -
>  drivers/staging/tidspbridge/core/_deh.h            |    2 +-
>  drivers/staging/tidspbridge/core/_msg_sm.h         |   16 +-
>  drivers/staging/tidspbridge/core/_tiomap.h         |   30 +-
>  drivers/staging/tidspbridge/core/chnl_sm.c         |  676 ++++++-------
>  drivers/staging/tidspbridge/core/dsp-clock.c       |   52 +-
>  drivers/staging/tidspbridge/core/io_sm.c           |  680 ++++++-------
>  drivers/staging/tidspbridge/core/msg_sm.c          |  619 +++++-------
>  drivers/staging/tidspbridge/core/tiomap3430.c      |  214 ++--
>  drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |  112 +-
>  drivers/staging/tidspbridge/core/tiomap_io.c       |   96 +-
>  drivers/staging/tidspbridge/core/ue_deh.c          |   28 +-
>  drivers/staging/tidspbridge/dynload/cload.c        |  102 +--
>  .../staging/tidspbridge/dynload/dload_internal.h   |    6 +-
>  drivers/staging/tidspbridge/gen/gb.c               |  166 ---
>  drivers/staging/tidspbridge/gen/gh.c               |   38 +-
>  drivers/staging/tidspbridge/gen/gs.c               |   88 --
>  drivers/staging/tidspbridge/gen/uuidutil.c         |   22 +-
>  .../tidspbridge/include/dspbridge/_chnl_sm.h       |   26 +-
>  .../tidspbridge/include/dspbridge/brddefs.h        |    2 -
>  .../tidspbridge/include/dspbridge/cfgdefs.h        |   50 +-
>  .../staging/tidspbridge/include/dspbridge/chnl.h   |   21 -
>  .../tidspbridge/include/dspbridge/chnldefs.h       |    9 +-
>  .../tidspbridge/include/dspbridge/chnlpriv.h       |   21 +-
>  .../staging/tidspbridge/include/dspbridge/cmm.h    |    2 +-
>  .../tidspbridge/include/dspbridge/cmmdefs.h        |   39 +-
>  .../staging/tidspbridge/include/dspbridge/cod.h    |   13 +-
>  .../tidspbridge/include/dspbridge/dbdcddef.h       |   14 +-
>  .../staging/tidspbridge/include/dspbridge/dbdefs.h |   98 +--
>  .../tidspbridge/include/dspbridge/dbldefs.h        |  141 ---
>  .../staging/tidspbridge/include/dspbridge/dbll.h   |    6 -
>  .../tidspbridge/include/dspbridge/dblldefs.h       |   65 --
>  .../tidspbridge/include/dspbridge/dehdefs.h        |   32 -
>  .../staging/tidspbridge/include/dspbridge/dev.h    |   65 +--
>  .../staging/tidspbridge/include/dspbridge/disp.h   |   15 +-
>  .../tidspbridge/include/dspbridge/dispdefs.h       |   35 -
>  .../staging/tidspbridge/include/dspbridge/drv.h    |   40 +-
>  .../tidspbridge/include/dspbridge/drvdefs.h        |   25 -
>  .../tidspbridge/include/dspbridge/dspapi-ioctl.h   |  216 ++--
>  .../tidspbridge/include/dspbridge/dspdefs.h        |   88 +-
>  .../staging/tidspbridge/include/dspbridge/dspdrv.h |    2 -
>  .../staging/tidspbridge/include/dspbridge/dspio.h  |    4 +-
>  .../tidspbridge/include/dspbridge/dspioctl.h       |   13 +-
>  .../tidspbridge/include/dspbridge/dynamic_loader.h |    2 -
>  drivers/staging/tidspbridge/include/dspbridge/gb.h |   79 --
>  drivers/staging/tidspbridge/include/dspbridge/gs.h |   59 --
>  .../tidspbridge/include/dspbridge/host_os.h        |    9 -
>  drivers/staging/tidspbridge/include/dspbridge/io.h |   29 +-
>  .../staging/tidspbridge/include/dspbridge/io_sm.h  |  164 +---
>  .../staging/tidspbridge/include/dspbridge/iodefs.h |   36 -
>  .../staging/tidspbridge/include/dspbridge/ldr.h    |   29 -
>  .../staging/tidspbridge/include/dspbridge/list.h   |  225 ----
>  .../staging/tidspbridge/include/dspbridge/mbx_sh.h |   40 -
>  .../tidspbridge/include/dspbridge/mgrpriv.h        |    4 +-
>  .../tidspbridge/include/dspbridge/nldrdefs.h       |   24 +-
>  .../staging/tidspbridge/include/dspbridge/node.h   |   20 +-
>  .../tidspbridge/include/dspbridge/nodepriv.h       |   10 +-
>  .../staging/tidspbridge/include/dspbridge/pwr.h    |    8 +-
>  .../staging/tidspbridge/include/dspbridge/pwr_sh.h |   33 -
>  .../include/dspbridge/resourcecleanup.h            |   11 -
>  .../staging/tidspbridge/include/dspbridge/rms_sh.h |    9 -
>  .../staging/tidspbridge/include/dspbridge/strm.h   |   62 --
>  .../tidspbridge/include/dspbridge/strmdefs.h       |    6 +-
>  .../staging/tidspbridge/include/dspbridge/sync.h   |   14 +-
>  .../tidspbridge/include/dspbridge/utildefs.h       |   39 -
>  drivers/staging/tidspbridge/pmgr/chnl.c            |    4 +-
>  drivers/staging/tidspbridge/pmgr/cmm.c             |  675 +++++-------
>  drivers/staging/tidspbridge/pmgr/cod.c             |   20 +-
>  drivers/staging/tidspbridge/pmgr/dbll.c            |   53 +-
>  drivers/staging/tidspbridge/pmgr/dev.c             |  355 +++----
>  drivers/staging/tidspbridge/pmgr/dspapi.c          |  272 +++---
>  drivers/staging/tidspbridge/pmgr/io.c              |    9 +-
>  drivers/staging/tidspbridge/pmgr/ioobj.h           |    4 +-
>  drivers/staging/tidspbridge/pmgr/msg.c             |    4 +-
>  drivers/staging/tidspbridge/rmgr/dbdcd.c           |   66 +-
>  drivers/staging/tidspbridge/rmgr/disp.c            |  124 +--
>  drivers/staging/tidspbridge/rmgr/drv.c             |  202 ++---
>  drivers/staging/tidspbridge/rmgr/drv_interface.c   |    1 -
>  drivers/staging/tidspbridge/rmgr/mgr.c             |   66 +-
>  drivers/staging/tidspbridge/rmgr/nldr.c            |  117 +--
>  drivers/staging/tidspbridge/rmgr/node.c            | 1092 +++++++++-----------
>  drivers/staging/tidspbridge/rmgr/proc.c            |  170 ++--
>  drivers/staging/tidspbridge/rmgr/pwr.c             |    8 +-
>  drivers/staging/tidspbridge/rmgr/rmm.c             |   93 +--
>  drivers/staging/tidspbridge/rmgr/strm.c            |   86 +-
>  86 files changed, 3028 insertions(+), 5297 deletions(-)

Something's wrong here, I got:

 86 files changed, 3009 insertions(+), 5272 deletions(-)

I do have:
[diff]
        renamelimit=0

in my .gitconfig file which might cause a difference if you are renaming
stuff.

Or did you add other patches to this tree that you didn't tell me about?

I'll drop this pull for now until this gets sorted out.

thanks,

greg k-h

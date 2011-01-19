Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1ASExg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 23:53:36 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:64137 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1ASExe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 23:53:34 -0500
Date: Tue, 18 Jan 2011 23:53:11 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] ACPICA patches for 2.6.38-merge
Message-id: <alpine.LFD.2.02.1101182351190.14668@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git acpica

bug fixes, annual copyright update.

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.37/acpi-acpica-20110112-2.6.37.diff.gz

 drivers/acpi/acpica/accommon.h  |    2 +-
 drivers/acpi/acpica/acconfig.h  |    2 +-
 drivers/acpi/acpica/acdebug.h   |    2 +-
 drivers/acpi/acpica/acdispat.h  |    2 +-
 drivers/acpi/acpica/acevents.h  |    2 +-
 drivers/acpi/acpica/acglobal.h  |    2 +-
 drivers/acpi/acpica/achware.h   |    2 +-
 drivers/acpi/acpica/acinterp.h  |    2 +-
 drivers/acpi/acpica/aclocal.h   |    2 +-
 drivers/acpi/acpica/acmacros.h  |    2 +-
 drivers/acpi/acpica/acnamesp.h  |    2 +-
 drivers/acpi/acpica/acobject.h  |   16 +++++++---
 drivers/acpi/acpica/acopcode.h  |    2 +-
 drivers/acpi/acpica/acparser.h  |    2 +-
 drivers/acpi/acpica/acpredef.h  |    2 +-
 drivers/acpi/acpica/acresrc.h   |    2 +-
 drivers/acpi/acpica/acstruct.h  |    2 +-
 drivers/acpi/acpica/actables.h  |    2 +-
 drivers/acpi/acpica/acutils.h   |    2 +-
 drivers/acpi/acpica/amlcode.h   |   10 +-----
 drivers/acpi/acpica/amlresrc.h  |    2 +-
 drivers/acpi/acpica/dsfield.c   |    2 +-
 drivers/acpi/acpica/dsinit.c    |    2 +-
 drivers/acpi/acpica/dsmethod.c  |   64 +++++++++++++++++++++++++++++----------
 drivers/acpi/acpica/dsmthdat.c  |    2 +-
 drivers/acpi/acpica/dsobject.c  |    2 +-
 drivers/acpi/acpica/dsopcode.c  |    2 +-
 drivers/acpi/acpica/dsutils.c   |    2 +-
 drivers/acpi/acpica/dswexec.c   |    2 +-
 drivers/acpi/acpica/dswload.c   |    2 +-
 drivers/acpi/acpica/dswscope.c  |    2 +-
 drivers/acpi/acpica/dswstate.c  |    2 +-
 drivers/acpi/acpica/evevent.c   |    2 +-
 drivers/acpi/acpica/evgpe.c     |    4 ++-
 drivers/acpi/acpica/evgpeblk.c  |    2 +-
 drivers/acpi/acpica/evgpeinit.c |    2 +-
 drivers/acpi/acpica/evgpeutil.c |    2 +-
 drivers/acpi/acpica/evmisc.c    |    2 +-
 drivers/acpi/acpica/evregion.c  |    2 +-
 drivers/acpi/acpica/evrgnini.c  |    6 ++--
 drivers/acpi/acpica/evsci.c     |    2 +-
 drivers/acpi/acpica/evxface.c   |    2 +-
 drivers/acpi/acpica/evxfevnt.c  |    2 +-
 drivers/acpi/acpica/evxfgpe.c   |    2 +-
 drivers/acpi/acpica/evxfregn.c  |    2 +-
 drivers/acpi/acpica/exconfig.c  |    2 +-
 drivers/acpi/acpica/exconvrt.c  |    2 +-
 drivers/acpi/acpica/excreate.c  |   10 +++---
 drivers/acpi/acpica/exdebug.c   |    2 +-
 drivers/acpi/acpica/exdump.c    |    4 +-
 drivers/acpi/acpica/exfield.c   |    2 +-
 drivers/acpi/acpica/exfldio.c   |    2 +-
 drivers/acpi/acpica/exmisc.c    |    2 +-
 drivers/acpi/acpica/exmutex.c   |    2 +-
 drivers/acpi/acpica/exnames.c   |    2 +-
 drivers/acpi/acpica/exoparg1.c  |    2 +-
 drivers/acpi/acpica/exoparg2.c  |    2 +-
 drivers/acpi/acpica/exoparg3.c  |    2 +-
 drivers/acpi/acpica/exoparg6.c  |    2 +-
 drivers/acpi/acpica/exprep.c    |    2 +-
 drivers/acpi/acpica/exregion.c  |    2 +-
 drivers/acpi/acpica/exresnte.c  |    2 +-
 drivers/acpi/acpica/exresolv.c  |    2 +-
 drivers/acpi/acpica/exresop.c   |    2 +-
 drivers/acpi/acpica/exstore.c   |    2 +-
 drivers/acpi/acpica/exstoren.c  |    2 +-
 drivers/acpi/acpica/exstorob.c  |    2 +-
 drivers/acpi/acpica/exsystem.c  |    2 +-
 drivers/acpi/acpica/exutils.c   |    2 +-
 drivers/acpi/acpica/hwacpi.c    |    2 +-
 drivers/acpi/acpica/hwgpe.c     |    2 +-
 drivers/acpi/acpica/hwpci.c     |    2 +-
 drivers/acpi/acpica/hwregs.c    |    2 +-
 drivers/acpi/acpica/hwsleep.c   |    2 +-
 drivers/acpi/acpica/hwtimer.c   |    2 +-
 drivers/acpi/acpica/hwvalid.c   |    2 +-
 drivers/acpi/acpica/hwxface.c   |    2 +-
 drivers/acpi/acpica/nsaccess.c  |    8 ++--
 drivers/acpi/acpica/nsalloc.c   |   15 +++++++--
 drivers/acpi/acpica/nsdump.c    |   17 ++++++++++-
 drivers/acpi/acpica/nsdumpdv.c  |    2 +-
 drivers/acpi/acpica/nseval.c    |    4 +-
 drivers/acpi/acpica/nsinit.c    |    2 +-
 drivers/acpi/acpica/nsload.c    |    2 +-
 drivers/acpi/acpica/nsnames.c   |    2 +-
 drivers/acpi/acpica/nsobject.c  |    2 +-
 drivers/acpi/acpica/nsparse.c   |    2 +-
 drivers/acpi/acpica/nspredef.c  |    2 +-
 drivers/acpi/acpica/nsrepair.c  |    2 +-
 drivers/acpi/acpica/nsrepair2.c |    2 +-
 drivers/acpi/acpica/nssearch.c  |    2 +-
 drivers/acpi/acpica/nsutils.c   |    2 +-
 drivers/acpi/acpica/nswalk.c    |    2 +-
 drivers/acpi/acpica/nsxfeval.c  |    2 +-
 drivers/acpi/acpica/nsxfname.c  |    7 ++--
 drivers/acpi/acpica/nsxfobj.c   |    2 +-
 drivers/acpi/acpica/psargs.c    |    2 +-
 drivers/acpi/acpica/psloop.c    |    4 +-
 drivers/acpi/acpica/psopcode.c  |    2 +-
 drivers/acpi/acpica/psparse.c   |   27 +++++-----------
 drivers/acpi/acpica/psscope.c   |    2 +-
 drivers/acpi/acpica/pstree.c    |    2 +-
 drivers/acpi/acpica/psutils.c   |    2 +-
 drivers/acpi/acpica/pswalk.c    |    2 +-
 drivers/acpi/acpica/psxface.c   |    9 ++---
 drivers/acpi/acpica/rsaddr.c    |    2 +-
 drivers/acpi/acpica/rscalc.c    |    2 +-
 drivers/acpi/acpica/rscreate.c  |    2 +-
 drivers/acpi/acpica/rsdump.c    |    2 +-
 drivers/acpi/acpica/rsinfo.c    |    2 +-
 drivers/acpi/acpica/rsio.c      |    2 +-
 drivers/acpi/acpica/rsirq.c     |    2 +-
 drivers/acpi/acpica/rslist.c    |    2 +-
 drivers/acpi/acpica/rsmemory.c  |    2 +-
 drivers/acpi/acpica/rsmisc.c    |    2 +-
 drivers/acpi/acpica/rsutils.c   |    2 +-
 drivers/acpi/acpica/rsxface.c   |    2 +-
 drivers/acpi/acpica/tbfadt.c    |    2 +-
 drivers/acpi/acpica/tbfind.c    |    2 +-
 drivers/acpi/acpica/tbinstal.c  |    2 +-
 drivers/acpi/acpica/tbutils.c   |    2 +-
 drivers/acpi/acpica/tbxface.c   |    2 +-
 drivers/acpi/acpica/tbxfroot.c  |    2 +-
 drivers/acpi/acpica/utalloc.c   |    2 +-
 drivers/acpi/acpica/utcopy.c    |    2 +-
 drivers/acpi/acpica/utdebug.c   |    2 +-
 drivers/acpi/acpica/utdelete.c  |    2 +-
 drivers/acpi/acpica/uteval.c    |    2 +-
 drivers/acpi/acpica/utglobal.c  |    2 +-
 drivers/acpi/acpica/utids.c     |    2 +-
 drivers/acpi/acpica/utinit.c    |    2 +-
 drivers/acpi/acpica/utlock.c    |    2 +-
 drivers/acpi/acpica/utmath.c    |    2 +-
 drivers/acpi/acpica/utmisc.c    |    2 +-
 drivers/acpi/acpica/utmutex.c   |    2 +-
 drivers/acpi/acpica/utobject.c  |    2 +-
 drivers/acpi/acpica/utosi.c     |    2 +-
 drivers/acpi/acpica/utresrc.c   |    2 +-
 drivers/acpi/acpica/utstate.c   |    2 +-
 drivers/acpi/acpica/utxface.c   |    2 +-
 drivers/acpi/acpica/utxferror.c |    2 +-
 include/acpi/acexcep.h          |    2 +-
 include/acpi/acnames.h          |    2 +-
 include/acpi/acoutput.h         |    2 +-
 include/acpi/acpi.h             |    2 +-
 include/acpi/acpiosxf.h         |    2 +-
 include/acpi/acpixf.h           |    4 +-
 include/acpi/acrestyp.h         |    2 +-
 include/acpi/actbl.h            |    2 +-
 include/acpi/actbl1.h           |    2 +-
 include/acpi/actbl2.h           |    2 +-
 include/acpi/actypes.h          |    2 +-
 include/acpi/platform/acenv.h   |    2 +-
 include/acpi/platform/acgcc.h   |    2 +-
 include/acpi/platform/aclinux.h |    2 +-
 155 files changed, 267 insertions(+), 220 deletions(-)

through these commits:

Bob Moore (3):
      ACPICA: Debugger: Lock namespace for duration of a namespace dump
      ACPICA: Update all ACPICA copyrights and signons to 2011
      ACPICA: Update version to 20110112

Dana Myers (1):
      ACPICA: Fix namespace race condition

Jesper Juhl (1):
      ACPICA: Fix memory leak in acpi_ev_asynch_execute_gpe_method().

Lin Ming (1):
      ACPICA: Fix issues/fault with automatic "serialized" method support

with this log:

commit 8d5f0a647395c1323787df675d2805cad54fc89f
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Jan 17 10:31:08 2011 +0800

    ACPICA: Update version to 20110112
    
    Version 20110112.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b4e104eaeb8cd4329a23e0e4ebf166681b1d182d
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Jan 17 11:05:40 2011 +0800

    ACPICA: Update all ACPICA copyrights and signons to 2011
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 262948428878fb340127faca1791acb17146122e
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed Jan 12 09:19:43 2011 +0800

    ACPICA: Fix issues/fault with automatic "serialized" method support
    
    History: This support changes a method to "serialized" on the fly if the
    method generates an AE_ALREADY_EXISTS error, indicating the possibility
    that it cannot handle reentrancy.
    
    This fix repairs a couple of issues seen in the field, especially on
    machines with many cores.
    
    1) Delete method children only upon the exit of the last thread, so
    as to not delete objects out from under running threads.
    
    2) Set the "serialized" bit for the method only upon the exit of the
    last thread, so as to not cause deadlock when running threads attempt
    to exit.
    
    3) Cleanup the use of the AML "MethodFlags" and internal method flags
    so that there is no longer any confustion between the two.
    
    Reported-by: Dana Myers <dana.myers@oracle.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 672af843abfc9a41c7ec792722e04b6c68a3cfea
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Jan 12 09:13:31 2011 +0800

    ACPICA: Debugger: Lock namespace for duration of a namespace dump
    
    Prevents issues if the namespace is changing underneath the
    debugger.  Especially temporary nodes, since the debugger displays
    these also.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Reviewed-by: Rafael Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5d3131f5b0ae6303d042fd91ed9147ad4ae4bf6d
Author: Dana Myers <dana.myers@oracle.com>
Date:   Wed Jan 12 09:09:31 2011 +0800

    ACPICA: Fix namespace race condition
    
    Fixes a race condition between method execution and namespace
    walks that can possibly fault. Problem was apparently introduced
    in version 20100528 as a result of a performance optimization
    that reduces the number of namespace walks upon method exit
    by using the delete_namespace_subtree function instead of the
    delete_namespace_by_owner function used previously. Bug is in
    the delete_namespace_subtree function.
    
    Signed-off-by: Dana Myers <dana.myers@oracle.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Reviewed-by: Rafael Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit be33b76a974cdb4ceadc1a12fb79cc97bcfeea37
Author: Jesper Juhl <jj@chaosbits.net>
Date:   Sun Jan 16 20:37:52 2011 +0100

    ACPICA: Fix memory leak in acpi_ev_asynch_execute_gpe_method().
    
    We will leak the memory allocated to 'local_gpe_event_info' if
    'acpi_ut_acquire_mutex()' fails or if 'acpi_ev_valid_gpe_event()' fails in
    drivers/acpi/acpica/evgpe.c::acpi_ev_asynch_execute_gpe_method().
    
    Signed-off-by: Jesper Juhl <jj@chaosbits.net>
    Reviewed-by: Rafael Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

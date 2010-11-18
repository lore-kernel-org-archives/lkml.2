Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928Ab0KRXwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:52:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49312 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758664Ab0KRXwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:52:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JODGmbWDq7GpR+ieRfg2PjC4iH7DhH+Mu3bPYMlzKwy/lz/ngA2BE1QWx9eTzW598L
         F0at3Y4o/TcefFDTEU634g8XXLWzJOxFK2iRyksEJmF6ig45CvcAOhKyYjrth0Cexv45
         mNUlEOE9mgee7O7OcGk+x+g93yX98uH6ZGqp4=
MIME-Version: 1.0
In-Reply-To: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
Date: Thu, 18 Nov 2010 18:52:43 -0500
Message-ID: <AANLkTimBJAKUEe3POB49DFSxqZzQAd03e_3Rn-0mP4wY@mail.gmail.com>
Subject: Re: 2.6.37-rc2-git4: Reported regressions from 2.6.36
From: Alex Deucher <alexdeucher@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 6:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message contains a list of some regressions from 2.6.36,
> for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
>
> If you know of any other unresolved regressions from 2.6.36, please let us
> know either and we'll add them to the list.  Also, please let us know
> if any of the entries below are invalid.
>
> Each entry from the list will be sent additionally in an automatic reply
> to this message with CCs to the people involved in reporting and handling
> the issue.
>
>
> Listed regressions statistics:
>
>  Date          Total  Pending  Unresolved
>  ----------------------------------------
>  2010-11-19       39       29          25
>
>
> Unresolved regressions
> ----------------------
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=23222
> Subject         : 2.6.36 radeon KMS: [drm] Cannot find any crtc or sizes
> Submitter       : Ján Bednár <jan.bednar@gmail.com>
> Date            : 2010-11-18 15:33 (1 days old)
>

I've added a fix to that bug.

Alex

>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=23142
> Subject         : autofs4 hang in 2.6.37-rc1
> Submitter       : Avi Kivity <avi@redhat.com>
> Date            : 2010-11-14 12:55 (5 days old)
> Message-ID      : <4CDFDC2B.6040205@redhat.com>
> References      : http://marc.info/?l=linux-kernel&m=128973936026185&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=23122
> Subject         : Regression in 2.6.37-rc1 for Intel 915 Graphics Adapter - bisected to commit e9e331a
> Submitter       : Larry Finger <Larry.Finger@lwfinger.net>
> Date            : 2010-11-11 1:47 (8 days old)
> Message-ID      : <4CDB4B1D.7000503@lwfinger.net>
> References      : http://marc.info/?l=linux-kernel&m=128944001311444&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=23102
> Subject         : [bisected] i915 regression in post 2.6.36 kernels
> Submitter       : Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
> Date            : 2010-11-10 7:02 (9 days old)
> Message-ID      : <201011100802.20332.johannes.hirte@fem.tu-ilmenau.de>
> References      : http://marc.info/?l=linux-kernel&m=128937310017057&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=23092
> Subject         : WARNING in tty_io.c
> Submitter       : Shan Wei <shanwei@cn.fujitsu.com>
> Date            : 2010-11-10 8:06 (9 days old)
> Message-ID      : <4CDA5291.4010802@cn.fujitsu.com>
> References      : http://marc.info/?l=linux-kernel&m=128937645120159&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=23012
> Subject         : ftdi_sio /dev/ttyUSB error:  "Resource Temporarily Unavailable"
> Submitter       : Kevin Smith <thirdwiggin@gmail.com>
> Date            : 2010-11-16 06:25 (3 days old)
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22942
> Subject         : [2.6.37-rc1, OOM] virtblk: OOM in do_virtblk_request()
> Submitter       : Dave Chinner <david@fromorbit.com>
> Date            : 2010-11-05 1:30 (14 days old)
> Message-ID      : <20101105013003.GE13830@dastard>
> References      : http://marc.info/?l=linux-kernel&m=128892062917641&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22912
> Subject         : spi_lm70llp module crash on unload (2.6.37-rc1)
> Submitter       : Randy Dunlap <randy.dunlap@oracle.com>
> Date            : 2010-11-05 0:16 (14 days old)
> Message-ID      : <20101104171620.00d8c95d.randy.dunlap@oracle.com>
> References      : http://marc.info/?l=linux-kernel&m=128891627913647&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22882
> Subject         : (2.6.37-rc1) amd64-agp module crashed on second load
> Submitter       : Randy Dunlap <randy.dunlap@oracle.com>
> Date            : 2010-11-05 0:13 (14 days old)
> Message-ID      : <20101104171333.fea1f498.randy.dunlap@oracle.com>
> References      : http://marc.info/?l=linux-kernel&m=128891605213447&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22812
> Subject         : kernel oops on 2.6.37-rc1
> Submitter       : Andrew <atswartz@gmail.com>
> Date            : 2010-11-12 16:05 (7 days old)
> First-Bad-Commit: http://git.kernel.org/linus/a68c439b1966c91f0ef474e2bf275d6792312726
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22692
> Subject         : [regression, 2.6.37-rc1] 'ip link tap0 up' stuck in do_exit()
> Submitter       : Dave Chinner <david@fromorbit.com>
> Date            : 2010-11-03 6:26 (16 days old)
> Message-ID      : <20101103062609.GB31163@dastard>
> References      : http://marc.info/?l=linux-kernel&m=128876560131870&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22682
> Subject         : [oops, 2.6.37-rc1] Unpacking initramfs failed, oops in free_init_pages()
> Submitter       : Dave Chinner <david@fromorbit.com>
> Date            : 2010-11-03 1:54 (16 days old)
> Message-ID      : <20101103015427.GA31163@dastard>
> References      : http://marc.info/?l=linux-kernel&m=128874930119723&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22672
> Subject         : Regression in 2.6.37-rc1 for Intel 945 Graphics Adapter - bisected to commit e9e331a
> Submitter       : Larry Finger <Larry.Finger@lwfinger.net>
> Date            : 2010-11-11 01:56 (8 days old)
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22652
> Subject         : [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> Submitter       : Tobias <devnull@plzk.org>
> Date            : 2010-11-10 21:59 (9 days old)
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22642
> Subject         : 2.6.37-rc1: Disk takes 10 seconds to resume - MacBook2,1
> Submitter       : Tobias <devnull@plzk.org>
> Date            : 2010-11-10 19:33 (9 days old)
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22572
> Subject         : Linux 2.6.37-rc1 (acpi_video)
> Submitter       : Randy Dunlap <randy.dunlap@oracle.com>
> Date            : 2010-11-02 18:51 (17 days old)
> Message-ID      : <20101102115106.bac57d21.randy.dunlap@oracle.com>
> References      : http://marc.info/?l=linux-kernel&m=128872403920449&w=2
>                  http://marc.info/?l=linux-acpi&m=128874714517914&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22562
> Subject         : Regression in 2.6.37-rc1 - logs spammed with "unable to enumerate USB port" - bisected to commit 3df7169e
> Submitter       : Larry Finger <Larry.Finger@lwfinger.net>
> Date            : 2010-11-02 22:32 (17 days old)
> First-Bad-Commit: http://git.kernel.org/linus/3df7169e73fc1d71a39cffeacc969f6840cdf52b
> Message-ID      : <4CD09166.4060202@lwfinger.net>
> References      : http://marc.info/?l=linux-kernel&m=128873713207906&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22552
> Subject         : AMD boot freeze bisected to b126b4703afa4010b161784a43650337676dd03b
> Submitter       : Borislav Petkov <bp@amd64.org>
> Date            : 2010-11-02 17:03 (17 days old)
> First-Bad-Commit: http://git.kernel.org/linus/b126b4703afa4010b161784a43650337676dd03b
> Message-ID      : <20101102170335.GC24927@aftab>
> References      : http://marc.info/?l=linux-kernel&m=128871752109913&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22542
> Subject         : [2.6.37-rc1] drm:i195 errors
> Submitter       : Paul Rolland <rol@witbe.net>
> Date            : 2010-11-02 14:58 (17 days old)
> Message-ID      : <20101102155813.09cb2c6e@tux.DEF.witbe.net>
> References      : http://marc.info/?l=linux-kernel&m=128870991628970&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22532
> Subject         : 2.6.37-rc1: BUG: scheduling while atomic (kvm_init)
> Submitter       : Thomas Meyer <thomas@m3y3r.de>
> Date            : 2010-11-02 19:06 (17 days old)
> Message-ID      : <50AA24C585B14210A44AB599605C7CBD@hugo>
> References      : http://marc.info/?l=linux-kernel&m=128872479921559&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22522
> Subject         : 2.6.37-rc1 boot Problem - BUG: unable to handle kernel null pointer - dmesg und config Datei
> Submitter       : werner <w.landgraf@ru.ru>
> Date            : 2010-11-02 2:09 (17 days old)
> Message-ID      : <web-395697375@zbackend1.aha.ru>
> References      : http://marc.info/?l=linux-kernel&m=128866380110940&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22472
> Subject         : vga_switcheroo fails to switch from intel to ati
> Submitter       : Radu Andries <admiral0@tuxfamily.org>
> Date            : 2010-11-08 16:46 (11 days old)
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22282
> Subject         : 2.6.37-rc1: WARNING..debugobjects: ODEBUG: free active (active state 0) object type: percpu_counter
> Submitter       : Randy Dunlap <randy.dunlap@oracle.com>
> Date            : 2010-11-01 21:58 (18 days old)
> Message-ID      : <4CCF37E8.1070208@oracle.com>
> References      : http://marc.info/?l=linux-kernel&m=128864879328429&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22102
> Subject         : [2.6.36-09452-g2d10d87] BUG: unable to handle kernel NULL pointer dereference at (null)
> Submitter       : Carlos R. Mafra <crmafra2@gmail.com>
> Date            : 2010-10-30 20:07 (20 days old)
> Message-ID      : <20101030200751.GA2866@Pilar.aei.mpg.de>
> References      : http://marc.info/?l=linux-kernel&m=128846935825136&w=2
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22082
> Subject         : 2.6.36-git11 -- kernel/pid.c:419 invoked rcu_dereference_check() without protection!
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2010-10-29 5:22 (21 days old)
> Message-ID      : <AANLkTimGgzOZb8EwUQO16cZcL+ycveKTYzg_AAX+D+Kw@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=128832975924288&w=2
>
>
> Regressions with patches
> ------------------------
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22962
> Subject         : building (e)glibc against 2.6.37-rc1 headers fails
> Submitter       :  <stephan@openelec.tv>
> Date            : 2010-11-15 00:09 (4 days old)
> Patch           : https://bugzilla.kernel.org/show_bug.cgi?id=22962#c5
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22932
> Subject         : [REGRESSION] [2.6.37-rc1] Fan noise after suspend to ram/disk
> Submitter       : Maciej Rutecki <maciej.rutecki@gmail.com>
> Date            : 2010-11-04 16:06 (15 days old)
> First-Bad-Commit: http://git.kernel.org/linus/3e384ee6c687cb397581ee8f9440fc8220cfac80
> Message-ID      : <201011041706.59046.maciej.rutecki@gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=128888684308982&w=2
> Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> Patch           : https://bugzilla.kernel.org/attachment.cgi?id=37372
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22722
> Subject         : regression since 2.6.36: backlight in sony-laptop not working
> Submitter       : Norbert Preining <preining@logic.at>
> Date            : 2010-11-04 14:29 (15 days old)
> Message-ID      : <20101104142915.GC7650@gamma.logic.tuwien.ac.at>
> References      : http://marc.info/?l=linux-kernel&m=128888097600601&w=2
> Handled-By      : Mattia Dongili <malattia@linux.it>
> Patch           : https://bugzilla.kernel.org/attachment.cgi?id=37442
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22662
> Subject         : divide error in select_task_rq_fair()
> Submitter       : Myron Stowe <myron.stowe@hp.com>
> Date            : 2010-11-10 23:58 (9 days old)
> Patch           : http://lkml.org/lkml/2010/11/13/176
>
>
> For details, please visit the bug entries and follow the links given in
> references.
>
> As you can see, there is a Bugzilla entry for each of the listed regressions.
> There also is a Bugzilla entry used for tracking the regressions from 2.6.36,
> unresolved as well as resolved, at:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=21782
>
> Please let the tracking team know if there are any Bugzilla entries that
> should be added to the list in there.
>
> Thanks!
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1KVFtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 00:49:52 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:56620 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1KVFtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 00:49:49 -0500
Message-ID: <4ECB37E4.6020204@linux.vnet.ibm.com>
Date: Tue, 22 Nov 2011 11:19:24 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 3.2-rc2+: Reported regressions from 3.0 and 3.1
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera> <201111212249.31196.rjw@sisk.pl>
In-Reply-To: <201111212249.31196.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 11112205-4790-0000-0000-00000015D85D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 03:19 AM, Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 3.0 and 3.1
> for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
> 
> If you know of any other unresolved regressions from 3.0 and 3.1, please let us
> know either and we'll add them to the list.  Also, please let us know if any of
> the entries below are invalid.
> 
> The entries below are simplified and the statistics are not present due to the
> continuing Bugzilla outage.
> 
> Subject    : iwlagn is getting very shaky
> Submitter  : Norbert Preining <preining@logic.at>
> Date       : 2011-10-19 6:01
> Message-ID : 20111019060108.GA11588@gamma.logic.tuwien.ac.at
> References : http://marc.info/?l=linux-kernel&m=131914553920614&w=2
> 
> Subject    : Regression: "irqpoll" hasn't been working for me since March 16 IRQ
> Submitter  : Edward Donovan <edward.donovan@numble.net>
> Date       : 2011-10-19 22:09
> Message-ID : CADdbW+HXdCPfJu2RTF6zz+ujCmiu_dmZwL2iScuF53p=AaZ1Uw@mail.gmail.com
> References : http://marc.info/?l=linux-kernel&m=131914554220679&w=2
> 
> Subject    : Regression in 3.1 causes Xen to use wrong idle routine
> Submitter  : Stefan Bader <stefan.bader@canonical.com>
> Date       : 2011-10-26 10:24
> Message-ID : 4EA7DFD1.9060608@canonical.com
> References : http://marc.info/?l=linux-acpi&m=131962467924564&w=2
> 
> Subject    : 3.1+ iwlwifi lockup
> Submitter  : Dave Jones <davej@redhat.com>
> Date       : 2011-10-31 14:34
> Message-ID : 20111031143408.GA17152@redhat.com
> References : http://marc.info/?l=linux-kernel&m=132007169420160&w=2
> 
> Subject    : hugetlb oops on 3.1.0-rc8-devel
> Submitter  : Andy Lutomirski <luto@amacapital.net>
> Date       : 2011-11-01 22:20
> Message-ID : CALCETrW1mpVCz2tO5roaz1r6vnno+srHR-dHA6_pkRi2qiCfdw@mail.gmail.com
> References : http://marc.info/?l=linux-kernel&m=132018604426692&w=2
> 
> Subject    : Simultaneous cat and external keyboard input causing kernel panic
> Submitter  : Timo Jyrinki <timo.jyrinki@gmail.com>
> Date       : 2011-11-03 12:14
> Message-ID : CAJtFfxmovJHspHHKbvBVc4pw+u5mjGmUejCXEzdV+GqE=jVSOQ@mail.gmail.com
> References : http://marc.info/?l=linux-kernel&m=132032253903074&w=2
> 
> Subject    : Linus GIT - INFO: possible circular locking dependency detected
> Submitter  : Miles Lane <miles.lane@gmail.com>
> Date       : 2011-11-03 15:57
> Message-ID : CAHFgRy8S0xLfhZxTUOEH5A0PL_Fb79-0-gmbQ=9h2D-xMqt1hA@mail.gmail.com
> References : http://marc.info/?l=linux-kernel&m=132033587908426&w=2
> 
> Subject    : lockdep warning after aa6afca5bcab: "proc: fix races against execve() of /proc/PID/fd**"
> Submitter  : Ari Savolainen <ari.m.savolainen@gmail.com>
> Date       : 2011-11-08 3:47
> Message-ID : CAEbykaXYZEFhTgWMm2AfaWQ2SaXYuO_ypTnw+6AVWScOYSCuuw@mail.gmail.com
> References : http://marc.info/?l=linux-kernel&m=132072413125099&w=2
> 
> Subject    : DMA-API check_sync errors with 3.2
> Submitter  : Josh Boyer <jwboyer@redhat.com>
> Date       : 2011-11-08 17:31
> Message-ID : 20111108173153.GE14216@zod.bos.redhat.com
> References : http://marc.info/?l=linux-kernel&m=132077357608797&w=2
> 
> Subject    : [3.1-rc8 REGRESSION] sky2 hangs machine on turning off or suspending
> Submitter  : Rafał Miłecki <zajec5@gmail.com>
> Date       : 2011-11-09 11:46
> Message-ID : CACna6ryTdLcWVYgHu=_mRFga1sFivpE_DyZOY-HMmKggkWAJAw@mail.gmail.com
> References : http://marc.info/?l=linux-netdev&m=132083922228088&w=4
> 
> Subject    : 3.2-rc1 doesn't boot on dual socket opteron without swap
> Submitter  : Niklas Schnelle <niklas@komani.de>
> Date       : 2011-11-10 20:09
> Message-ID : 1320955769.1718.8.camel@jupiter
> References : http://marc.info/?l=linux-kernel&m=132095583501767&w=2
> 
> Subject    : Sparc-32 doesn't work in 3.1.
> Submitter  : Rob Landley <rob@landley.net>
> Date       : 2011-11-12 11:22
> Message-ID : 4EBEAB5A.5020809@landley.net
> References : http://www.spinics.net/lists/kernel/msg1260383.html
> 
> Subject    : khugepaged blocks suspend2ram (3.2.0-rc1-00252-g8f042aa)
> Submitter  : Sergei Trofimovich <slyich@gmail.com>
> Date       : 2011-11-12 10:48
> Message-ID : 20111112104859.7744b282@sf.home
> References : https://lkml.org/lkml/2011/11/12/11
> 

Andrea's patch already fixes this issue, which was reported first by
Jiri Slaby. https://lkml.org/lkml/2011/11/11/93
I remember Andrew Morton taking this patch in his -mm tree. But it is
not in mainline yet. So can we consider this closed or not?

Thanks,
Srivatsa S. Bhat


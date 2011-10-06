Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935463Ab1JFIep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 04:34:45 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34931 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab1JFIeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 04:34:44 -0400
Date: Thu, 6 Oct 2011 10:34:39 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@amd64.org>,
        Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
Message-ID: <20111006083439.GA21575@aftab>
References: <20111002195023.GC31799@mtj.dyndns.org>
 <201110052226.58373.rjw@sisk.pl>
 <4E8CC8FA.2090100@linux.vnet.ibm.com>
 <201110060043.19583.rjw@sisk.pl>
 <4E8D4FC6.1080204@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8D4FC6.1080204@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 02:50:46AM -0400, Srivatsa S. Bhat wrote:
> On 10/06/2011 04:13 AM, Rafael J. Wysocki wrote:
> > On Wednesday, October 05, 2011, Srivatsa S. Bhat wrote:
> >> On 10/06/2011 01:56 AM, Rafael J. Wysocki wrote:
> >>>
> >>> OK, can you please repost the patch with Borislav's Acked-by and Tested-by
> >>> and add some more Intel people to the CC list?
> >>>
> >>
> >> Sure, I'll do that. Thank you.
> >> But are we not going to consider a cleaner/correct solution such as the
> >> one proposed here:
> >> http://permalink.gmane.org/gmane.linux.kernel/1199494
> >>
> >> Well, honestly I don't mean to be stubborn, but somehow, knowing that
> >> there are issues with my patch doesn't make me feel very comfortable
> >> going with it, especially when there is another approach, which I
> >> believe can fix the issue properly, without undesirable side-effects.
> >>
> >> I agree that the issues are mostly some corner cases, so if you want a
> >> quick fix for now, I guess we can go with this patch and then later on
> >> follow-up with a proper solution to this whole problem.
> > 
> > It ultimately is your call.  If you feel more comfortable with the
> > alternative, just post that one instead.
> > 
> Cool! I am working on implementing that other solution. I'll post it as soon
> as I am done writing and testing that patch.

Please test your other patch which removes the CPU_DEAD line from the
microcode CPU hotplug callback on an Intel box with microcode too and
submit it. This fix makes sense irrespective of a suspend/resume fix
because reloading the ucode when onlining the CPU is clearly unneeded.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

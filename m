Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1JJVQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:16:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59957 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab1JJVQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:16:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH RESEND] CPU hotplug,x86 Microcode: Don't request microcode from userspace unnecessarily
Date: Mon, 10 Oct 2011 23:18:26 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "amd64-microcode@amd64.org" <amd64-microcode@amd64.org>,
        Tejun Heo <tj@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4E90B6F9.8020804@linux.vnet.ibm.com> <201110102258.02628.rjw@sisk.pl> <20111010211300.GA31606@aftab>
In-Reply-To: <20111010211300.GA31606@aftab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110102318.27146.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 10, 2011, Borislav Petkov wrote:
> On Mon, Oct 10, 2011 at 04:58:02PM -0400, Rafael J. Wysocki wrote:
> > On Sunday, October 09, 2011, Srivatsa S. Bhat wrote:
> > > Requesting the microcode from userspace *every time* when onlining CPUs
> > > (during a CPU hotplug operation) is unnecessary.
> > > 
> > > So, this patch ensures that once the kernel gets the microcode after booting,
> > > it is not freed nor invalidated when a CPU goes offline, so that it can be
> > > reused when that CPU comes back online, without requesting userspace for it
> > > again. As a result, the CPU hotplug operations become faster as well.
> > > 
> > > Tested-by: Borislav Petkov <bp@amd64.org>
> > > Acked-by: Borislav Petkov <bp@amd64.org>
> > > 
> > > Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > 
> > Fine by me.  I wonder who should take this?
> 
> Ingo, most probably. ucode stuff goes in through -tip.

OK, so

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Thanks,
Rafael

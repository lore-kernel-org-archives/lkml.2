Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab1CVUc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:32:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57534 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab1CVUc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:32:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/6] Do not use sysdevs for implementing "core" PM operations on x86
Date: Tue, 22 Mar 2011 21:33:13 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        cpufreq@vger.kernel.org
References: <201103100131.58206.rjw@sisk.pl> <201103220031.22729.rjw@sisk.pl> <20110322103258.GC4448@elte.hu>
In-Reply-To: <20110322103258.GC4448@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103222133.14054.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 22, 2011, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > If there are no objectsions, I'd like to push these patches through the suspend
> > > tree.
> > 
> > [1/8] has been merged in the meantime and [3/8] has been included into the
> > ACPI tree.  if there are no objections, I'm going to push the following
> > patches to Linus this week through the suspend-2.6 tree:
> > 
> > [1/6] - Convert sysdev users in arch/x86 to using struct syscore_ops.
> > 
> > [2/6] - Make timekeeping use struct syscore_ops for suspend/resume.
> >  
> > [3/6] - Make Intel IOMMU use struct syscore_ops for suspend/resume.
> > 
> > [4/6] - Make KVM use struct syscore_ops for suspend/resume.
> > 
> > [5/6] - Make cpufreq use struct syscore_ops for boot CPU suspend/resume.
> > 
> > [6/6] - Introduce config switch allowing architectures to skip sysdev
> >         suspend/resume/shutdown code.
> 
> The x86 bits look fine.
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks!

> The patches affect a lot of hardware so please make sure they are tested well 
> before pushing them to Linus :-)

I have tested the majority, but unfortunately I have no hardware to test
the Intel IOMMU patch on it.

Thanks,
Rafael

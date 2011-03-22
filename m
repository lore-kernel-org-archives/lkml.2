Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1CVKdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:33:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54665 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab1CVKd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:33:27 -0400
Date: Tue, 22 Mar 2011 11:32:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH 0/6] Do not use sysdevs for implementing "core" PM
 operations on x86
Message-ID: <20110322103258.GC4448@elte.hu>
References: <201103100131.58206.rjw@sisk.pl>
 <201103122212.40828.rjw@sisk.pl>
 <201103220031.22729.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103220031.22729.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > If there are no objectsions, I'd like to push these patches through the suspend
> > tree.
> 
> [1/8] has been merged in the meantime and [3/8] has been included into the
> ACPI tree.  if there are no objections, I'm going to push the following
> patches to Linus this week through the suspend-2.6 tree:
> 
> [1/6] - Convert sysdev users in arch/x86 to using struct syscore_ops.
> 
> [2/6] - Make timekeeping use struct syscore_ops for suspend/resume.
>  
> [3/6] - Make Intel IOMMU use struct syscore_ops for suspend/resume.
> 
> [4/6] - Make KVM use struct syscore_ops for suspend/resume.
> 
> [5/6] - Make cpufreq use struct syscore_ops for boot CPU suspend/resume.
> 
> [6/6] - Introduce config switch allowing architectures to skip sysdev
>         suspend/resume/shutdown code.

The x86 bits look fine.

Acked-by: Ingo Molnar <mingo@elte.hu>

The patches affect a lot of hardware so please make sure they are tested well 
before pushing them to Linus :-)

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab2HVKal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:30:41 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:30170 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab2HVKac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:30:32 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336348800"; 
   d="scan'208";a="14122459"
Date: Wed, 22 Aug 2012 11:30:09 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Thomas Gleixner <tglx@linutronix.de>
CC: Attilio Rao <attilio.rao@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v2 0/5] X86/XEN: Merge x86_init.paging.pagetable_setup_start
 and x86_init.paging.pagetable_setup_done setup functions and document its
 semantic
In-Reply-To: <alpine.LFD.2.02.1208212315330.2856@ionos>
Message-ID: <alpine.DEB.2.02.1208221129490.15568@kaball.uk.xensource.com>
References: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208212315330.2856@ionos>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Thomas Gleixner wrote:
> On Tue, 21 Aug 2012, Attilio Rao wrote:
> > Differences with v1:
> > - The patch serie is re-arranged in a way that it helps reviews, following
> >   a plan by Thomas Gleixner
> > - The PVOPS nomenclature is not used as it is not correct
> > - The front-end message is adjusted with feedback by Thomas Gleixner,
> >   Stefano Stabellini and Konrad Rzeszutek Wilk 
> 
> This is much simpler to read and review. Just have a look at the
> diffstats of the two series:
> 
>  6 files changed,  9 insertions(+),  8 deletions(-)
>  6 files changed, 11 insertions(+),  9 deletions(-)
>  5 files changed, 50 insertions(+),  2 deletions(-)
>  6 files changed,  2 insertions(+), 65 deletions(-)
>  1 files changed,  5 insertions(+),  0 deletions(-)
> 
> versus
> 
>  6 files changed, 10 insertions(+),  9 deletions(-)
>  6 files changed, 11 insertions(+), 11 deletions(-)
>  5 files changed,  3 insertions(+),  3 deletions(-)
>  6 files changed,  4 insertions(+), 20 deletions(-)
>  1 files changed,  5 insertions(+),  0 deletions(-)
> 
> The overall result is basically the same, but it's way simpler to look
> at obvious and well done patches than checking whether a subtle copy
> and paste bug happened in 3/5 of the first version. Copy and paste is
> the #1 cause for subtle bugs. :)
> 
> I'm waiting for the ack of Xen folks before taking it into tip.

They are OK by me. Konrad?

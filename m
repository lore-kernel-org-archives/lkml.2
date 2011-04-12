Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab1DLR6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:58:40 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:46195 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753409Ab1DLR6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:58:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Ocsi4HRdX4DL9d70QBItbR6I0BecydzKSxw10cCGxe8HRFKKC+r7aSu3ayGfFk4aC8tWameR68t3G6AzUBZ77IykD+nW5sB/yPco8PRZVku6gn2MfCRkiQ1ujK+m/1Vg;
Date: Tue, 12 Apr 2011 10:58:27 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH -v2] x86: Remove dma32_reserve_bootmem
Message-ID: <20110412105827.443bd56e@jbarnes-desktop>
In-Reply-To: <4DA491C6.90403@kernel.org>
References: <4D90CBE5.6090706@kernel.org>
	<20110412091145.2bc5e6a9@jbarnes-desktop>
	<4DA489F0.4000003@kernel.org>
	<20110412104716.5388849d@jbarnes-desktop>
	<4DA491C6.90403@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 10:54:14 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> On 04/12/2011 10:47 AM, Jesse Barnes wrote:
> > On Tue, 12 Apr 2011 10:20:48 -0700
> > Yinghai Lu<yinghai@kernel.org>  wrote:
> >
> >>
> >> That is workaround for holding dma32 buf when early bootmem could use up
> >> those range on system that have lots of RAM.
> >>
> >> Now x86 is using memblock, and even nobootmem wrapper do top-down allocation.
> >>
> >> So We could remove those not needed code now.
> >>
> >> -v2: rebase on pci-next
> >>
> >> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
> >>
> >
> > Hm, still didn't apply cleanly, I guess the patch got corrupted.  I
> > fixed it up by hand and applied to linux-next though, thanks.
> 
> sorry for that. looks like recent thunderbird upgrade convert TAB to space..

Thanks for checking.  I wonder why every mailer (and some MTAs!) feel
the need to molest message content so thoroughly...

-- 
Jesse Barnes, Intel Open Source Technology Center

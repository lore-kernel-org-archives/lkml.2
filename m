Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab0JJIVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 04:21:13 -0400
Received: from www.tglx.de ([62.245.132.106]:40801 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab0JJIVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 04:21:07 -0400
Date: Sun, 10 Oct 2010 10:20:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/47] Sparse irq rework
In-Reply-To: <4CB14B03.4000707@kernel.org>
Message-ID: <alpine.LFD.2.00.1010101008490.2413@localhost6.localdomain6>
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com> <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6>
 <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6> <4CACFC23.4080504@kernel.org> <alpine.LFD.2.00.1010070050410.17015@localhost6.localdomain6> <4CAD082B.40908@kernel.org> <4CAD1154.3080403@kernel.org> <alpine.LFD.2.00.1010070559480.17015@localhost6.localdomain6>
 <4CAD4EC3.5060809@kernel.org> <alpine.LFD.2.00.1010082346310.13094@localhost6.localdomain6> <alpine.LFD.2.00.1010082351450.13094@localhost6.localdomain6> <4CAFEEFA.1070000@kernel.org> <alpine.LFD.2.00.1010090758420.13094@localhost6.localdomain6>
 <4CB013CB.1040904@kernel.org> <alpine.LFD.2.00.1010091409450.2640@localhost6.localdomain6> <4CB14B03.4000707@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Oct 2010, Yinghai Lu wrote:

> On 10/09/2010 05:12 AM, Thomas Gleixner wrote:
> > On Sat, 9 Oct 2010, Yinghai Lu wrote:
> >> On 10/08/2010 11:10 PM, Thomas Gleixner wrote:
> >>>> [   59.449366] IP: [<ffffffff8147d715>] acpi_pci_irq_find_prt_entry+0x85/0xb1
> >>>
> >>> I can hardly see how this is related to the irq work.
> >>>
> >>>> [   71.076886] Pid: 1, comm: swapper Tainted: G        W   2.6.36-rc7-tip-yh-01944-ge8a4c5f-dirty #171      /Sun Fire x4800
> >>>> [   71.096947] RIP: 0010:[<ffffffff8141e232>]  [<ffffffff8141e232>] strcmp+0x4/0x21
> >>>
> >>> Ditto.
> >>
> >> don't know.
> >>
> >> but without merging your branch, those problems don't come out.
> >>
> >> only thing i can think about that you real free irq code could
> >> stress or expose other subsystem's bug etc.
> > 
> > The first crash is in early boot and that code just fiddles with acpi
> > internal stuff.
> > 
> 
> Need following patch. Please fold it into corresponding commit.

Thanks for spotting this !

	tglx

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab0JAUgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:36:40 -0400
Received: from www.tglx.de ([62.245.132.106]:34212 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab0JAUgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:36:38 -0400
Date: Fri, 1 Oct 2010 22:36:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 14/47] genirq: Implement a sane sparse_irq allocator
In-Reply-To: <4CA57173.5060803@kernel.org>
Message-ID: <alpine.LFD.2.00.1010012235230.14550@localhost6.localdomain6>
References: <20100930221351.682772535@linutronix.de> <20100930221739.858896807@linutronix.de> <4CA57173.5060803@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010, Yinghai Lu wrote:
> On 09/30/2010 04:15 PM, Thomas Gleixner wrote:
> > +static inline int
> > +irq_alloc_desc_at(unsigned int at, int node)
> > +{
> > +	return irq_alloc_descs(at, 0, 1, node);
> 
> need to change to 
> 
> 	return irq_alloc_descs(at, at, 1, node);

Good point. Fixed.

Thanks,

	tglx

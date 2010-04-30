Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab0D3UYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:24:17 -0400
Received: from www.tglx.de ([62.245.132.106]:43844 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758302Ab0D3UYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:24:15 -0400
Date: Fri, 30 Apr 2010 22:24:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
cc: davem@davemloft.net, arjan@linux.jf.intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next v3 1/2] irq: Add CPU mask affinity hint
In-Reply-To: <20100430202343.4591.66240.stgit@ppwaskie-hc2.jf.intel.com>
Message-ID: <alpine.LFD.2.00.1004302220270.2951@localhost.localdomain>
References: <20100430202343.4591.66240.stgit@ppwaskie-hc2.jf.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Fri, 30 Apr 2010, Peter P Waskiewicz Jr wrote:
>  
> +extern int irq_register_affinity_hint(unsigned int irq,
> +                                      const struct cpumask *m);

One last nitpick. 

Can you please rename to irq_set_affinity_hint() ?

Otherwise, I'm happy with the outcome. Thanks for your patience!

Thanks,

	tglx

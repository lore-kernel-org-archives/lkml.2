Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab0GNP13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:27:29 -0400
Received: from www.tglx.de ([62.245.132.106]:47301 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227Ab0GNP11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:27:27 -0400
Date: Wed, 14 Jul 2010 17:27:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@lst.de>
cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
In-Reply-To: <20100714151215.GA31825@lst.de>
Message-ID: <alpine.LFD.2.00.1007141719130.3321@localhost.localdomain>
References: <20100628121554.GA6605@lst.de> <tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org> <20100630074434.GA25509@elte.hu> <20100630075212.GA24658@lst.de> <20100630075818.GB25509@elte.hu> <20100630080453.GA14371@elte.hu> <20100708204251.GA13569@elte.hu>
 <20100708205302.GA23961@lst.de> <20100714151215.GA31825@lst.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, Christoph Hellwig wrote:

> Turns out this wasn't a regression introduced by a commit, but it
> happens when CONFIG_FUNCTION_GRAPH_TRACER is enabled.  From a quick
> look I have no idea why these would interact badly, especially as
> CONFIG_FUNCTION_GRAPH_TRACER works fine with irq stacks if the
> CONFIG_4KSTACKS options is set.

So you're saying, that the problem appears when
CONFIG_FUNCTION_GRAPH_TRACER is enabled w/o being used and that it
exists prior to your patches with irq stacks and 8k stack size, but
works with 4k stacks. That's definitely more than odd.

Thanks,

	tglx


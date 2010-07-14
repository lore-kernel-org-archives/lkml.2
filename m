Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab0GNPMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:12:42 -0400
Received: from verein.lst.de ([213.95.11.210]:48810 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab0GNPMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:12:40 -0400
Date: Wed, 14 Jul 2010 17:12:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
Message-ID: <20100714151215.GA31825@lst.de>
References: <20100628121554.GA6605@lst.de> <tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org> <20100630074434.GA25509@elte.hu> <20100630075212.GA24658@lst.de> <20100630075818.GB25509@elte.hu> <20100630080453.GA14371@elte.hu> <20100708204251.GA13569@elte.hu> <20100708205302.GA23961@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708205302.GA23961@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () UPPERCASE_25_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turns out this wasn't a regression introduced by a commit, but it
happens when CONFIG_FUNCTION_GRAPH_TRACER is enabled.  From a quick
look I have no idea why these would interact badly, especially as
CONFIG_FUNCTION_GRAPH_TRACER works fine with irq stacks if the
CONFIG_4KSTACKS options is set.


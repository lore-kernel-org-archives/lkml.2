Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab0GHUxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:53:34 -0400
Received: from verein.lst.de ([213.95.11.210]:37969 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab0GHUxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:53:32 -0400
Date: Thu, 8 Jul 2010 22:53:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
Message-ID: <20100708205302.GA23961@lst.de>
References: <20100628121554.GA6605@lst.de> <tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org> <20100630074434.GA25509@elte.hu> <20100630075212.GA24658@lst.de> <20100630075818.GB25509@elte.hu> <20100630080453.GA14371@elte.hu> <20100708204251.GA13569@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708204251.GA13569@elte.hu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I can see the crash with vanilla x86/irq as well, with the config i sent.
> 
> Ping?

Sorry, got preempted by a few important things when bisecting when it
broke over my tested config.  Give me another day or two.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab0F3Hwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:52:40 -0400
Received: from verein.lst.de ([213.95.11.210]:40692 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab0F3Hwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 03:52:39 -0400
Date: Wed, 30 Jun 2010 09:52:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org, hch@lst.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
Message-ID: <20100630075212.GA24658@lst.de>
References: <20100628121554.GA6605@lst.de> <tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org> <20100630074434.GA25509@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630074434.GA25509@elte.hu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reverting 7974891db2 and dcfa72628 makes the crash go away.
> 
> Full crashlog and config attached.

What kernel is the .config for?  Trying to compile your x86/irq branch
with it asks lots of questions during make oldconfig for it.


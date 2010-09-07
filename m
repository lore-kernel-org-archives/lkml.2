Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0IGIWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 04:22:07 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44447 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534Ab0IGIWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 04:22:00 -0400
Message-Id: <1283847719.24748.1393705201@webmail.messagingengine.com>
X-Sasl-Enc: injefcO4qjYQa+0w41hF6cddJEaC8U9m1stlRiRG3TV5 1283847719
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, hch@lst.de,
        "Thomas Gleixner" <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <20100907045553.GA20770@elte.hu>
References: <20100628121554.GA6605@lst.de><tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org><20100903150041.GA30573@elte.hu><1283799222.15941.1393621887@webmail.messagingengine.com>
 <20100907045553.GA20770@elte.hu>
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
Date: Tue, 07 Sep 2010 10:21:59 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Sep 2010 06:55 +0200, "Ingo Molnar" <mingo@elte.hu> wrote:
> 
> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> 
> > On Fri, 03 Sep 2010 17:00 +0200, "Ingo Molnar" <mingo@elte.hu> wrote:
> > > 
> > > * tip-bot for Christoph Hellwig <hch@lst.de> wrote:
> > > 
> > > > Commit-ID:  7974891db234467eaf1fec613ec0129cb4ac2332
> > > > Gitweb:     http://git.kernel.org/tip/7974891db234467eaf1fec613ec0129cb4ac2332
> > > > Author:     Christoph Hellwig <hch@lst.de>
> > > > AuthorDate: Mon, 28 Jun 2010 14:15:54 +0200
> > > > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > > > CommitDate: Tue, 29 Jun 2010 12:12:59 +0200
> > > > 
> > > > x86: Always use irq stacks
> > >
> > > [...]
> > > 
> > > Checking out 7974891db2 and building+booting a kernel with this config 
> > > causes shows the crash.
> > > 
> > > Checking out 7974891db2~1 and building+booting a kernel with this config 
> > > gives a working system.
> > > 
> > > Note that tip:x86/irq has these commits currently:
> > > 
> > >  1813a68: x86: Move alloc_desk_mask variables inside ifdef
> > >  2589737: x86-32: Align IRQ stacks properly
> > >  dcfa726: x86: Remove CONFIG_4KSTACKS
> > >  7974891: x86: Always use irq stacks
> > 
> > Hello Ingo, Christoph, ...
> > 
> > There is still a problem with the alignment of the irq stacks. Maybe it's only
> > theoretical, but I think the attached patch is necessary. (Attached because
> > I'm sending it via a web interface.)
> > 
> > Please test and apply :).
> 
> This apparently solved the crash, thanks a lot Alexander!

My pleasure!

Greetings,
    Alexander

> 	Ingo
> 

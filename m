Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750937Ab2EEEDe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 00:03:34 -0400
Received: from smtp.syd.comcen.com.au ([203.23.236.77]:4472 "EHLO
	smtp.syd.comcen.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2EEEDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 00:03:33 -0400
Date: Sat, 5 May 2012 14:00:05 +1000
From: Chris Jones <chrisjones@spin.net.au>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mark Lord <kernel@teksavvy.com>
Subject: Re: Hard drive detection
Message-ID: <20120505140005.19247cd0@ubuntu>
In-Reply-To: <4FA4959F.2000905@teksavvy.com>
References: <20120504185604.3addfd2e@ubuntu>
	<4FA3D60F.9090601@teksavvy.com>
	<20120505093000.1d9789dd@ubuntu>
	<4FA4959F.2000905@teksavvy.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-comcen-MailScanner-Information: Please contact the ISP for more information
X-comcen-MailScanner: Found to be clean
X-comcen-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-1.975, required 4, AWL 0.53, BAYES_00 -2.60, RDNS_NONE 0.10)
X-comcen-MailScanner-From: chrisjones@spin.net.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2012 22:51:11 -0400
Mark Lord <kernel@teksavvy.com> wrote:

> On 12-05-04 07:30 PM, Chris Jones wrote:
> ..
> > Thanks Mark. That's exactly what I was looking for. And are both
> > PATA and SATA internal drives both located in drivers/ata?
> ..
> 
> Yes.
> But historically, PATA drives were handled by the original IDE drivers
> that I worked on in the mid-1990s.  That code is in linux/drivers/ide,
> but we're trying hard to phase it out.  The code in linux/drivers/ata
> (aka. "libata") handles nearly all of the same PATA stuff and more.
> 

Yeah I remember reading something a while back about all the
IDE/PATA support being migrated to the SATA sets and phasing out the
legacy IDE stuff.

So technically, the old IDE sets could be removed with no negative
effect on a modern system? Correct?


Regards

Chris Jones


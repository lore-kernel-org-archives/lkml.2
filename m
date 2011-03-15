Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab1COVEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:04:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757232Ab1COVEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:04:43 -0400
Date: Tue, 15 Mar 2011 14:04:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, oakad@yahoo.com
Subject: Re: [PATH 0/4] Memstick patches for 2.6.39
Message-Id: <20110315140402.334cc55c.akpm@linux-foundation.org>
In-Reply-To: <1300219210.13493.0.camel@MAIN>
References: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
	<1299947013.17988.0.camel@maxim-laptop>
	<1300219210.13493.0.camel@MAIN>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 22:00:10 +0200
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Sat, 2011-03-12 at 18:23 +0200, Maxim Levitsky wrote:
> > On Fri, 2011-03-04 at 06:16 +0200, Maxim Levitsky wrote:
> > > Hi,
> > > 
> > > This is a repost of my patches for 2.6.39 inclusion, which I hope not to
> > > miss this time.
> > > 
> > > I addressed the comments on the scatterlist issues.
> > > 
> > > Andrew, please note that my richoh memstick driver is standalone, unchanged from previos versions
> > > has many users which use the version I posted at ubuntu's Launchpad and happy with it.
> > > Please include it regardless of other patches.
> > > 
> > > The other half of my work is support for legacy memorysticks which consists of 2 patches,
> > > first that adds few functions to scatterlist.c, and the other patch that adds the driver.
> > > Driver is also stable and tested.
> > > 
> > > Best regards,
> > > 	Maxim Levitsky
> > 
> > 
> > Any update?
> 
> Any update?
> 

I'm hoping that Alex will soon have time to (re)review these patches.

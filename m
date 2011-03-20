Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab1CTDJM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 23:09:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44815 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab1CTDJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 23:09:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=I1y33Uq5/WO1+QYzZyvMDjqBQNC4jNxE3X6fqJ1GzKy4KC/xL4z2QUT0+wZYwu4PSU
         TxMIPoi50YBYqkia+gC0aJHbGGWRjx87hYLrYGCbkRhjn0+ctSS1vFU5YlS7HX6t3J44
         Rmra17rcwgbUnOHKEETpyskK7nCiT2XZafzV8=
Subject: Re: [PATH 0/4] Memstick patches for 2.6.39
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, oakad@yahoo.com
In-Reply-To: <20110315140402.334cc55c.akpm@linux-foundation.org>
References: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
	 <1299947013.17988.0.camel@maxim-laptop> <1300219210.13493.0.camel@MAIN>
	 <20110315140402.334cc55c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Mar 2011 05:09:05 +0200
Message-ID: <1300590545.15453.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 14:04 -0700, Andrew Morton wrote:
> On Tue, 15 Mar 2011 22:00:10 +0200
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > On Sat, 2011-03-12 at 18:23 +0200, Maxim Levitsky wrote:
> > > On Fri, 2011-03-04 at 06:16 +0200, Maxim Levitsky wrote:
> > > > Hi,
> > > > 
> > > > This is a repost of my patches for 2.6.39 inclusion, which I hope not to
> > > > miss this time.
> > > > 
> > > > I addressed the comments on the scatterlist issues.
> > > > 
> > > > Andrew, please note that my richoh memstick driver is standalone, unchanged from previos versions
> > > > has many users which use the version I posted at ubuntu's Launchpad and happy with it.
> > > > Please include it regardless of other patches.
> > > > 
> > > > The other half of my work is support for legacy memorysticks which consists of 2 patches,
> > > > first that adds few functions to scatterlist.c, and the other patch that adds the driver.
> > > > Driver is also stable and tested.
> > > > 
> > > > Best regards,
> > > > 	Maxim Levitsky
> > > 
> > > 
> > > Any update?
> > 
> > Any update?
> > 
> 
> I'm hoping that Alex will soon have time to (re)review these patches.

Andrew Morton, what the current state now?


-- 
Best regards,
        Maxim Levitsky

Visit my blog: http://maximlevitsky.wordpress.com
Warning: Above blog contains rants.


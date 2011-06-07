Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1FGIn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:43:57 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:37378 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1FGIny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:43:54 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 50.43.15.19
Date: Tue, 7 Jun 2011 01:43:49 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Status of function-sections work?
Message-ID: <20110607084349.GC4599@leaf>
References: <20110606011531.GA1887@leaf>
 <201106071011.15114.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106071011.15114.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 10:11:15AM +0200, Denys Vlasenko wrote:
> On Monday 06 June 2011 03:15, Josh Triplett wrote:
> > Hello,
> > 
> > I found your work in 2010 on using function-sections and data-sections
> > to eliminate unused code in the kernel.  I'd like to make use of this
> > work to try to build an extremely space-constrained kernel.
> > 
> > It looks like a few of your patches made it into the kernel, but most of
> > the linker script changes don't seem to have made it in.  I wanted to
> > find out the status of this work.  Do you still have this working?  Do
> > you have versions of your patches for current Linux?
> 
> parisc uses ^ in some identifiers. Therefore we need something like
> [A-Za-z0-9_$^]* in linker script. This wasn't working with GNU ld -
> ^ is not a valid char for pattern. Use of more general [!.]*
> was also impossible - ! is not a valid char too.
> 
> Therefore I asked binutils people to fix this (they agreed) and
> decided to wait for a fixed binutils to be released.

Makes sense.  Thanks for the explanation and status.

Do you know if the fix has gone into binutils, either in a release or
the latest snapshot from version control?  If not, does a patch exist?

- Josh Triplett

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab0HRLKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 07:10:09 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52978 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0HRLKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 07:10:07 -0400
Date: Wed, 18 Aug 2010 12:10:02 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Rabin VINCENT <rabin.vincent@stericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH] checkpatch: check for incorrect permissions
Message-ID: <20100818111002.GQ6193@shadowen.org>
References: <1281590145-30708-1-git-send-email-rabin.vincent@stericsson.com>
 <20100812140222.d3dedf91.akpm@linux-foundation.org>
 <20100813045528.GA32350@bnru01.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100813045528.GA32350@bnru01.bnr.st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 10:25:29AM +0530, Rabin VINCENT wrote:
> On Thu, Aug 12, 2010 at 23:02:22 +0200, Andrew Morton wrote:
> > On Thu, 12 Aug 2010 10:45:45 +0530
> > Rabin Vincent <rabin.vincent@stericsson.com> wrote:
> > >  		# extract the filename as it passes
> > > -		if ($line=~/^\+\+\+\s+(\S+)/) {
> > > +		if ($line=~/^\+\+\+\s+(\S+)/ || $line=~/^diff\s.*?(\S+)$/) {
> > 
> > Breakage.  This causes the false warning:
> > 
> > WARNING: patch prefix 'drivers' exists, appears to be a -p0 patch
> 
> I've fixed this by matching for the filename in the diff line only when
> it's "diff --git".  Also prevented a double-print of the "do not modify
> file in include/asm" error.
> 
> From b854ea24f1bd5391a63d8d4e2aa63e1c10870816 Mon Sep 17 00:00:00 2001
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> Date: Wed, 11 Aug 2010 14:45:45 +0530
> Subject: [PATCHv2] checkpatch: check for incorrect permissions

That one looks better.  I've pull this updated one (slightly modified)
into my tree.

Andrew, will send you this shortly.

-apw

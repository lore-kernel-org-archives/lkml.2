Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2EBXVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 19:21:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37750 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2EBXVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 19:21:35 -0400
Date: Wed, 2 May 2012 16:21:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] Extcon: fix section mismatch in extcon_gpio.c
Message-ID: <20120502232126.GA24513@kroah.com>
References: <201205021538.45056.hartleys@visionengravers.com>
 <20120502224510.GA19693@opensource.wolfsonmicro.com>
 <20120502225115.GA3535@kroah.com>
 <20120502230418.GC19693@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502230418.GC19693@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 12:04:18AM +0100, Mark Brown wrote:
> On Wed, May 02, 2012 at 03:51:15PM -0700, Greg KH wrote:
> 
> > So did I, but I can't seem to find it anywhere.  Did I not apply it?
> 
> > odd.
> 
> Nope, no response at all from you that I recall.  Perhaps I forgot to CC
> the list or something.

Hm, I found it now, it ended up in my "already applied this" mbox, but
obviously, I didn't apply it.

Very sorry about that, I went through a few hundred patches the other
day on the airplane, I must have messed this one up, my apologies.

greg k-h

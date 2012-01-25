Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092Ab2AYWD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:03:59 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29609 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2AYWD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:03:58 -0500
Date: Wed, 25 Jan 2012 23:04:04 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [000/129] 3.2.2-stable review
In-Reply-To: <20120125215107.GA15555@suse.de>
Message-ID: <alpine.LNX.2.00.1201252303060.4417@swampdragon.chaosbits.net>
References: <20120124024041.GA18422@kroah.com> <alpine.LNX.2.00.1201252245210.4417@swampdragon.chaosbits.net> <20120125215107.GA15555@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012, Greg KH wrote:

> On Wed, Jan 25, 2012 at 10:47:08PM +0100, Jesper Juhl wrote:
> > On Mon, 23 Jan 2012, Greg KH wrote:
> > 
> > > #include <stable/formletter.h>
> > > #define RELEASE		3.2.2-rc1
> > > #define NUM_PATCHES	129
> > > #define RESPONSE_DATE	"Wed, Jan 25, 2012 20:00:00 +0000"
> > > #define LOCATION	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.2-rc1.gz
> > 
> > A very small, seriously not at all important, tiny question; Why are the 
> > patches for 3.2.x placed in /pub/linux/kernel/v3.**0**/ ???
> 
> It's a symlink, why not?  :)
> 
Just seems confusing, that's all.. After all, 3.2.x is not 3.0.x, so it 
looks like an error...
Not at all important, that's just the impression I got..

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


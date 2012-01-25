Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2AYVwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:52:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab2AYVwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:52:18 -0500
Date: Wed, 25 Jan 2012 13:51:07 -0800
From: Greg KH <gregkh@suse.de>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [000/129] 3.2.2-stable review
Message-ID: <20120125215107.GA15555@suse.de>
References: <20120124024041.GA18422@kroah.com>
 <alpine.LNX.2.00.1201252245210.4417@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1201252245210.4417@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 10:47:08PM +0100, Jesper Juhl wrote:
> On Mon, 23 Jan 2012, Greg KH wrote:
> 
> > #include <stable/formletter.h>
> > #define RELEASE		3.2.2-rc1
> > #define NUM_PATCHES	129
> > #define RESPONSE_DATE	"Wed, Jan 25, 2012 20:00:00 +0000"
> > #define LOCATION	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.2-rc1.gz
> 
> A very small, seriously not at all important, tiny question; Why are the 
> patches for 3.2.x placed in /pub/linux/kernel/v3.**0**/ ???

It's a symlink, why not?  :)


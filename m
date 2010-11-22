Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab0KVS17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:27:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab0KVS17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:27:59 -0500
Date: Mon, 22 Nov 2010 10:27:51 -0800
From: Greg KH <gregkh@suse.de>
To: Marco <firefox82@alice.it>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 00/16 v4] pramfs: persistent and protected RAM
 filesystem
Message-ID: <20101122182751.GA26250@suse.de>
References: <4CE79B4C.7030001@gmail.com>
 <4CEAB264.4040909@alice.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEAB264.4040909@alice.it>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 07:11:48PM +0100, Marco wrote:
> Il 20/11/2010 10:56, Marco Stornelli ha scritto:
> > 
> > Andrew/Greg, can you insert the code in the mm/staging tree?
> > 
> 
> Please, can I have a positive/negative feedback about that? Thanks.

I can add it to the staging tree _if_ the code is under drivers/staging/
which I do not think your patch places the code at, right?

So if you wish to do that, I'd be glad to take it, but you need to have
a list of things left to do to get it integrated into the "main" portion
of the kernel.  Do you have that at the moment?

thanks,

greg k-h

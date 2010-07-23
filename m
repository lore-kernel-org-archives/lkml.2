Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab0GWMim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:38:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:34488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab0GWMil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:38:41 -0400
Date: Fri, 23 Jul 2010 05:37:46 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: philippe.langlais@stericsson.com, linux-kernel@vger.kernel.org,
        ludovic.barre@stericsson.com
Subject: Re: patch "U6715 8250 serial like driver" added to gregkh-2.6 tree
Message-ID: <20100723123746.GA2192@suse.de>
References: <1279531660-16317-1-git-send-email-philippe.langlais@stericsson.com> <12798430773066@site> <20100723090119.5d63cfb7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723090119.5d63cfb7@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 09:01:19AM +0100, Alan Cox wrote:
> On Thu, 22 Jul 2010 16:57:57 -0700
> <gregkh@suse.de> wrote:
> 
> > 
> > This is a note to let you know that I've just added the patch titled
> 
> NAK this
> 
> I've nakked several similar patches already from people trying to
> convolute the 8250 driver even further, doubly so when the patch
> redefines properties of existing chips according to a compile time option

Sorry about that, I've now dropped it from my tree.

greg k-h

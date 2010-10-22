Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab0JVRBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 13:01:00 -0400
Received: from kroah.org ([198.145.64.141]:60562 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758113Ab0JVRA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 13:00:59 -0400
Date: Fri, 22 Oct 2010 09:59:12 -0700
From: Greg KH <greg@kroah.com>
To: Artur Baruchi <mail.baruchi@gmail.com>
Cc: 7eggert@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: Mapping Inode to File
Message-ID: <20101022165912.GA18639@kroah.com>
References: <fGqN4-2Ns-3@gated-at.bofh.it>
 <E1P9Iy2-0001mY-UA@be1.7eggert.dyndns.org>
 <AANLkTikebrSiW0unB8xy8UU1KNGaOZBu_HT=j9wQQeY5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikebrSiW0unB8xy8UU1KNGaOZBu_HT=j9wQQeY5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Fri, Oct 22, 2010 at 02:09:44PM -0200, Artur Baruchi wrote:
> Sorry, didnt understand your point.
> 
> Could you please clarify?

The point is that, no, it's not simple to do this at all.

> Note that I need to retrieve the file name in Kernel Space, Im able to
> get the inode, but now I need to convert this inode to a name
> (something that I could use).

How about explaining why you need to get the file name from within the
kernel?  Perhaps there's a better way to do what you are trying to
accomplish.

thanks,

greg k-h

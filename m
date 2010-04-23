Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab0DWQVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:21:16 -0400
Received: from kroah.org ([198.145.64.141]:42839 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab0DWQVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:21:13 -0400
Date: Fri, 23 Apr 2010 09:20:06 -0700
From: Greg KH <greg@kroah.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB fixes for 2.6.34-git
Message-ID: <20100423162006.GB21129@kroah.com>
References: <20100422222610.GA3187@kroah.com>
 <4BD18349.3020405@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD18349.3020405@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 03:23:53PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> Greg KH wrote:
> 
> >Here are a number of USB bugfixes and new device ids for your 2.6.34-git
> >tree.
> >
> >Nothing really huge, just a bunch of needed fixes for reported problems.
> >
> >Please pull from:
> >	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/
> >
> >All of these patches have been in the linux-next and mm trees.
> >
> >The full patches will be sent to the linux-usb mailing list, if anyone
> >wants to see them.
> 
>   How about this series [1] of 11 MUSB fixes?
> 
> [1] http://marc.info/?l=linux-usb&m=126951575000396

They are still in my to-apply queue, I will get to them.

thanks,

greg k-h

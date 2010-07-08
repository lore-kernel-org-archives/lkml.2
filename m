Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0GHUEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:04:12 -0400
Received: from kroah.org ([198.145.64.141]:34420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab0GHUEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:04:09 -0400
Date: Thu, 8 Jul 2010 12:30:13 -0700
From: Greg KH <greg@kroah.com>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Gustavo Silva <silvagustavosilva@gmail.com>, devel@driverdev.osuosl.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: Re: [PATCH 4/4] Staging: vme: devices: fix coding style issues in
 vme_user.c
Message-ID: <20100708193013.GA3464@kroah.com>
References: <1277594847-19171-1-git-send-email-silvagustavo@users.sourceforge.net>
 <4C29CF3F.4070500@ge.com>
 <4C31A352.10807@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C31A352.10807@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 10:18:10AM +0100, Martyn Welch wrote:
> Martyn Welch wrote:
> > Gustavo Silva wrote:
> >   
> >> This is a patch to the vme_user.c file that fixes up the following
> >> issues:
> >>
> >> WARNING: please, no space before tabs						x 12
> >> ERROR: code indent should use tabs where possible				x 15
> >> WARNING: braces {} are not necessary for single statement blocks		x  2
> >> WARNING: printk() should include KERN_ facility level				x  3
> >> ERROR: "foo * bar" should be "foo *bar"						x  1
> >> ERROR: space required before the open brace '{'					x  3
> >> WARNING: space prohibited between function name and open parenthesis '('	x  1
> >> ERROR: spaces required around that '=' (ctx:VxV)				x  2
> >> ERROR: spaces required around that '<' (ctx:VxV)				x  2
> >> ERROR: space required after that ',' (ctx:VxV)					x  3
> >> ERROR: spaces required around that '?' (ctx:VxW)				x  1
> >> ERROR: space required before the open parenthesis '('				x  1
> >> WARNING: braces {} are not necessary for single statement blocks		x  2
> >>
> >>   
> >>     
> >
> > This looks very familiar - I'm sure there was a patch already on the
> > mailing list doing this, but it has some issues which I don't think were
> > ever addressed. This one looks good though.
> >
> >   
> Hmm, seems the earlier patch was fixed up and is now in linux-next, sorry.

Yeah, this doesn't apply :(

thanks,

greg k-h

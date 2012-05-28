Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2E1HOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 03:14:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62273 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab2E1HO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 03:14:28 -0400
Date: Mon, 28 May 2012 16:14:21 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH RESEND] driver core: always handle dpm_order
Message-ID: <20120528071421.GB3014@kroah.com>
References: <1335165396-23604-1-git-send-email-linus.walleij@stericsson.com>
 <20120423154342.GB23990@kroah.com>
 <CACRpkdabgGFCLGNFtje2efXoRHtk_uvb3yo6FTkH2pVGpHGB1A@mail.gmail.com>
 <20120424143624.GB3438@kroah.com>
 <CACRpkdZ0MnMLxvi4oFv-s8aut_zRfQh_OQN6HoXHkXmrtkSmzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZ0MnMLxvi4oFv-s8aut_zRfQh_OQN6HoXHkXmrtkSmzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 02:38:09PM +0800, Linus Walleij wrote:
> On Tue, Apr 24, 2012 at 10:36 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, Apr 24, 2012 at 02:11:09PM +0200, Linus Walleij wrote:
> >> On Mon, Apr 23, 2012 at 5:43 PM, Greg Kroah-Hartman
> >> <gregkh@linuxfoundation.org> wrote:
> >> > On Mon, Apr 23, 2012 at 09:16:36AM +0200, Linus Walleij wrote:
> >> >> From: Rabin Vincent <rabin.vincent@stericsson.com>
> >> >>
> >> >> If !dev->class, device_move() does not respect the dpm_order.
> >> >> Fix it to do so.
> >> >>
> >> >> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> >> >> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> >> >> Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> >> >> [Fixed a small dangling label compile warning]
> >> >> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >> >> ---
> >> >>  drivers/base/core.c |   36 ++++++++++++++++++------------------
> >> >>  1 file changed, 18 insertions(+), 18 deletions(-)
> >> >
> >> > Is this a problem in 3.4?  Older kernels?  Or can it wait for 3.5?
> >>
> >> Rabin said earlier that it could wait for 3.4 atleast.
> >
> > That didn't answer my question at all.  Oh well, 3.5 it is...
> 
> Is this going upstream in this merge window? I haven't seen it
> in Torvalds' tree, but I guess it may be pending for a late
> merge...?

Nope, it missed 3.5 as no one ever answered my questions, so I guessed
that no one really cares about this :(

greg k-h

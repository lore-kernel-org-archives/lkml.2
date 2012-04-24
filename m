Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2DXOg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:36:29 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:52792 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab2DXOg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:36:28 -0400
Date: Tue, 24 Apr 2012 07:36:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH RESEND] driver core: always handle dpm_order
Message-ID: <20120424143624.GB3438@kroah.com>
References: <1335165396-23604-1-git-send-email-linus.walleij@stericsson.com>
 <20120423154342.GB23990@kroah.com>
 <CACRpkdabgGFCLGNFtje2efXoRHtk_uvb3yo6FTkH2pVGpHGB1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdabgGFCLGNFtje2efXoRHtk_uvb3yo6FTkH2pVGpHGB1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 02:11:09PM +0200, Linus Walleij wrote:
> On Mon, Apr 23, 2012 at 5:43 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Mon, Apr 23, 2012 at 09:16:36AM +0200, Linus Walleij wrote:
> >> From: Rabin Vincent <rabin.vincent@stericsson.com>
> >>
> >> If !dev->class, device_move() does not respect the dpm_order.
> >> Fix it to do so.
> >>
> >> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> >> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> >> Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> >> [Fixed a small dangling label compile warning]
> >> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >> ---
> >>  drivers/base/core.c |   36 ++++++++++++++++++------------------
> >>  1 file changed, 18 insertions(+), 18 deletions(-)
> >
> > Is this a problem in 3.4?  Older kernels?  Or can it wait for 3.5?
> 
> Rabin said earlier that it could wait for 3.4 atleast.

That didn't answer my question at all.  Oh well, 3.5 it is...

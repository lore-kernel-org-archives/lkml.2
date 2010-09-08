Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab0IHGcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:32:35 -0400
Received: from kroah.org ([198.145.64.141]:56807 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537Ab0IHGcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:32:31 -0400
Date: Tue, 7 Sep 2010 23:18:14 -0700
From: Greg KH <greg@kroah.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [RESEND/PATCH 0/6] USB: musb-gadget: bug fix
Message-ID: <20100908061814.GA23323@kroah.com>
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com> <20100908021939.GA20443@kroah.com> <AANLkTim605xLy8LjaKO+wR+UX2_r-dEQr=bMasXLAk22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim605xLy8LjaKO+wR+UX2_r-dEQr=bMasXLAk22@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 12:32:19PM +0800, Ming Lei wrote:
> CC Felipe / David / Gadiyar / Mike /  Sergei
> 
> 2010/9/8 Greg KH <greg@kroah.com>:
> > I seem to not have 1/6 here, did it get stuck somewhere?
> 
> Here is 1/6:
> 
>          http://marc.info/?l=linux-usb&m=128387307419605&w=2
> 
> If you need, I can send the 1/6 to you directly.

No need, I'll wait for Felipe to send them to me :)

> >
> > Anyway, I need Felipe's ack before I can accept these.
> 
> Felipe, expect your comments on the patch set...
> 
> BTW: The mailbox of felipe.balbi@nokia.com in MAINTAINERS has been
> obsolete now, and his current box is me@felipebalbi.com, seems MAINTAINERS
> should be updated for it.

Someone should send me a patch...

thanks,

greg k-h

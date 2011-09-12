Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab1ILLdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 07:33:35 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34505 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755338Ab1ILLdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 07:33:33 -0400
X-Sasl-enc: 44jtOXeeCa1bV0fohzhiQ9p1zYdDD99OhiBOdEEeYf1H 1315827212
Date: Mon, 12 Sep 2011 13:33:08 +0200
From: Greg KH <greg@kroah.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Increase usbfs bulk buffer size
Message-ID: <20110912113308.GA32396@kroah.com>
References: <CA+O4pCKfWLP+ohfUVi811CRbmrb2FyoMwkmxxGJ1TF2kKtGDEA@mail.gmail.com>
 <201108171914.52257.oliver@neukum.org>
 <CA+O4pCK3vZjZwM0D7Q0gzsTZRJC1PfzYvoVmq-g2jJQ=uP_6ug@mail.gmail.com>
 <201108190823.06638.oliver@neukum.org>
 <CA+O4pCKteFZBT0UMetuk4-gsUf4wG3DXnOooW47GWD7o=dgpQQ@mail.gmail.com>
 <CA+O4pC+gxbLaHDyAUB-ro1Z-jTGdMfey9yJht1Ux4jWhanKbkg@mail.gmail.com>
 <CA+O4pCK5WE+fgYzMjpp2x54ePGivTdZnPRQdZ+BN6HAARYVU+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+O4pCK5WE+fgYzMjpp2x54ePGivTdZnPRQdZ+BN6HAARYVU+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 12:18:02PM +0200, Markus Rechberger wrote:
> Hi,
> 
> I'm a little bit curious why you guys are just ignoring this.

Because you seem to be ignoring the fact that changing this can cause
problems on systems.

And because it really doesn't solve any problems, you are only pushing
the processing to the kernel, when it can be done in userspace just as
easily.

greg k-h

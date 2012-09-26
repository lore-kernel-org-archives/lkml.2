Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2IZWIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 18:08:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57731 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751532Ab2IZWIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 18:08:23 -0400
X-Sasl-enc: lDE1BcMbRj6ykKvq0t+E04sAaKvDXkiMeaTGlHd/8P9l 1348697302
Date: Wed, 26 Sep 2012 15:08:21 -0700
From: Greg KH <greg@kroah.com>
To: Rene Buergel <rene.buergel@sohard.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [Patch v5] ezusb: move ezusb.c from drivers/usb/serial to
 drivers/usb/misc
Message-ID: <20120926220821.GA14139@kroah.com>
References: <c28594f9-45a3-4232-82fc-2f7c65cfb30c@shmail0>
 <47b117b0-5776-41c4-8b49-e3a21e80a6a4@shmail0>
 <20120926212710.5775.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926212710.5775.qmail@stuge.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 11:27:10PM +0200, Peter Stuge wrote:
> Rene Buergel wrote:
> > - renamed CONFIG_USB_EZUSB to CONFIG_USB_EZUSB_FX2 to avoid build errors
> 
> Is this really the reason for the build error? I doubt it.

It is, try it without it, the Makefiles get confused :(

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab2HOWU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 18:20:59 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53029 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923Ab2HOWU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:20:57 -0400
X-Sasl-enc: 3xkDW7xwUXOu/7JNcl7frL4fKLqXGYuVaURdHgYPvEQp 1345069256
Date: Wed, 15 Aug 2012 15:20:55 -0700
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?Ren=E9_B=FCrgel?= <rene.buergel@sohard.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3]: ezusb cleanup, FX2 support, firmware downloading
 support
Message-ID: <20120815222055.GA22907@kroah.com>
References: <501BE8F3.6020608@sohard.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <501BE8F3.6020608@sohard.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 05:06:27PM +0200, René Bürgel wrote:
> Hello,
> 
> this is a patches-series for controllers using the ezusb-functions.
> 
> ezusb:  remove dependency to usb_serial interface
> euzsb: add support for Cypress FX2LP
> ezusb: add functions for firmware download

Nice series, but your patches are white-space damaged, and I can't apply
them at all.

Also, your third patch has the wrong Subject: line :(

Care to resend them in a format that I can apply them in?

thanks,

greg k-h

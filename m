Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab2HXTdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:33:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab2HXTdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:33:42 -0400
Date: Fri, 24 Aug 2012 12:33:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rene Buergel <rene.buergel@sohard.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3]: ezusb cleanup, FX2 support, firmware downloading
 support
Message-ID: <20120824193320.GA21315@kroah.com>
References: <20120820144937.GB27266@kroah.com>
 <08c78af9-4c08-4fa6-82f1-8e9e0c0bc333@shmail0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08c78af9-4c08-4fa6-82f1-8e9e0c0bc333@shmail0>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 09:26:41AM +0200, Rene Buergel wrote:
> 
> > > - Although i removed the dependency from ezusb to usb_serial,
> > >   ezusb.c still resides in drivers/usb/serial.
> > >   Can you give me a hint, where to put it instead?
> > >   I would like to do that with an additional patch.
> > 
> > Why do you want to move it?
> 
> because is has nothing to do with any serial stuff anymore...

Fair enough, how about drivers/usb/misc/ instead?

greg k-h

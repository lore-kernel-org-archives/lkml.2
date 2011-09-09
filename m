Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab1IISq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:46:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104Ab1IISq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:46:56 -0400
Date: Fri, 9 Sep 2011 11:43:54 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
Message-ID: <20110909184354.GA30278@suse.de>
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <20110908191146.GA8552@suse.de>
 <op.v1jdo3g53l0zgt@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.v1jdo3g53l0zgt@mnazarewicz-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 12:20:53PM +0200, Michal Nazarewicz wrote:
> >On Thu, Sep 08, 2011 at 08:24:47PM +0200, Klaus Schwarzkopf wrote:
> >>This driver provides two functions in one configuration:
> >>a mass storage, and a CDC ACM (serial port) link.
> >>Heavily based on multi.c and cdc2.c
> 
> On Thu, 08 Sep 2011 21:11:46 +0200, Greg KH <gregkh@suse.de> wrote:
> >I thought the "composite" framework make it so that drivers like this
> >were no longer needed.  Or am I mistaken somehow?
> 
> No.  Composite framework only makes it relatively simple to create such
> gadgets, but one still needs some glue that binds all the functions into
> a single gadget.

Ah, so this is that glue?

> This seems like both a blessing and a curse (which I haven't realise when
> I was creating g_multi) since with n functions implemented one can easily
> came up with 2^n gadgets.

So we can expect more patches like this adding all of the possible
permutations of the different gadget devices?

If so, ick, I thought that the work that was done was to prevent this
from happening, oh well :(

greg k-h

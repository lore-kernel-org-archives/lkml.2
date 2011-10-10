Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab1JJPOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:14:12 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49253 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750991Ab1JJPOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:14:10 -0400
Date: Mon, 10 Oct 2011 11:14:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
cc: balbi@ti.com, <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH v3] usb: add new usb gadget for ACM and mass storage
In-Reply-To: <4E92ADBD.2010404@sensortherm.de>
Message-ID: <Pine.LNX.4.44L0.1110101111540.18069-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011, Klaus Schwarzkopf wrote:

> >> +	.bDeviceClass =		USB_CLASS_COMM,
> >> +	.bDeviceSubClass =	0,
> >> +	.bDeviceProtocol =	0,
> 
> Should bDeviceClass, bDeviceSubClass, and bDeviceProtocol have the same 
> value like in the file multi.c?
> 
> 	.bDeviceClass =		USB_CLASS_MISC /* 0xEF */,
> 	.bDeviceSubClass =	2,
> 	.bDeviceProtocol =	1,

This may or may not be relevant...  The USB 2.0 spec (Table 9-8) says
that if bDeviceClass is 0 then each interface specifies its own class
information and the interfaces operate independently.  Isn't that what 
you want?

Alan Stern


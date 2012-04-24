Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab2DXCYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 22:24:22 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:51939 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab2DXCYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 22:24:20 -0400
Date: Tue, 24 Apr 2012 10:24:25 +0800
From: Wang YanQing <udknight@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Anil Nair <anilcoll90@gmail.com>, Greg KH <greg@kroah.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [RFC]Is usb port number fixed?
Message-ID: <20120424022425.GA5565@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Anil Nair <anilcoll90@gmail.com>, Greg KH <greg@kroah.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
References: <20120423015212.GA7547@udknight>
 <Pine.LNX.4.44L0.1204231109380.1612-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204231109380.1612-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 11:13:06AM -0400, Alan Stern wrote:
> > Indeed, I never meat the situation lspci output different bus number on the same machine.
> > Any more comment?
> 
> Try unloading ehci-hcd, uhci-hcd, and ohci-hcd, and then reloading them 
> in different orders.  Depending on what sort of hardware you have, the 
> bus numbers will change.
Yes, usb host control live on the pci bus, depend on the usb host control probe order,
and usb bus register order, the usb bus number maybe change,
I make a mistake between the pci bus number and usb bus number.

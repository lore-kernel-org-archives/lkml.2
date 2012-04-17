Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2DQOYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:24:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52954 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751052Ab2DQOYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:24:13 -0400
Date: Tue, 17 Apr 2012 10:24:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nicolas Ferre <nicolas.ferre@atmel.com>
cc: linux-arm-kernel@lists.infradead.org, <arnd@arndb.de>, <olof@lixom.net>,
        <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 11/12] USB: ohci-at91: change annotations for probe/remove
 functions
In-Reply-To: <4F8D64F5.5060300@atmel.com>
Message-ID: <Pine.LNX.4.44L0.1204171022550.1364-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012, Nicolas Ferre wrote:

> On 04/16/2012 11:20 AM, Nicolas Ferre :
> > Add __devinit and __devexit on *_probe() and *_remove() functions
> > with proper modification of struct platform_driver.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> 
> Alan,
> 
> Can I have your "Acked-by" for this modification? I plan to push a
> "fixes" series though arm-soc git tree.

Yes, you can add it.

I tend not to respond to simple changes that are independent of the USB 
functionality, like this one.

Alan Stern


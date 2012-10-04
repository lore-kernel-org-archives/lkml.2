Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2JDTTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:19:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45989 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755821Ab2JDTTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:19:11 -0400
Date: Thu, 4 Oct 2012 15:19:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>
cc: linux-usb@vger.kernel.org, Anton Vorontsov <avorontsov@mvista.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/24 v2] ARM: cns3xxx: use OHCI platform driver
In-Reply-To: <1349363872-27004-18-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1210041517091.1441-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2012, Florian Fainelli wrote:

> Since both the EHCI and OHCI platform drivers use the same power_{on,off}
> callbacks, rename them to cns3xx_usb_power_{on,off} to show that they are
> shared.

This is an example of the sort of thing I complained about before.  
People who read only the patch description and not the title will
wonder why this patch adds cns3xxx_usb_ohci_pdata and
cns3xxx_usb_ohci_device.

And people who read both will wonder why they talk about different 
things.

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab0GAOJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:09:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48028 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751307Ab0GAOJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:09:42 -0400
Date: Thu, 1 Jul 2010 10:09:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
cc: linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: gadget: mass storage: use proper device class in
 device desc
In-Reply-To: <59b191a020300966e20eef4e942bc75982d792fb.1277735580.git.m.nazarewicz@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1007011004370.1596-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010, Michal Nazarewicz wrote:

> Hello Alan,
> 
> Each time I see the device descriptor of the File Storage Gadget
> I wonder if it shouldn't be set to the real value rather then leaving
> it as per interface.

It should not be changed.

> Is there a reason to leave it as per interface?

See Table 4.1 in the USB Mass Storage Bulk-Only Transport 
specification and Table 3.1 in the CBI Transport specification.

>  Will chenging it to
> the real value change anything?

You mean will it hurt anything?  I don't know; I have never tried it.

> I checked my pendrive and an IDE<->USB adapter they as well use a per
> interface class but maybe it'll be better to use proper call any way?

No.  And it's not a proper call -- it's not even the proper descriptor
valu.  So NAK on this patch.

Alan Stern


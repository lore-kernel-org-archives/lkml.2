Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab1F2T7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 15:59:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46060 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753492Ab1F2T7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 15:59:34 -0400
Date: Wed, 29 Jun 2011 15:59:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: 3.0rc3-rc5: usb stops working after resume from suspend to ram
In-Reply-To: <201106292121.34523.a.miskiewicz@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1106291557080.2064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011, Arkadiusz Miskiewicz wrote:

> 
> Hi,
> 
> Something broke between rc3 and rc5. Thinkpad t400, logitech usb mouse.
> After resume from ram usb device no longer works. Somewhere around rc3 it was
> working fine.

Obviously you can try bisection to find the problem.  But if you don't 
want to go through that, you could post the dmesg from a kernel that 
has CONFIG_USB_DEBUG enabled.

Alan Stern


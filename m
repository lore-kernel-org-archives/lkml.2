Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab0IVFdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 01:33:06 -0400
Received: from dhruva1.ncra.tifr.res.in ([158.144.12.129]:44190 "EHLO
	dhruva1.ncra.tifr.res.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab0IVFdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 01:33:04 -0400
From: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Regarding USB-to-serial device driver
Date: Wed, 22 Sep 2010 11:02:46 +0530
Message-Id: <20100922052107.M44650@admin-gateway.ncra.tifr.res.in>
In-Reply-To: <20100914131925.GC375@suse.de>
References: <20100913091318.M67834@admin-gateway.ncra.tifr.res.in> <20100913154843.GA27496@suse.de> <20100914060649.M96376@admin-gateway.ncra.tifr.res.in> <20100914131925.GC375@suse.de>
X-Mailer: OpenWebMail 2.53 (08:Aug:2008)
X-OriginatingIP: 158.144.12.129
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg,
      I am facing some problem in data copying.
I am having a const unsigned char *buf which contains 02 08 00 00 00 00 00 00 f8.
which is copied in port->write_urb->transfer_buffer and sent on ttyUSB0 using
usb_submit_urb(port->write_urb, GFP_ATOMIC).

But  I want to send the data bytes is a particular fashion.

1. I want to Add Mark parity. 
2. Send the data byte 02 ( Address of a device )

3. Add Space parity .
4. send the data byte 08 00 00 00 00 00 00 f8 ( Null cmd + check sum )

Kindly help me.I am facing the problem in separating the data bytes so that I can send
the data bytes separately using usb_submit_urb.

Thanks,
Raj. 

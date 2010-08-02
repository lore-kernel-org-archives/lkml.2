Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0HBJqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:46:46 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53857 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab0HBJqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:46:45 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Mon, 02 Aug 2010 11:48:15 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv5 1/3] USB: gadget: composite: Better string override
 handling
In-reply-to: <764692.87858.qm@web180303.mail.gq1.yahoo.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <op.vgs1ipl47p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <764692.87858.qm@web180303.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Aug 2010 21:05:33 +0200, David Brownell <david-b@pacbell.net> wrote:
> NAK.  You're still hard-wiring an un-managed serial number.

Uh?  I'm not.  Current code overrides the serial number only when the
iSerial module parameter is given:

+	if (iSerialNumber)
+		cdev->serial_override =
+			override_id(cdev, &cdev->desc.iSerialNumber);

and when host requests string which ID is saved as a overridden for
serial number the module parameter is taken.

+	else if (cdev->serial_override == id)
+		str = iSerialNumber;

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

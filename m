Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab0GWJDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 05:03:20 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58877 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab0GWJDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 05:03:19 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Fri, 23 Jul 2010 11:04:40 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv4 1/5] USB: gadget: composite: Better string override
 handling
In-reply-to: <20100722234630.GA1352@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Message-id: <op.vgagt2te7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <e2d14d0a730dde4b716c0e086761ef65ba9afda8.1278619472.git.m.nazarewicz@samsung.com>
 <89baa7d196b5e1d8427c90a78f2aa0cda4331d7a.1279794289.git.m.nazarewicz@samsung.com>
 <20100722234630.GA1352@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 01:46:30 +0200, Greg KH <greg@kroah.com> wrote:
> And they are not -stable material, no matter what, sorry, so you can
> stop copying stable@kernel.org on them.

True enough.  I probably haven't given enough thought copying the Cc.
Sorry about that.  Removing the line from the patch should solve the
issue nicely. ;)

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

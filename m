Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab0HBRMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:12:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14029 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab0HBRMi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:12:38 -0400
Date: Mon, 02 Aug 2010 19:14:08 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv5 2/3] USB: gadget: Use new composite features in some
 gadgets
In-reply-to: <20100730165450.GA4943@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "mina86@mina86.com" <mina86@mina86.com>
Message-id: <op.vgtl5umt7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <231296.268.qm@web180308.mail.gq1.yahoo.com>
 <op.vgn0zfyq7p4s8u@pikus> <20100730165450.GA4943@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jul 30, 2010 at 06:48:41PM +0200, Michał Nazarewicz wrote:
>> So, to fix the situation, I need to ask Greg for the IDs?

On Fri, 30 Jul 2010 18:54:50 +0200, Greg KH <greg@kroah.com> wrote:
> Yes you do.

Could I ask for two IDs then.  One for the Multifunction Composite
Gadget (g_multi) and another for FunctionFS Gadget (g_ffs).  Or is
there some kind of procedure for that?

Again, sorry for all the confusion.  As soon as the gadgets will
get their own IDs I'll repost the patches with fixed IDs and David's
suggestions taken into consideration.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

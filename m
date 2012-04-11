Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab2DKTtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:49:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49801 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab2DKTty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:49:54 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: f_mass_storage: remove deprecated fsg_add()
References: <1ad5f25435fc5d2cd094ae1c68d7831b8b2737ca.1331896818.git.mina86@mina86.com> <op.wa9go4093l0zgt@mpn-glaptop> <20120411094112.GK12064@arwen.pp.htv.fi> <20120411152528.GA27947@kroah.com>
Date: Wed, 11 Apr 2012 21:49:49 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wcl9dbyh3l0zgt@mpn-glaptop>
In-Reply-To: <20120411152528.GA27947@kroah.com>
User-Agent: Opera Mail/11.62 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Fri, Mar 16, 2012 at 12:25:42PM +0100, Michal Nazarewicz wrote:
>>> From: Michal Nazarewicz <mina86@mina86.com>
>>>
>>> There are no in-tree fsg_add() users and it has been deprecated
>>> since 2.6.35 [1dc90985d1: fsg_add() renamed to fsg_bind_config()] so
>>> out-of-tree users had more then enough time to convert.  Removing.

> On Wed, Apr 11, 2012 at 12:41:13PM +0300, Felipe Balbi wrote:
>> applied, thanks. Also added your SOB, next time be more careful.

On Wed, 11 Apr 2012 17:25:28 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote
> Um, wait, you can't just "add" a SOB, that's not allowed at all, sorry.
>
> Michal, do you sign-off on this patch?  If so, please do so.

Sorry, yes, of course.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1JQTmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:42:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60762 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1JQTmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:42:38 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Felipe Balbi" <balbi@ti.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 0/3] get rid of USB_GADGET_{DUAL,SUPER}SPEED
References: <Pine.LNX.4.44L0.1110171450490.1749-100000@iolanthe.rowland.org>
Date: Mon, 17 Oct 2011 12:42:32 -0700
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v3ig06cn3l0zgt@mpn-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1110171450490.1749-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.51 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 17 Oct 2011, Michal Nazarewicz wrote:
>> This has been only compile-tested.

On Mon, 17 Oct 2011 11:52:21 -0700, Alan Stern <stern@rowland.harvard.edu> wrote:
> Did you compile-test the various intermediate stages (i.e., after the
> first patch and after the second patch)?  I bet not, because the change
> to file_storage.c in 3/3 belongs in 2/3.

Sorry and thanks for catching that.  I'll send the updated version by the
end of US/Pacific day in case someone else has some more comments.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab0JDLbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 07:31:03 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17265 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab0JDLbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 07:31:00 -0400
Date: Mon, 04 Oct 2010 13:33:06 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] usb: gadget: file_storage: Fix error path
In-reply-to: <op.vj1o4pqf7p4s8u@pikus>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Christoph Hellwig <hch@lst.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rahul Ruikar <rahul.ruikar@gmail.com>,
        =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <op.vj1udgde7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <1286081717-2757-1-git-send-email-rahul.ruikar@gmail.com>
 <op.vj1o4pqf7p4s8u@pikus>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Oct 2010 11:39:51 +0200, Michał Nazarewicz <m.nazarewicz@samsung.com> wrote:
> The same problem is with f_mass_storage.c.  I'd be nice if you'd resubmit your
> patch with the below included as well:

I've noticed that you've send is as a separate file.  Disregard this comment then
(even though I still think the two might be squashed together).


Moreover, disregard my mail, as I was wrong acking.  Alan is of course
correct.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

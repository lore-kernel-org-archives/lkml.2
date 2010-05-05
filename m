Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227Ab0EEJQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:16:44 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55879 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879Ab0EEJQn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:16:43 -0400
Date: Wed, 05 May 2010 11:17:01 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: USB mass storage kernel panic after two days sleep/wakeup
In-reply-to: <1273027887.9369.16.camel@ben-desktop>
To: Bin Shi <Bin.Shi@csr.com>
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>, binghua.duan@csr.com,
       bin.shi@csr.com
Message-id: <op.vb76qnkx7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <1272452239.8054.1.camel@ben-desktop> <op.vbyv9nzg7p4s8u@pikus>
 <1273027887.9369.16.camel@ben-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 May 2010 04:51:27 +0200, Bin Shi <Bin.Shi@csr.com> wrote:
> You mean come back to previous version of file_storage.c and try to
> reproduce this bug. If it does not occur, then remodelling should be the
> cause?

Precisely.  I think if the bug is in file storage then the remodelling is
a likely culprit.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

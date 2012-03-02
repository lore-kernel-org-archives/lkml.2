Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030353Ab2CBPox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:44:53 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42115 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030283Ab2CBPov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:44:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mnazarewicz@gmail.com designates 10.14.51.15 as permitted sender) smtp.mail=mnazarewicz@gmail.com; dkim=pass header.i=mnazarewicz@gmail.com
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Barry Song" <21cnbao@gmail.com>
Cc: m.szyprowski@samsung.com, workgroup.linux@csr.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MM: CMA: add a simple kernel module as the helper to test
 CMA
References: <1330656742-5233-1-git-send-email-Barry.Song@csr.com>
 <op.wajuip2a3l0zgt@mpn-glaptop>
 <CAGsJ_4zz=C2k3pvc=1_=iviSUkz78QCF+yumEEMaknysLHFxag@mail.gmail.com>
Date: Fri, 02 Mar 2012 16:44:48 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wajvcyle3l0zgt@mpn-glaptop>
In-Reply-To: <CAGsJ_4zz=C2k3pvc=1_=iviSUkz78QCF+yumEEMaknysLHFxag@mail.gmail.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2012/3/2 Michal Nazarewicz <mina86@mina86.com>:
>> Looks quite all right.  It has a race condition but I guess for a test
>> device it's not that big of a deal (I think the race cannot cause
>> panic).  Either way, would be nice if one could specify how much memory
>> device should allocate.  How about those changes: [...]

On Fri, 02 Mar 2012 16:37:46 +0100, Barry Song <21cnbao@gmail.com> wrote:
> Michal, I think these improvements have maken the cma_test much more
> useful and flexible.

Sure, no problem, just squash it and resend the patch and I'll take one more
look at the result. :)

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--

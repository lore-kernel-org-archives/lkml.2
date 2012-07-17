Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2GQNCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:02:38 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42128 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2GQNCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:02:35 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Michal Nazarewicz" <mina86@tlen.pl>, "JoonSoo Kim" <js1304@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Sasha Levin" <levinsasha928@gmail.com>,
        "Christoph Lameter" <cl@linux.com>
Subject: Re: [PATCH 2/3] mm: fix possible incorrect return value of
 migrate_pages() syscall
References: <1342455272-32703-1-git-send-email-js1304@gmail.com>
 <1342455272-32703-2-git-send-email-js1304@gmail.com>
 <87394rr4dl.fsf@erwin.mina86.com>
 <CAAmzW4OZZgPKrffdvMmEgpzF=7C9mJTkEhBfjJ5G7Q15xLzv2g@mail.gmail.com>
Date: Tue, 17 Jul 2012 15:02:31 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.whlc6hjn3l0zgt@mpn-glaptop>
In-Reply-To: <CAAmzW4OZZgPKrffdvMmEgpzF=7C9mJTkEhBfjJ5G7Q15xLzv2g@mail.gmail.com>
User-Agent: Opera Mail/12.00 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012 19:59:18 +0200, JoonSoo Kim <js1304@gmail.com> wrote:

> 2012/7/17 Michal Nazarewicz <mina86@tlen.pl>:
>> Joonsoo Kim <js1304@gmail.com> writes:
>>> do_migrate_pages() can return the number of pages not migrated.
>>> Because migrate_pages() syscall return this value directly,
>>> migrate_pages() syscall may return the number of pages not migrated.
>>> In fail case in migrate_pages() syscall, we should return error value.
>>> So change err to -EIO
>>>
>>> Additionally, Correct comment above do_migrate_pages()
>>>
>>> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
>>> Cc: Sasha Levin <levinsasha928@gmail.com>
>>> Cc: Christoph Lameter <cl@linux.com>
>>
>> Acked-by: Michal Nazarewicz <mina86@mina86.com>
>
> Thanks.
>
> When I resend with changing -EIO to -EBUSY,
> could I include "Acked-by: Michal Nazarewicz <mina86@mina86.com>"?

Sure thing.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--

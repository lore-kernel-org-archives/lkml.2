Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2GPR7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:59:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57918 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab2GPR7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:59:19 -0400
MIME-Version: 1.0
In-Reply-To: <87394rr4dl.fsf@erwin.mina86.com>
References: <1342455272-32703-1-git-send-email-js1304@gmail.com>
	<1342455272-32703-2-git-send-email-js1304@gmail.com>
	<87394rr4dl.fsf@erwin.mina86.com>
Date: Tue, 17 Jul 2012 02:59:18 +0900
Message-ID: <CAAmzW4OZZgPKrffdvMmEgpzF=7C9mJTkEhBfjJ5G7Q15xLzv2g@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: fix possible incorrect return value of
 migrate_pages() syscall
From: JoonSoo Kim <js1304@gmail.com>
To: Michal Nazarewicz <mina86@tlen.pl>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Sasha Levin <levinsasha928@gmail.com>,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/17 Michal Nazarewicz <mina86@tlen.pl>:
> Joonsoo Kim <js1304@gmail.com> writes:
>> do_migrate_pages() can return the number of pages not migrated.
>> Because migrate_pages() syscall return this value directly,
>> migrate_pages() syscall may return the number of pages not migrated.
>> In fail case in migrate_pages() syscall, we should return error value.
>> So change err to -EIO
>>
>> Additionally, Correct comment above do_migrate_pages()
>>
>> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
>> Cc: Sasha Levin <levinsasha928@gmail.com>
>> Cc: Christoph Lameter <cl@linux.com>
>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

Thanks.

When I resend with changing -EIO to -EBUSY,
could I include "Acked-by: Michal Nazarewicz <mina86@mina86.com>"?

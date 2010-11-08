Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab0KHLAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:00:39 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12547 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0KHLAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:00:38 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Mon, 08 Nov 2010 13:03:02 +0100
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 34/39] mm: Update WARN uses
In-reply-to: <01d3ac1297677b782018d82a25e2ca82f7d1ca09.1288471898.git.joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>, Joe Perches <joe@perches.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-id: <op.vluo3cfl7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <cover.1288471897.git.joe@perches.com>
 <01d3ac1297677b782018d82a25e2ca82f7d1ca09.1288471898.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Oct 2010 23:08:51 +0200, Joe Perches <joe@perches.com> wrote:
> diff --git a/mm/percpu.c b/mm/percpu.c
> @@ -715,8 +715,8 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
>  	unsigned long flags;
> 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
> -		WARN(true, "illegal size (%zu) or align (%zu) for "
> -		     "percpu allocation\n", size, align);
> +		WARN(true, "illegal size (%zu) or align (%zu) for percpu allocation\n",
> +		     size, align);
>  		return NULL;
>  	}

The above is a bit grep-unfriendly though.  Just my 0.02 PLN.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

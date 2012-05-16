Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967548Ab2EPN4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:56:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51281 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967483Ab2EPN4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:56:51 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1205160935340.1763@tux.localdomain>
References: <1337108498-4104-1-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1205151527150.11923@router.home>
	<alpine.LFD.2.02.1205160935340.1763@tux.localdomain>
Date: Wed, 16 May 2012 22:56:50 +0900
Message-ID: <CAAmzW4PWQiKbs+mdnwG18R=iWHLT=4Bwn8iA110PJaKuvG_AQQ@mail.gmail.com>
Subject: Re: [PATCH] slub: fix a memory leak in get_partial_node()
From: JoonSoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/16 Pekka Enberg <penberg@kernel.org>:
> <On Tue, 15 May 2012, Christoph Lameter wrote:
>
>> On Wed, 16 May 2012, Joonsoo Kim wrote:
>>
>> > In the case which is below,
>> >
>> > 1. acquire slab for cpu partial list
>> > 2. free object to it by remote cpu
>> > 3. page->freelist = t
>> >
>> > then memory leak is occurred.
>>
>> Hmmm... Ok so we cannot assign page->freelist in get_partial_node() for
>> the cpu partial slabs. It must be done in the cmpxchg transition.
>>
>> Acked-by: Christoph Lameter <cl@linux.com>
>
> Joonsoo, can you please fix up the stable submission format, add
> Christoph's ACK and resend?
>
>                        Pekka

Thanks for comment.
I'm a kernel newbie,
so could you please tell me how to fix up the stable submission format?
I'm eager to fix it up, but I don't know how to.

I read stable_kernel_rules.txt, this article tells me I must note
upstream commit ID.
Above patch is not included in upstream currently, so I can't find
upstream commit ID.
Is 'Acked-by from MAINTAINER' sufficient for submitting to stable-kernel?
Is below format right for stable submission format?


To: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman
<gregkh@linuxfoundation.org>, Pekka Enberg <penberg@kernel.org>

CC: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
linux-mm@kvack.org

[ Upstream commit xxxxxxxxxxxxxxxxxxx ]

Comment is here

Acked-by:
Signed-off-by:

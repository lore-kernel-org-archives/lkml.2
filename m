Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1AJLL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 06:11:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56066 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1AJLLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 06:11:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZMNRGaZbLaVotr00QG/hzB+6vxnjZCK5O1J2iKbC1UwOoA9z8FoBqov06V5e3j2rr6
         jHNy90k+Ou2A8AA7T3/pJTyNGtVrOWuH8lNc5RIl8dK4FuEtcTfY42W9VkHWqLLgeqxL
         3gzngqSviaXuyditAh4tU4njPRfB7M69ypS14=
MIME-Version: 1.0
In-Reply-To: <1294614389.2823.35.camel@localhost>
References: <1294606534-28522-1-git-send-email-christoph.paasch@uclouvain.be>
	<201101092232.19171.christoph.paasch@uclouvain.be>
	<1294610141.2823.31.camel@localhost>
	<201101092333.19406.christoph.paasch@uclouvain.be>
	<1294614389.2823.35.camel@localhost>
Date: Mon, 10 Jan 2011 13:11:21 +0200
Message-ID: <AANLkTik7mug7j=VLz80DX_hJokeO3=ie+KRcMViSL4kB@mail.gmail.com>
Subject: Re: [PATCH] Cleanup include/net/tcp.h include-files and coding-style
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: christoph.paasch@uclouvain.be, Randy Dunlap <rdunlap@xenotime.net>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 1:06 AM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
> On Sun, 2011-01-09 at 23:33 +0100, Christoph Paasch wrote:

>> > If a file directly references definitions that are supposed to be
>> > provided by a certain header, changing it to rely on indirect inclusion
>> > of that header generally does *not* aid maintenance.
>> But then, to be coherent, we would need to add the following includes (and I'm
>> even not 100% sure if it's all we need):
>>
>> linux/percpu_counter.h (needed for percpu_counter_sum_positive)
>
> Yes.

Currently code compiles fine, so necessary headers are in place,
so simply adding new headers doesn't help anything.

>> linux/mm_types.h (needed for struct page)
>> linux/aio.h (needed for struct kiocb)
>> net/inet_sock.h (needed for struct ip_options)
>> linux/pipe_fs_i.h (needed for struct pipe_inode_info)
>> linux/poll.h (needed for struct poll_table_struct)
>
> Or declarations of those structs.
>
>> linux/compiler.h (needed for __percpu)
> [...]
>
> Yes.

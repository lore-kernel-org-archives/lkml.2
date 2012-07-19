Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2GSAOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 20:14:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40164 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2GSAOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 20:14:42 -0400
MIME-Version: 1.0
In-Reply-To: <1342656617.2215.40.camel@joe2Laptop>
References: <1342442513-10488-1-git-send-email-yamanetoshi@gmail.com>
	<1342573366-8167-1-git-send-email-yamanetoshi@gmail.com>
	<1342574175.2012.12.camel@joe2Laptop>
	<CAOTypNSvKEfYVLZ=0sN-U+2xiXBO4So4QkvYyKniEFeqvkqVBg@mail.gmail.com>
	<1342633985.9551.36.camel@joe2Laptop>
	<CAOTypNQDWUNNFP6aEQ3ZjTi6u-UH7oRMR5eg5-n2PHjEaTxmhw@mail.gmail.com>
	<1342656617.2215.40.camel@joe2Laptop>
Date: Thu, 19 Jul 2012 09:14:41 +0900
Message-ID: <CAOTypNSWbQW8H8X-W=iXyFsPFn5ODn1G-f6nsfpgusJg7Ej=tQ@mail.gmail.com>
Subject: Re: [PATCH] staging/et131x: fix checkpatch warnings
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Einon <mark.einon@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 9:10 AM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2012-07-19 at 09:05 +0900, Toshiaki Yamane wrote:
>> On Thu, Jul 19, 2012 at 2:53 AM, Joe Perches <joe@perches.com> wrote:
>> > OK, fyi: it turns out ps_ring_physaddr and rx_status_bus
>> > are both dma_addr_t so both should be emitted with %ull
>> > and cast to (unsigned long long) or (u64).
>> Thanks for your reply.
>> %ullx ?
>
> My fault, dunno what I was thinking, just %llx
>
> cheers, Joe
>

Thanks!
I will try to fix it.

-- 

Regards,


 .
  .
...

Yamane Toshiaki

yamanetoshi@gmail.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2LJPCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 10:02:23 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52369 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab2LJPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 10:02:21 -0500
MIME-Version: 1.0
In-Reply-To: <CALyraeP41AEZFD=cHZT_PYgUZ+nrvDfTMQ1t9qtuFJ-cOEssiQ@mail.gmail.com>
References: <CALyraeP41AEZFD=cHZT_PYgUZ+nrvDfTMQ1t9qtuFJ-cOEssiQ@mail.gmail.com>
From: Javier Domingo <javierdo1@gmail.com>
Date: Mon, 10 Dec 2012 16:01:59 +0100
Message-ID: <CALZVapn=9j7=53Zktg_udaCPaKbmxVNJWGRjdt--pEJjS8bKzg@mail.gmail.com>
Subject: Re: Question on Memory management unit
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: linux-newbie@vger.kernel.org,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will just refer you to this link:

http://stackoverflow.com/questions/116343/what-is-the-difference-between-vmalloc-and-kmalloc

Is as much as I know about that. You will find links that refer to
other places, where they discuss/explain that.

Javier Domingo


2012/12/9 Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>:
> Hi Guys,
>
> I have question on memory management in linux kernel.
>
> From my understanding memory is divided into 3GB and 1GB for 32-bit
> architectures. 1GB is allocated to kernel space and 3GB is allocated
> to user space.
>
> To access any memory in kernel space, it should be mapped in to kernel
> virtual address space.
>
> My question is how do we know kernel address space (virtual address).
> Can we recognize a range of addresses, if so what is that range of
> kernel virtual address?
>
> What function returns kernel virtual address. Or do we need to map to
> get kernel virtual address.
>
> I know kmalloc returns logical address and vmalloc returns virtual address.
> And all these addresses should go through MMU to access physical
> memory. So there will be page mappings in kernel for these addresses.
> Is this true?
>
> Thanks in advance.
> --
> Regards,
> Sri.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-newbie" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.linux-learn.org/faqs

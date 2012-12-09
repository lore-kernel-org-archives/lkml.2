Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707Ab2LIAIL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 19:08:11 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:44726 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab2LIAIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 19:08:09 -0500
MIME-Version: 1.0
Date: Sat, 8 Dec 2012 19:08:08 -0500
Message-ID: <CALyraeP41AEZFD=cHZT_PYgUZ+nrvDfTMQ1t9qtuFJ-cOEssiQ@mail.gmail.com>
Subject: Question on Memory management unit
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: linux-newbie@vger.kernel.org,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

I have question on memory management in linux kernel.

>From my understanding memory is divided into 3GB and 1GB for 32-bit
architectures. 1GB is allocated to kernel space and 3GB is allocated
to user space.

To access any memory in kernel space, it should be mapped in to kernel
virtual address space.

My question is how do we know kernel address space (virtual address).
Can we recognize a range of addresses, if so what is that range of
kernel virtual address?

What function returns kernel virtual address. Or do we need to map to
get kernel virtual address.

I know kmalloc returns logical address and vmalloc returns virtual address.
And all these addresses should go through MMU to access physical
memory. So there will be page mappings in kernel for these addresses.
Is this true?

Thanks in advance.
-- 
Regards,
Sri.

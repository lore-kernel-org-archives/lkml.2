Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab2DATWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 15:22:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2DATWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 15:22:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] nextfd(2)
Date: Sun, 1 Apr 2012 19:21:59 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20120401125741.GA7484@p183.telecom.by>
In-Reply-To: <20120401125741.GA7484@p183.telecom.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204011921.59596.arnd@arndb.de>
X-Provags-ID: V02:K0:ZkuBebvKE65cYj9hZYgxA+yM5a+Z8OjgKSi41EpBYqf
 m8GrnmKyBUcZLf5zBmvoBZ2PPk+An1gGkGNBHMvleddp4dHwGp
 2togY1Oh94eBHtjTjbsQ5S7VTvtNGL+2Rv4EPeF0c8/DrfrN/4
 /0z+bGAvqHVFRNcDP0EHQaAHAAmLypv9dD9hdRX0O7QyLhNaTW
 ScscfhebkGUPUBjdfBxj28591DH5IUZF1BVyKddxVhRFEkdVYI
 Mq0OLlYX5n7UnaqgClPD4yECcE9vy5YBj04LLGQ+srkza0D8D6
 Pv+rqKFxjKvJ34uZt0xZrLXwfbP49G0kv+R6M9MLktyZDGnim8
 s4dJ7IS6WPzzo6NBrH40=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 April 2012, Alexey Dobriyan wrote:
>  arch/x86/syscalls/syscall_32.tbl |    1 +
>  arch/x86/syscalls/syscall_64.tbl |    1 +
>  fs/Makefile                      |    1 +
>  fs/nextfd.c                      |   27 +++++++++++++++++++++++++++
>  include/linux/syscalls.h         |    1 +
>  5 files changed, 31 insertions(+)

I don't have any comments on the syscall itself, but when you add one, please
also make the change to include/asm-generic/unistd.h so it appears in the
various architectures using the generic syscall table.

	Arnd

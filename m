Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1CJO45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:56:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64908 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab1CJO4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:56:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC] introduce sys_syncfs to sync a single file system (v2)
Date: Thu, 10 Mar 2011 15:56:44 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <Pine.LNX.4.64.1103071515070.11152@cobra.newdream.net> <8762ruchcr.fsf@linux.vnet.ibm.com>
In-Reply-To: <8762ruchcr.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101556.44698.arnd@arndb.de>
X-Provags-ID: V02:K0:/FO3HUInhBs3WL+7rLbfFv/svH1YUjWWmxfAtHfRbi+
 Qmc3fkUyM9P8c4BSbRba2j2DH43qirvfY9Xm1mhcmqP8/AXS+p
 dy3sVKJbhEdgplmlQhSqHHaiyMpbP9e+rUJF+wBv8/PDiNvLuN
 mtLs7h92nIziamaAZk+FQ+ATYZesE0mmsJ3j2wvSZCKZtK0S6c
 JlkCIJf2Ktd/KzvVV2DOA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 March 2011, Aneesh Kumar K. V wrote:
> >  arch/x86/ia32/ia32entry.S          |    1 +
> >  arch/x86/include/asm/unistd_32.h   |    3 ++-
> >  arch/x86/include/asm/unistd_64.h   |    2 ++
> >  arch/x86/kernel/syscall_table_32.S |    1 +
> >  fs/sync.c                          |   24 ++++++++++++++++++++++++
> >  5 files changed, 30 insertions(+), 1 deletions(-)
> 
> 
> include/asm-generic/unistd.h may also need an update.

I was just going to say the same.

Also, include/linux/syscalls.h should list the prototype, because
some architectures generate the system call table from C code.

	Arnd

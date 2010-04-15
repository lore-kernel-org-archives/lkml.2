Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab0DOGkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:40:00 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38757 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0DOGj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jHHQ7GXzZFsLQU42l0xwzAGfQWF6Jxu7GRM55hIyd1jiosBHM7jaI/+4SRf7JIWu1C
         U+ERHDrpxmYnr/bsjKWNFy66mGsDnAkfFqTMBB8RaeOeB5+qqyurvzHCYxGh4790Cq/9
         lmt8ELoBGq4LK7zhryUmTR2i3F6NWCs32q5/M=
MIME-Version: 1.0
In-Reply-To: <q2m7b6bb4a51004142328jf5a16efei859d5cd90f2911d@mail.gmail.com>
References: <20100413025228.GC10860@localhost.localdomain>
	 <m2v7b6bb4a51004142312ze69796ak87d4ee65f6dd5529@mail.gmail.com>
	 <o2w628d1651004142317n438d21e4t359c9661c2c00926@mail.gmail.com>
	 <q2m7b6bb4a51004142328jf5a16efei859d5cd90f2911d@mail.gmail.com>
Date: Thu, 15 Apr 2010 14:39:57 +0800
Message-ID: <z2w628d1651004142339t166d2003kf86fe83d919e8c95@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: Make config Filter access to /dev/mem default y
From: wzt wzt <wzt.wzt@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       x86@kernel.org, zippel@linux-m68k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> so you're running rootkit as a root user?
>
rootkit always run as a root user.


>Years ago, someone sent the same patch.
>check http://lkml.org/lkml/2008/11/7/361
thanks,  i read it.  But nowadays >= 2.6.26 kernel became more
popular, more people start use it.  When they compile the kernel, they
don't change KERNEL_HACKING option, becasue they are not kernel
prgramer.

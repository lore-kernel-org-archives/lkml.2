Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab2LNANx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:13:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37707 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab2LNANv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:13:51 -0500
MIME-Version: 1.0
In-Reply-To: <50CA6478.20008@zytor.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<1355436141-8668-20-git-send-email-yinghai@kernel.org>
	<50CA6478.20008@zytor.com>
Date: Thu, 13 Dec 2012 16:13:49 -0800
X-Google-Sender-Auth: GhgzsmrSjlPu_4-_VPWh6DEEmTM
Message-ID: <CAE9FiQURsKT8Ufy7NmWUzrzkYoH65Edk6e_kJkw_+YYx=1bXTg@mail.gmail.com>
Subject: Re: [PATCH v6 19/27] x86, boot: update comments about entries for
 64bit image
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 3:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/13/2012 02:02 PM, Yinghai Lu wrote:
>> +      * If we come here from a bootloader, kernel(text+data+bss+brk),
>> +      * ramdisk, zero_page, command line could be above 4G.
>> +      * We depend on an identity mapped page table being provided
>> +      * that maps our entire kernel(text+data+bss+brk), and hopefully
>> +      * all of memory.
>
> We should make it explicit what we depend on.  We certainly *can* depend
> only on text+data+bss+brk ... with the dynamic page table approach we
> can do that, and that would be most conservative; if we depend on other
> things we should make that explicit, not just here but in boot.txt.

yes, in my version, only need kernel(text+data+bss+brk) get mapped.
aka the INIT_SIZE for decompressing.

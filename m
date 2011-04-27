Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab1D0QoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:44:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54448 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab1D0QoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:44:09 -0400
Message-ID: <4DB847BF.1060307@zytor.com>
Date: Wed, 27 Apr 2011 09:43:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110422 Fedora/3.1.9-7.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jan Beulich <JBeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: re-use kernel/syscall_table_32.S in ia32/ia32entry.S
References: <4DB85376020000780003E6C9@vpn.id2.novell.com> <4DB83946.609@zytor.com> <4DB85A4F020000780003E6F7@vpn.id2.novell.com> <201104271840.32015.arnd@arndb.de>
In-Reply-To: <201104271840.32015.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 09:40 AM, Arnd Bergmann wrote:
>>
>> Yes, that's certainly an alternative.
> 
> How about following the same style as asm-generic/unistd.h? It's
> originally derived from the x86 version, but has added support for
> compat syscalls for the tile architecture.
> 

Yep, something like that (although I have to say the __SC_3264 syntax
makes me want to barf.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


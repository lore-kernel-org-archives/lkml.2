Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2DAWGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 18:06:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46325 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab2DAWGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 18:06:04 -0400
Message-ID: <4F78D141.4070609@zytor.com>
Date: Sun, 01 Apr 2012 15:05:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <201204011921.59596.arnd@arndb.de>
In-Reply-To: <201204011921.59596.arnd@arndb.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2012 12:21 PM, Arnd Bergmann wrote:
> On Sunday 01 April 2012, Alexey Dobriyan wrote:
>>  arch/x86/syscalls/syscall_32.tbl |    1 +
>>  arch/x86/syscalls/syscall_64.tbl |    1 +
>>  fs/Makefile                      |    1 +
>>  fs/nextfd.c                      |   27 +++++++++++++++++++++++++++
>>  include/linux/syscalls.h         |    1 +
>>  5 files changed, 31 insertions(+)
> 
> I don't have any comments on the syscall itself, but when you add one, please
> also make the change to include/asm-generic/unistd.h so it appears in the
> various architectures using the generic syscall table.
> 
> 	Arnd

Arnd: do you have any interest in leveraging the syscall scripts I did
for x86?  I have tried to make them as generic as possible, with the
hope of getting more and more of syscall information into more easily
processed form.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


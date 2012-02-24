Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab2BXQ4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:56:07 -0500
Received: from multi.imgtec.com ([194.200.65.239]:47662 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757875Ab2BXQ4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:56:05 -0500
Message-ID: <4F47C123.9050009@imgtec.com>
Date: Fri, 24 Feb 2012 16:56:03 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mike Frysinger <vapier@gentoo.org>, <linux-arch@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] asm-generic/unistd.h: handle symbol prefixes in
 cond_syscall
References: <4F47981F.4020305@imgtec.com> <201202241119.44480.vapier@gentoo.org> <201202241637.30284.arnd@arndb.de> <201202241638.12205.arnd@arndb.de>
In-Reply-To: <201202241638.12205.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Feb 2012 16:56:03.0447 (UTC) FILETIME=[3155C870:01CCF315]
X-SEF-Processed: 7_3_0_01181__2012_02_24_16_56_03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/02/12 16:38, Arnd Bergmann wrote:
> On Friday 24 February 2012, Arnd Bergmann wrote:
>> We actually have MODULE_SYMBOL_PREFIX providing the correct string
>> under a name that is not appropriate here. We can probably stick with
>> Jason's patch for now and add a more sophisticated logic if another
>> user of CONFIG_SYMBOL_PREFIX comes up.
>>
>> So for Jason's patch:
>>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>
>> We could put that into the kernel now, but it's probably sufficient if
>> Jason keeps the patch with his others and submits it at the same time
>> when we get there.
> 
> Sorry, I meant s/Jason/James/g

np. Okay, I'll keep hold of it.

Thanks
James


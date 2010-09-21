Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0IUHty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 03:49:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab0IUHtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 03:49:53 -0400
Message-ID: <4C98639D.107@corscience.de>
Date: Tue, 21 Sep 2010 09:49:49 +0200
From: Bernhard Walle <walle@corscience.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: N32: Fix getdents64 syscall for n32
References: <1283501734-6532-1-git-send-email-walle@corscience.de> <20100919235131.GA29977@linux-mips.org>
In-Reply-To: <20100919235131.GA29977@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:85h7Ft0wYTX2bqeIzUUE0GJ6ICUJ1tqHNddVuUkkUcJ
 Pm6D5CEDsF2dwNwq+cjIOQaKKsDYCDYB8Es07iOsbMok1t0ln/
 LwGpFmlUG3mqastfqi4t7o8VF7/3cxvRwHb9q464KpHpPS5dUB
 DuDwdiyxJeujGkTeSJiSB472veXvSz4u+R+auWm9yCBbq51HTu
 gHU4jZUkw/UbWt4dol2OQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.09.2010 01:51, schrieb Ralf Baechle:
> On Fri, Sep 03, 2010 at 10:15:34AM +0200, Bernhard Walle wrote:
>
>> Commit 31c984a5acabea5d8c7224dc226453022be46f33 introduced a new syscall
>> getdents64. However, in the syscall table, the new syscall still refers
>> to the old getdents which doesn't work.
>>
>> The problem appeared with a system that uses the eglibc 2.12-r11187
>> (that utilizes that new syscall) is very confused. The fix has been
>> tested with that eglibc version.
>
> Thanks Bernhard!

Wouldn't it make sense to put that fix also in the stable tree (2.6.35.6)?


Regards,
Bernhard

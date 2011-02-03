Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1BCJED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:04:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54480 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab1BCJD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:03:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=XAcOtueh5azdUyoteULz0YKDlQyU1Cq6gzVGHDcUHdAhCQ2EMaZPvQbgJ05NPFEDfn
         Fc+YrjCBhtKGkCcijrJ4SAvcB4oVFObdazIbDPA9tLaj1PrOO/Cf5t6WjgSKSnbbfVUK
         nEIF9fNqBdOdB56WyJEhmqtEAVZIi97twSs6w=
Message-ID: <4D4A6F79.4070502@gmail.com>
Date: Thu, 03 Feb 2011 10:03:53 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, ML netdev <netdev@vger.kernel.org>,
        davidel@xmailserver.org
Subject: Re: epoll broken [was: mmotm 2011-01-25-15-47 uploaded]
References: <201101260021.p0Q0LxsS016458@imap1.linux-foundation.org>	 <4D4A5BBF.20806@gmail.com> <1296719601.3438.0.camel@edumazet-laptop>
In-Reply-To: <1296719601.3438.0.camel@edumazet-laptop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2011 08:53 AM, Eric Dumazet wrote:
>> {0, {u32=0, u64=0}} .............. {0, {u32=0, u64=0}}, ?}
>> 0x7fb816996660, 8192, 0) = 379151968
>> 17836 --- SIGSEGV (Segmentation fault) @ 0 (0) ---
>> 17836 +++ killed by SIGSEGV +++
>>
>> The parameter, the same as the retval, seems to be bogus.
>>
>> Is it known (fixed in newer kernels)?
>>
>> thanks,
> 
> Yes, its known, and a fix is there : https://lkml.org/lkml/2011/1/26/121

Thanks, it works indeed.

-- 
js

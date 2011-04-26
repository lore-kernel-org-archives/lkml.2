Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab1DZCBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 22:01:01 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55317 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab1DZCA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 22:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q5qJ0V7RCwZfNvhuvkHNLZqgRY9Id5n4I8ZdzcqBpq39m090lprXU9aO5+wpxmSKLu
         wEFV6M1LFs1tfGR9kCc4grxoHqKDZ6MiB1z7CeWQsQ2dha9l2j8xLL1qLsBJ7XCmXd3P
         e7YmA7f72oEGWqrYYEAt2E0GCKr5GfBg1MCxk=
MIME-Version: 1.0
In-Reply-To: <20110425143319.f4c6e036.akpm@linux-foundation.org>
References: <1303638677-11211-1-git-send-email-akinobu.mita@gmail.com>
	<1303638677-11211-6-git-send-email-akinobu.mita@gmail.com>
	<20110425143319.f4c6e036.akpm@linux-foundation.org>
Date: Tue, 26 Apr 2011 11:00:58 +0900
Message-ID: <BANLkTi=S0JjzFq_Sf1tSgdk6h2V-m5n_pQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] s390: use asm-generic/bitops/le.h
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/26 Andrew Morton <akpm@linux-foundation.org>:
> On Sun, 24 Apr 2011 18:51:16 +0900
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> The previous style change enables to use asm-generic/bitops/le.h
>> on s390.
>
> What kernel version is this patchset against?
>
>>  }
>>  #define find_next_bit_le find_next_bit_le
>>
>> +#include <asm-generic/bitops/le.h>
>> +
>>  #include <asm-generic/bitops/ext2-atomic-test.h>
>>
>
> Mainline arch/s390/include/asm/bitops.h doesn't have this inclusion.

Oops, the change is only in my local tree.

> Please recheck, redo and resend.

OK, I will.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab0ELJVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:21:41 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:40525 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab0ELJVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:21:38 -0400
Message-ID: <4BEA73F6.7020400@oss.ntt.co.jp>
Date: Wed, 12 May 2010 18:25:10 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, avi@redhat.com,
       mtosatti@redhat.com, fernando@oss.ntt.co.jp, kvm@vger.kernel.org,
       kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 7/12 not tested yet] PPC: introduce __set_bit() like
 function for bitmaps in user space
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com> <20100504220418.083929bc.takuya.yoshikawa@gmail.com> <4BE97F2A.5080900@suse.de>
In-Reply-To: <4BE97F2A.5080900@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>> +static inline int set_bit_user_non_atomic(int nr, void __user *addr)
>> +{
>> +	u8 __user *p;
>> +	u8 val;
>> +
>> +	p = (u8 __user *)((unsigned long)addr + nr / BITS_PER_BYTE);
>>
>
> Does C do the + or the / first? Either way, I'd like to see brackets here :)

OK, I'll change like that! I like brackets style too :)

>
>
> Alex
>


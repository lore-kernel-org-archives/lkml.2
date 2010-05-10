Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab0EJMFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:05:32 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:49821 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0EJMF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:05:28 -0400
Message-ID: <4BE7F76B.3060408@oss.ntt.co.jp>
Date: Mon, 10 May 2010 21:09:15 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, Avi Kivity <avi@redhat.com>,
       mtosatti@redhat.com, agraf@suse.de, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH resend 8/12] asm-generic: bitops: introduce le bit
 offset macro
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com> <201005061538.54326.arnd@arndb.de> <4BE7F22E.9070504@oss.ntt.co.jp> <201005101401.52182.arnd@arndb.de>
In-Reply-To: <201005101401.52182.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>> Yes, I'm just using in kernel space: qemu has its own endian related helpers.
>>
>> So if you allow us to place this macro in asm-generic/bitops/* it will help us.
>
> No problem at all then. Thanks for the explanation.
>
> Acked-by: Arnd Bergmann<arnd@arndb.de>

Thanks you both. I will add your Acked-by from now on!

   Takuya

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab0JEMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:25:56 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:28197 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab0JEMZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:25:54 -0400
Message-ID: <4CAB1950.8060103@tilera.com>
Date: Tue, 5 Oct 2010 08:25:52 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>
Subject: Re: [PATCH 1/2] bitops: make asm-generic/bitops/find.h more generic
References: <1285751331-29148-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1285751331-29148-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 9/29/2010 5:08 AM, Akinobu Mita wrote:
> asm-generic/bitops/find.h has the extern declarations of find_next_bit()
> and find_next_zero_bit() and the macro definitions of find_first_bit()
> and find_first_zero_bit(). It is only usable by the architectures which
> enables CONFIG_GENERIC_FIND_NEXT_BIT and disables
> CONFIG_GENERIC_FIND_FIRST_BIT.
>
> x86 and tile enable both CONFIG_GENERIC_FIND_NEXT_BIT and
> CONFIG_GENERIC_FIND_FIRST_BIT. These architectures cannot include
> asm-generic/bitops/find.h in their asm/bitops.h. So ifdefed extern
> declarations of find_first_bit and find_first_zero_bit() are put in
> linux/bitops.h.
>
> This makes asm-generic/bitops/find.h usable by these architectures
> and use it. Also this change is needed for the forthcoming duplicated
> extern declarations cleanup.

This looks good, thanks.

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


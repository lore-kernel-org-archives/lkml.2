Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab1FEQHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 12:07:52 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:45076 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1FEQHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 12:07:51 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DEBA9CC.4090503@die-jansens.de>
Date: Sun, 05 Jun 2011 18:07:40 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
References: <20110605110132.GB23463@elte.hu> <20110605111933.GA24592@elte.hu> <20110605113627.GA25724@elte.hu> <4DEB6F3A.3000109@die-jansens.de> <20110605133958.GA27812@elte.hu> <4DEB8A93.30601@die-jansens.de> <20110605141003.GB29338@elte.hu> <4DEB933C.1070900@die-jansens.de> <20110605151323.GA30590@elte.hu> <20110605152641.GA31124@elte.hu> <20110605153218.GA31471@elte.hu>
In-Reply-To: <20110605153218.GA31471@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2011 17:32, Ingo Molnar wrote:
>
> one more thing, could you please add this call:
>
> 	debug_show_all_locks();
>
> to after the WARN(), in watchdog.c?
>
> Please surround the whole printout portion by the
> spin_lock()/unlock() protection code i suggested, full-lock-state
> printouts are slow and other CPUs might start printing their NMI
> ticks ...
>
> With the all-locks-printed output we can double check what locks are
> held.

Hm, on first try:

INFO: lockdep is turned off.

Recompiling...

>
> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


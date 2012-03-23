Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2CWGYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 02:24:50 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:52837 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2CWGYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 02:24:48 -0400
Message-ID: <4F6C170A.4070305@linux.vnet.ibm.com>
Date: Fri, 23 Mar 2012 11:54:10 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Chris Zankel <chris@zankel.net>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] config: simplify INLINE_SPIN_UNLOCK
References: <20120322095502.30866.75756.sendpatchset@codeblue>
In-Reply-To: <20120322095502.30866.75756.sendpatchset@codeblue>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12032306-3864-0000-0000-000001FB1FEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 03:25 PM, Raghavendra K T wrote:
> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>
> Patch simplifies current INLINE_SPIN_UNLOCK. compile tested on x86_64
>
> Change log:
> get rid of INLINE_SPIN_UNLOCK entirely replacing it with UNINLINE_SPIN_UNLOCK
> instead with the reverse meaning.
>
> whover wants to uninline the spinlocks (like spinlock debugging, paravirt etc
> all just do select UNINLINE_SPIN_UNLOCK
typo:
Whoever wants to uninline the spinlocks (like spinlock debugging, 
paravirt etc) just do select UNINLINE_SPIN_UNLOCK.

>
> Suggested-by: Linus Torvalds<torvalds@linux-foundation.org>
> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
> ---
>   Please refer : https://lkml.org/lkml/2012/3/21/357

Linus, Please let me know if this is what you were looking for or Did I 
really mess it up :(


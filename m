Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab0E0Q5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:57:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21344 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab0E0Q5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:57:14 -0400
Date: Thu, 27 May 2010 09:55:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 2/4] [tip:x86/mm] Set first MB as RW+NX
Message-Id: <20100527095546.bb1bb941.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTin1B96oeU50v0FPSJcVVFEKYos8-jM_i9eRiKxF@mail.gmail.com>
References: <AANLkTin1B96oeU50v0FPSJcVVFEKYos8-jM_i9eRiKxF@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4BFEA423.0080:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Thu, 27 May 2010 12:52:21 -0400 Siarhei Liakh wrote:

> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index 4814d35..6dbcb6f 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -123,6 +123,17 @@ config DEBUG_NX_TEST
>          and the software setup of this feature.
>          If in doubt, say "N"
> 
> +config DEBUG_SET_1ST_MB_RWNX
> +       bool "Set 1st MB of kernel space mapping as RW+NX"
> +       default n
> +       depends on X86
> +       ---help---
> +         This option helps to catch unintended modifications/execution of
> +         1st megabyte of kernel address space. Such protection may interfere
> +         with run-time code patching and legacy BIOS services residing within
> +         the 1st MB of physical address space.
> +         If in doubt, say "N".

Please spell out "first" instead of "1st" (all places in user-visible text).

and gmail is space-stuffing your patches (converting tabs to spaces).
Not good.  Are you using the gmail web interface for patches?
That won't work AFAIK.  You'll need to use a real mail client.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

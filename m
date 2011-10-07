Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab1JGDSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:18:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53709 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab1JGDST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:18:19 -0400
Message-ID: <4E8E6F68.9050104@zytor.com>
Date: Thu, 06 Oct 2011 20:18:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Alex Ben <aleben358@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <Mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Removed superfluous parentheses in macro defs
References: <1317939724-27924-1-git-send-email-aleben358@gmail.com>
In-Reply-To: <1317939724-27924-1-git-send-email-aleben358@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 03:22 PM, Alex Ben wrote:
> 1) make it consistent with other constant macro deinitions, which
> don't have parentheses, as they are really superfluous.

Superfluous, yes, but it makes the expression read more regular.

> diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
> index 5e64171..92621c1 100644
> --- a/arch/x86/include/asm/segment.h
> +++ b/arch/x86/include/asm/segment.h
> @@ -10,7 +10,7 @@
> 	 (((flags) & _AC(0x0000f0ff,ULL)) << 40) |	\
> 	 (((limit) & _AC(0x000f0000,ULL)) << (48-16)) |	\
> 	 (((base)  & _AC(0x00ffffff,ULL)) << 16) |	\
> -	 (((limit) & _AC(0x0000ffff,ULL))))
> +	 ((limit)  & _AC(0x0000ffff,ULL)))
> 

So NAK.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab2APIll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 03:41:41 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55537 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2APIlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 03:41:40 -0500
X-AuditID: b753bd60-9fe84ba000000655-74-4f13e2c19bc9
X-AuditID: b753bd60-9fe84ba000000655-74-4f13e2c19bc9
Message-ID: <4F13E2BF.8050307@hitachi.com>
Date: Mon, 16 Jan 2012 17:41:35 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: Typo transferred from Intel manual
References: <CAOPLpQc_TfvtfJ0NL+4fsi2r_eW+4qWX+WbXrZ9BjGn44nAmBw@mail.gmail.com> <4F136FED.8090201@hitachi.com> <CAOPLpQfytPyDEBF1Hbkpo7ovUerEsstVGxBr=EpDL-BKEMaqLA@mail.gmail.com>
In-Reply-To: <CAOPLpQfytPyDEBF1Hbkpo7ovUerEsstVGxBr=EpDL-BKEMaqLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/16 9:40), Ulrich Drepper wrote:
> On Sun, Jan 15, 2012 at 19:31, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> Could you add a comment line above the fix in x86-opcode-map.txt?
>> I just consider the case that someone may confuse the fix itself
>> is typo.
> 
> Find the changed patch below.
> 
> 
> Signed-off-by: Ulrich Drepper <drepper@gmail.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
> diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
> index 5b83c51..c292885 100644
> --- a/arch/x86/lib/x86-opcode-map.txt
> +++ b/arch/x86/lib/x86-opcode-map.txt
> @@ -219,7 +219,9 @@ ab: STOS/W/D/Q Yv,rAX
>  ac: LODS/B AL,Xb
>  ad: LODS/W/D/Q rAX,Xv
>  ae: SCAS/B AL,Yb
> -af: SCAS/W/D/Q rAX,Xv
> +# Note: The May 2011 Intel manual shows Xv for the second parameter of the
> +# next instruction but Yv is correct
> +af: SCAS/W/D/Q rAX,Yv
>  # 0xb0 - 0xbf
>  b0: MOV AL/R8L,Ib
>  b1: MOV CL/R9L,Ib
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

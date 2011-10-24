Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab1JXOFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:05:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41560 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab1JXOFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:05:07 -0400
MIME-Version: 1.0
In-Reply-To: <4EA557B2.4020504@st.com>
References: <1319192888-21465-1-git-send-email-keguang.zhang@gmail.com>
	<1319192888-21465-2-git-send-email-keguang.zhang@gmail.com>
	<CAD+V5YKBkW52_md9rBeVZ1RXq2FGEXt=Ergsw+z8txMreZdNsA@mail.gmail.com>
	<4EA5117C.3000402@st.com>
	<CAJhJPsVSzXXmBOwLaGNtOsxhVEyC0fAJtiBvEWzcKcSDC8NEcA@mail.gmail.com>
	<4EA557B2.4020504@st.com>
Date: Mon, 24 Oct 2011 22:05:06 +0800
Message-ID: <CAJhJPsXxUAuF9HdivLd66MQC45mz-iYAuF1SdGdU=-duxJJ5bQ@mail.gmail.com>
Subject: Re: [PATCH V2 2/4] MIPS: Add board support for Loongson1B
From: Kelvin Cheung <keguang.zhang@gmail.com>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org, r0bertz@gentoo.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/24, Giuseppe CAVALLARO <peppe.cavallaro@st.com>:
> Hello Kelvin.
>
> On 10/24/2011 12:36 PM, Kelvin Cheung wrote:
>
> [snip]
>
>> According to datasheet of Loongson 1B, the buffer size in RX/TX
>> descriptor is only 2KB. So the Loongson1B's GMAC could not handle
>> jumbo frames. And the second buffer is useless in this case. Am I
>> right? Is there a better way than ifdef CONFIG_MACH_LOONGSON1 to
>> avoid duplicate code?
>
> Sorry for my misunderstanding.
>
> I think you have to use the normal descriptor and remove the enh_desc
> from the platform w/o modifying the driver at all.
>
> The driver will be able to select/configure all automatically (also jumbo).
>
> Let me know.

That's the problem.
The bitfield definition of Loongson1B is also different from normal descriptor.

Moreover, I want to enable the TX checksum offload function which is
not supported in normal descriptor.

Any suggestions?

> Note:
> IIRC, there is a bit difference in case of normal descriptors for
> Synopsys databook newer than the 1.91 (I used for testing this mode).
> In any case, I remember that, on some platforms, the normal descriptors
> have been used w/o problems also on these new chip generations.
>
> Peppe
>
>


-- 
Best Regards!
Kelvin

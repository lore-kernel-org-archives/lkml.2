Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab1JXMTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:19:10 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:55213 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932166Ab1JXMTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:19:09 -0400
Message-ID: <4EA557B2.4020504@st.com>
Date: Mon, 24 Oct 2011 14:18:58 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kelvin Cheung <keguang.zhang@gmail.com>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org, r0bertz@gentoo.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V2 2/4] MIPS: Add board support for Loongson1B
References: <1319192888-21465-1-git-send-email-keguang.zhang@gmail.com> <1319192888-21465-2-git-send-email-keguang.zhang@gmail.com> <CAD+V5YKBkW52_md9rBeVZ1RXq2FGEXt=Ergsw+z8txMreZdNsA@mail.gmail.com> <4EA5117C.3000402@st.com> <CAJhJPsVSzXXmBOwLaGNtOsxhVEyC0fAJtiBvEWzcKcSDC8NEcA@mail.gmail.com>
In-Reply-To: <CAJhJPsVSzXXmBOwLaGNtOsxhVEyC0fAJtiBvEWzcKcSDC8NEcA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kelvin.

On 10/24/2011 12:36 PM, Kelvin Cheung wrote:

[snip]

> According to datasheet of Loongson 1B, the buffer size in RX/TX 
> descriptor is only 2KB. So the Loongson1B's GMAC could not handle
> jumbo frames. And the second buffer is useless in this case. Am I
> right? Is there a better way than ifdef CONFIG_MACH_LOONGSON1 to
> avoid duplicate code?

Sorry for my misunderstanding.

I think you have to use the normal descriptor and remove the enh_desc
from the platform w/o modifying the driver at all.

The driver will be able to select/configure all automatically (also jumbo).

Let me know.

Note:
IIRC, there is a bit difference in case of normal descriptors for
Synopsys databook newer than the 1.91 (I used for testing this mode).
In any case, I remember that, on some platforms, the normal descriptors
have been used w/o problems also on these new chip generations.

Peppe


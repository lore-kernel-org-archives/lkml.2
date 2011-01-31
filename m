Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1AaOQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:16:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:55531 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1AaOQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:16:51 -0500
Subject: Re: [PATCH] a patch to fix the cpu-offline-online problem caused
 by pm_idle
From: Peter Zijlstra <peterz@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx <tglx@linutronix.de>
In-Reply-To: <AANLkTikwPq+vJEGyOrbS3hbPk6ygsmC8cxGun9-KGA6a@mail.gmail.com>
References: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
	 <1295894492.28776.470.camel@laptop>
	 <AANLkTimq3jmza-t5iL10wgLLycwdDkJ3mznLQsKHM_Kf@mail.gmail.com>
	 <1295946736.28776.479.camel@laptop>
	 <AANLkTikQs1UcfBGf_6shNVtdDSzR+8XzUKcx0amFZXey@mail.gmail.com>
	 <1296210619.15234.263.camel@laptop>
	 <AANLkTikagMAGssG09D+SCKTsu9T+==R2fsSM3tgHctdv@mail.gmail.com>
	 <1296405366.2274.60.camel@twins>
	 <AANLkTinxHXqndfP79W0=zer70psi6Dmkcv7rZc4ew7ZF@mail.gmail.com>
	 <1296469006.15234.359.camel@laptop>
	 <AANLkTikwPq+vJEGyOrbS3hbPk6ygsmC8cxGun9-KGA6a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 15:17:47 +0100
Message-ID: <1296483467.26581.26.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 09:10 -0500, Luming Yu wrote:
> 
> My understanding is if the heart of the problem is triggered by some
> hardware defects.
> And we could have no other clean option than a solution I proposed
> here. 

Well, a cleaner option is to limit NHM-EX hardware to C1 and simply
dis-allow anything deeper on it.

> Yes, I agree before say yes to a "workaround", we need to understand
> exactly what those side effects are. I will try to do research on all
> side effects caused by the ipi and c3 latency to tickless and highres
> kernel after one week vacation starting from Feb 1st.
> 
OK, great! and enjoy your time away from the computer ;-)


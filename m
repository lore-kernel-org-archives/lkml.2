Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab0H2JnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 05:43:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22334 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab0H2JnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 05:43:15 -0400
Date: Sun, 29 Aug 2010 18:43:25 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [GIT PULL] Samsung fixes for 2.6.36-rc3
In-reply-to: <AANLkTi=+XnCQu6Cz0P+A=qhaeN2HKJ9gYdTx2jWe7sfH@mail.gmail.com>
To: "'Kyungmin Park'" <kmpark@infradead.org>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-id: <000101cb475e$a364eef0$ea2eccd0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActGdZ7TO8Mcez3pRw2yfkYNHnnaswA42Hww
References: <006d01cb45cd$0e4e3610$2aeaa230$%kim@samsung.com>
 <AANLkTi=+XnCQu6Cz0P+A=qhaeN2HKJ9gYdTx2jWe7sfH@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park wrote:
> 
> On Fri, Aug 27, 2010 at 6:48 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > Hi Linus,
> >
> > Please pull Samsung fixes from:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> > s5p-fixes-for-linus
> >
> > These things are for bug fix on 2.6.36-rc3.
> > If any problems, please let me know.
> 
> Well nothing changed. only LSI codes and required things from LSI side
> are merged.

At this point, focus on getting the critical portions of S5PV310/S5PC210
into
the mainline. Once that is done, other features can be merged as required.

> And still need more patches for booting at s5pc210 (aka s5pv310).
> 
Thanks for your concern.
But I think it's enough just only one patch about following...
I know the problem that we cannot get the proper clock 'id' from clk_get()
in
the console_initcall(). This problem occurs when only defined 'uclk1' as
uart
clock. And to solve that will be submitted soon.

> Several thins are missed.
> 1. gpio_to_irq patch not included. it's basic gpiolib feature. Without
> this patch, it can't use the generic gpiolib based drivers. e.g.,
> gpio-keys.
> http://marc.info/?l=linux-arm-kernel&m=128202435823832&w=2
> 
I don't think so, 'gpio_to_irq' is a new feature not a bug fix.
So if required, will be merged at the merge window after review.

> 2. Wrong UART level triggers.
> At least s5pc110/s5pc210 has wrong UART trigger values compare to macro
name.
> http://marc.info/?l=linux-arm-kernel&m=128218476209330&w=2
> 
I couldn't find anywhere used it in the mainline. So I'm not sure we really
need it.

> 3. set correct gpio config at GPIO I at s5pc110
> http://marc.info/?l=linux-arm-kernel&m=128202423923745&w=2
> 
mm...I will sort this out.

(snip)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


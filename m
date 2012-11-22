Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab2KVUIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:08:35 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38375 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab2KVUIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:08:30 -0500
MIME-Version: 1.0
In-Reply-To: <000701cdc852$a5e4a130$f1ade390$%jun@samsung.com>
References: <1353535387-32106-1-git-send-email-dianders@chromium.org>
	<1353535387-32106-2-git-send-email-dianders@chromium.org>
	<000701cdc852$a5e4a130$f1ade390$%jun@samsung.com>
Date: Wed, 21 Nov 2012 20:33:55 -0800
X-Google-Sender-Auth: 9Xja4oYtxp7hWi9NR1IEV3jf_g4
Message-ID: <CAD=FV=Xz_nQSLqoR7TSd8vn5No9+TVa9q-hp1i0BpgUK=G3EoQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mmc: dw_mmc: Handle wp-gpios from device tree
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@imgtec.com>,
        Chris Ball <cjb@laptop.org>, Jaehoon Chung <jh80.chung@samsung.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 5:42 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> Hi,
>
> wp-gpios has been implemented in dw_mmc-exynos.c
> It can be reused for EXYNOS platform? We need to modify some though.

Yup, I've seen that.  Patch 1/2 ("mmc: dw_mmc: exynos: Stop claiming
wp-gpio") addressed that.  For some reason I can't find that on
LKML.org yet.  Strange.  :-/  I'll forward it on to you shortly.

In any case: I found that the exynos code didn't actually work.  It
claimed the GPIO but didn't ever look at it.

I have the beginnings of the code to implement this properly in the
exynos code but I stopped working on it when I decided that other SoCs
could also benefit from the code and it fit better in the general
dw_mmc driver.

If you disagree and would like me to cleanup the version of this patch
that's just in the exynos driver and post that, I will.  Just let me
know.


Thanks for the review!

-Doug

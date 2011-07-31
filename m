Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1GaAZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:25:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41856 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab1GaAY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:24:56 -0400
MIME-Version: 1.0
In-Reply-To: <c147ba3a755935e93fdb40b5531a6e18d34e0fd7.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<c147ba3a755935e93fdb40b5531a6e18d34e0fd7.1311936524.git.viresh.kumar@st.com>
Date: Sun, 31 Jul 2011 02:24:56 +0200
X-Google-Sender-Auth: kyUZ7aedHWfXUQbGLYLOkfE1s1E
Message-ID: <CAKnu2MrBB_QEn4Psa9aeyNLvF86oM-KnaNiFZ5=zMVkz_U5GOQ@mail.gmail.com>
Subject: Re: [PATCH 10/18] dmaengine/amba-pl08x: Get rid of pl08x_pre_boundary()
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: pratyush.anand@st.com, rajeev-dlh.kumar@st.com, linux@arm.linux.org.uk,
        bhupesh.sharma@st.com, shiraz.hashim@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/29 Viresh Kumar <viresh.kumar@st.com>:

> Based on above discussion, this patch removes all code related to 1 KB boundary
> as we are not required to handle this in driver.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

OMG yes that makes perfect sense. I questioned this in the past and was
pointed to the same manual page.

What is fun is that the code was written by ARM.

Let's merge this and I'll test it on the PB11MPCore, I think Mem2Mem
with the DMA engine compile-in tests may work on a few other boards as
well so maybe Russell can test it too.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

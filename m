Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1GaAlu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:41:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49299 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab1GaAlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:41:46 -0400
MIME-Version: 1.0
In-Reply-To: <5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com>
Date: Sun, 31 Jul 2011 02:41:45 +0200
X-Google-Sender-Auth: mQpKVs5tawSGxh854h_GqAMWlL8
Message-ID: <CAKnu2MpAc7n9VARyj0cB8mOmsEAcZWq4rrj8oJyMa4Lp9JAh+g@mail.gmail.com>
Subject: Re: [PATCH 16/18] dmaengine/amba-pl08x: Add support for sg len
 greater than one for slave transfers
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

> Untill now, sg_len greater than one is not supported. This patch adds support to
> do that.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Thanks, was on my TODO once.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

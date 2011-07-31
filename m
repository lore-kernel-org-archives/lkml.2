Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1GaApk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:45:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59527 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1GaApg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:45:36 -0400
MIME-Version: 1.0
In-Reply-To: <90793b4b9824f8152aa4cea07fd91a8ecd3481e8.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<90793b4b9824f8152aa4cea07fd91a8ecd3481e8.1311936524.git.viresh.kumar@st.com>
Date: Sun, 31 Jul 2011 02:45:35 +0200
X-Google-Sender-Auth: jspleqZIkTf0JTffl2gWlE3o4zE
Message-ID: <CAKnu2MqGpbVSkuuPCZoqXw+8-RVDFFf7ju4pGaGZ9vLOXRLVhQ@mail.gmail.com>
Subject: Re: [PATCH 18/18] dmaengine/amba-pl08x: Call pl08x_free_txd() instead
 of calling kfree() directly
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, armando.visconti@st.com, shiraz.hashim@st.com,
        vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
        vipulkumar.samar@st.com, amit.virdi@st.com, pratyush.anand@st.com,
        bhupesh.sharma@st.com, viresh.linux@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/29 Viresh Kumar <viresh.kumar@st.com>:

> pl08x_prep_channel_resources() is calling kfree() directly for txd(). To
> maintain consistency in code call pl08x_free_txd() instead.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Good idea,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

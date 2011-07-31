Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1GaAob (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:44:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34654 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1GaAo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:44:27 -0400
MIME-Version: 1.0
In-Reply-To: <1ce7eda8117f76d1e9d35bcf59d188351d1b9465.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<1ce7eda8117f76d1e9d35bcf59d188351d1b9465.1311936524.git.viresh.kumar@st.com>
Date: Sun, 31 Jul 2011 02:44:26 +0200
X-Google-Sender-Auth: BC1nm4tY5kQnAkTvkHwyDjKAqUw
Message-ID: <CAKnu2MqxONZr2aKwq0AZbMqsKwiviqUkFF7=mburoXnKQticeQ@mail.gmail.com>
Subject: Re: [PATCH 17/18] dmaengine/amba-pl08x: Check txd->llis_va before
 freeing dma_pool
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

> In pl08x_free_txd(), check if pool is allocated successfully before freeing it.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Looks like a good idea.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

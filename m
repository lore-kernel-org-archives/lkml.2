Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab1GaAgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:36:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39980 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab1GaAgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <c1cb9cd2abc64b4efdc3648896324a1821fdba3e.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<c1cb9cd2abc64b4efdc3648896324a1821fdba3e.1311936524.git.viresh.kumar@st.com>
Date: Sun, 31 Jul 2011 02:36:20 +0200
X-Google-Sender-Auth: MRi0w9hTQ_nA8ywD3XlQ3xTpMvg
Message-ID: <CAKnu2MobiWWL_sC2vGE5bUM-n_uG+awVHAJVyjjxYTBcjXHGUA@mail.gmail.com>
Subject: Re: [PATCH 14/18] dmaengine/amba-pl08x: Choose peripheral bus as
 master bus
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

> When we have DMA transfers between peripheral and memory, then we shouldn't
> reduce width of peripheral at all, as that may be a strict requirement. But we
> can always reduce width of memory access, with some compromise in performance.
> Thus, we must select peripheral as master and not memory.
>
> Also this rearranges code to make it shorter.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Looks correct to me!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij

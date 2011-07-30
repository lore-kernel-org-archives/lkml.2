Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1G3WgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:36:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33268 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab1G3WgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:36:14 -0400
MIME-Version: 1.0
In-Reply-To: <88035b0bd1f3fd755b6a157193c39477e21ec60a.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<88035b0bd1f3fd755b6a157193c39477e21ec60a.1311936524.git.viresh.kumar@st.com>
Date: Sun, 31 Jul 2011 00:36:14 +0200
X-Google-Sender-Auth: Gd56JIu9_HEh1smP5pm5PaKyEj0
Message-ID: <CAKnu2MoHSVae6N=CA-zi3CpaqOrEOqbPCL=orfs5zgxAUOmSnQ@mail.gmail.com>
Subject: Re: [PATCH 06/18] dmaengine/amba-pl08x: Simplify pl08x_ensure_on()
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

> Simply writing 1 on bit 0 is sufficient instead of reading and clearing bits.
> Also as per manual, for bit 3-31 of DMACConfiguration register:
> "read undefined, write as 0"
>
> So, we must not rely on values read from this registers bit 3-31.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Obviously correct,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij

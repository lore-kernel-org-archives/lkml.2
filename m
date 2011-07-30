Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1G3We7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:34:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38786 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1G3We3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:34:29 -0400
MIME-Version: 1.0
In-Reply-To: <7ef7d86e78a74b140c7c5a87fd2b7a117120ce6f.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<7ef7d86e78a74b140c7c5a87fd2b7a117120ce6f.1311936524.git.viresh.kumar@st.com>
Date: Sun, 31 Jul 2011 00:34:28 +0200
Message-ID: <CAKnu2Mr-GE3o1zQ+Rg=drzJ9U=PoGAXMx6iR43ds0CWmU1sFcw@mail.gmail.com>
Subject: Re: [PATCH 05/18] dmaengine/amba-pl08x: Changing few prints to
 dev_dbg from dev_info
From: Linus Walleij <linus.ml.walleij@gmail.com>
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

> For 8 memory and 16 slave channels 35 boot print lines are printed. And that is
> too much. Most of this would be more useful for debugging. So moving few of them
> to dev_dbg instead of dev_info. Now only 3 prints will be printed.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Oh I really liked these prints but whatever.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij

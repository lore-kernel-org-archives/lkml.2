Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab1GaAaM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:30:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37875 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1GaAaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:30:02 -0400
MIME-Version: 1.0
In-Reply-To: <afe9e5154d96c0f44c64c411c98b5db75969db6c.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<afe9e5154d96c0f44c64c411c98b5db75969db6c.1311936524.git.viresh.kumar@st.com>
Date: Sun, 31 Jul 2011 02:30:01 +0200
X-Google-Sender-Auth: 4v-1IKrmo1Ft2exEYu7cDbEaILo
Message-ID: <CAKnu2MobCaCNLf_GTm=1T=nBWB8pe8_dYQUx77XKnceNGtGogw@mail.gmail.com>
Subject: Re: [PATCH 13/18] dmaengine/amba-pl08x: Align lli_len to
 max(src.width, dst.width)
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

> Currently lli_len is aligned to min of two widths, which looks to be incorrect.
> Instead it should be aligned to max of both widths.

Again, a great and well researched patch.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

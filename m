Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1GaAJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:09:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42763 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1GaAJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:09:33 -0400
MIME-Version: 1.0
In-Reply-To: <1e1f287888a2ce9affdcbded8f63028fa3f6b09b.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<1e1f287888a2ce9affdcbded8f63028fa3f6b09b.1311936524.git.viresh.kumar@st.com>
Date: Sun, 31 Jul 2011 02:09:33 +0200
X-Google-Sender-Auth: YGd__lBiDbxM-EFf5T7uMf9Rkg8
Message-ID: <CAKnu2MrtC9uqguPKFXYJnzys6hMMnMU9eBsGQ0DXkP67ZzOnVA@mail.gmail.com>
Subject: Re: [PATCH 08/18] dmaengine/amba-pl08x: No need to check "ch->signal
 < 0"
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, armando.visconti@st.com, shiraz.hashim@st.com,
        vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
        vipulkumar.samar@st.com, amit.virdi@st.com, pratyush.anand@st.com,
        bhupesh.sharma@st.com, viresh.linux@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/29 Viresh Kumar <viresh.kumar@st.com>:

> We have just executed following in pl08x_get_phy_channel():
>        ch->signal = -1;
> We don't have to compare "ch->signal < 0", as this will always be true.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij

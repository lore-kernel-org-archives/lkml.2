Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1G3WQh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:16:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35771 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1G3WQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:16:32 -0400
MIME-Version: 1.0
In-Reply-To: <cbd8c0a36115615ea0d80055de7a27ef1b8b7ce6.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<cbd8c0a36115615ea0d80055de7a27ef1b8b7ce6.1311936524.git.viresh.kumar@st.com>
Date: Sun, 31 Jul 2011 00:16:31 +0200
X-Google-Sender-Auth: Wko4KlP33JEYtN1I4ds8kqmjF4w
Message-ID: <CAKnu2Mo9ABNfePnSfKjZeOtHr0JpkGO76x+=qtQp+XaEdtWWVA@mail.gmail.com>
Subject: Re: [PATCH 01/18] ARM: asm/pl080.h: Protect against multiple
 inclusion of header file
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

> <asm/hardware/pl080.h> doesn't have protection to deal with multiple inclusion.
> And so we get compilation errors in cases where this file is included more than
> once. This patch adds #ifdefs at the top of file to protect it against multiple
> inclusions.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Good idea.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij

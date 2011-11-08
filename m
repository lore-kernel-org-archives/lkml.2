Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1KHIgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:36:18 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50040 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1KHIgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:36:16 -0500
MIME-Version: 1.0
In-Reply-To: <5366f62b74861af357a0aecdb4e27aa69ffd703b.1320312035.git.viresh.kumar@st.com>
References: <5366f62b74861af357a0aecdb4e27aa69ffd703b.1320312035.git.viresh.kumar@st.com>
Date: Tue, 8 Nov 2011 09:36:15 +0100
Message-ID: <CACRpkdauQfvCNxrqNOZrCfKsW-7Ntq-Y3g-O59H2O-hB8N7nqg@mail.gmail.com>
Subject: Re: [PATCH] mfd/stmpe: Add support for irq over gpio pin
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: rabin.vincent@stericsson.com, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, armando.visconti@st.com, shiraz.hashim@st.com,
        vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
        vipulkumar.samar@st.com, amit.virdi@st.com, pratyush.anand@st.com,
        bhupesh.sharma@st.com, viresh.linux@gmail.com, bhavna.yadav@st.com,
        vincenzo.frascino@st.com, mirko.gardi@st.com,
        srinidhi.kasagar@stericsson.com, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 3, 2011 at 10:26 AM, Viresh Kumar <viresh.kumar@st.com> wrote:

> On many boards, stmpe is present as an separate device (not as part of SoC).
> Here gpio lines are mostly used for getting interrupts. This patch adds in
> support to handle irq over gpio pin.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

OK looks good now!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij

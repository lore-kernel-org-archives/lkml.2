Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab1KSWGt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 17:06:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55646 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab1KSWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 17:06:47 -0500
MIME-Version: 1.0
In-Reply-To: <ae47c7f2f31276ffb2b8db132bcabe80aa1139f6.1321609430.git.viresh.kumar@st.com>
References: <ae47c7f2f31276ffb2b8db132bcabe80aa1139f6.1321609430.git.viresh.kumar@st.com>
Date: Sat, 19 Nov 2011 23:06:47 +0100
X-Google-Sender-Auth: -GcfakxALcPXZ_dLQA3wbojej1E
Message-ID: <CAKnu2MoXs-LDm+9i30Cf1fQLu=emMQ74eWk_T0O_UMy=nFYtbA@mail.gmail.com>
Subject: Re: [PATCH V4] GPIO/pl061: Add suspend resume capability
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: baruch@tkos.co.il, grant.likely@secretlab.ca, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, armando.visconti@st.com,
        shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
        deepak.sikri@st.com, vipulkumar.samar@st.com, amit.virdi@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com, viresh.linux@gmail.com,
        bhavna.yadav@st.com, vincenzo.frascino@st.com, mirko.gardi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/18 Viresh Kumar <viresh.kumar@st.com>:

> From: Deepak Sikri <deepak.sikri@st.com>
>
> This patch adds the suspend and resume operations in the driver. The patch
> ensures the data save and restore for the device registers during the
> suspend and resume operations respectively.
>
> Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> Acked-by: Baruch Siach <baruch@tkos.co.il>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Remember to ask Grant to pull or apply this patch for-next when
he's back, since he's not reading mail for a while.

Thanks,
Linus Walleij

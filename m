Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab1KQJMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:12:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58941 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1KQJMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:12:03 -0500
MIME-Version: 1.0
In-Reply-To: <819ee48f8520045337359a73283333031d2feea8.1321507421.git.viresh.kumar@st.com>
References: <cover.1321507421.git.viresh.kumar@st.com>
	<819ee48f8520045337359a73283333031d2feea8.1321507421.git.viresh.kumar@st.com>
Date: Thu, 17 Nov 2011 10:12:02 +0100
Message-ID: <CACRpkdYauBT9yMVWW-JzH+7-Z4Cscnwtf-kUvst2dhOqAqaryg@mail.gmail.com>
Subject: Re: [PATCH V2 3/5] mfd/stmpe: Add support for stmpe variant 610
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: rabin.vincent@stericsson.com, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, armando.visconti@st.com,
        shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
        deepak.sikri@st.com, vipulkumar.samar@st.com, amit.virdi@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com, viresh.linux@gmail.com,
        bhavna.yadav@st.com, vincenzo.frascino@st.com, mirko.gardi@st.com,
        grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 6:32 AM, Viresh Kumar <viresh.kumar@st.com> wrote:

> STMPE610 is very much like STMPE811, except the number of gpio pins, which is 8
> in 811 and 6 in 610. This patch adds support for variant 610. STMPE610 will
> share most of the code with STMPE811.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab2ASRB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:01:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47867 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab2ASRBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:01:22 -0500
MIME-Version: 1.0
In-Reply-To: <0bf6d205db66a2e3b8b669f1afdef39788572814.1326876464.git.viresh.kumar@st.com>
References: <cover.1326876464.git.viresh.kumar@st.com>
	<0bf6d205db66a2e3b8b669f1afdef39788572814.1326876464.git.viresh.kumar@st.com>
Date: Thu, 19 Jan 2012 18:01:21 +0100
Message-ID: <CACRpkdYuiZk7=V2WvNUJX=b_2hv2=eooGUq__Bz_r8b3JMmgew@mail.gmail.com>
Subject: Re: [PATCH V2 04/12] dmaengine/amba-pl08x: Take flow controller info
 from DMA_SLAVE_CONFIG
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, cjb@laptop.org,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        egtvedt@samfundet.no, hskinnemoen@gmail.com, kernel@pengutronix.de,
        perex@perex.cz, linux-arm-kernel@lists.infradead.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com, bhavna.yadav@st.com, vincenzo.frascino@st.com,
        mirko.gardi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 10:11 AM, Viresh Kumar <viresh.kumar@st.com> wrote:

> Flow controller information is passed now from DMA_SLAVE_CONFIG option. This
> patch makes changes in pl08x driver to use device_fc from it instead of platform
> data.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Viresh,
Linus Walleij

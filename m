Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1K2Iln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 03:41:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49821 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1K2Ilm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 03:41:42 -0500
MIME-Version: 1.0
In-Reply-To: <fc4d77e6355cc462cfc2e700415cd56b9db816cb.1322551469.git.viresh.kumar@st.com>
References: <fc4d77e6355cc462cfc2e700415cd56b9db816cb.1322551469.git.viresh.kumar@st.com>
Date: Tue, 29 Nov 2011 09:41:41 +0100
Message-ID: <CACRpkdZASL_TKjX+w=+Y9qutJKSk1JNd0Vou3iZXDXO9+td9Yw@mail.gmail.com>
Subject: Re: [PATCH] dmaengine/amba-pl08x: Config ccfg and increment
 phychan_hold if phychan is true
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, armando.visconti@st.com, shiraz.hashim@st.com,
        vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
        vipulkumar.samar@st.com, amit.virdi@st.com, pratyush.anand@st.com,
        bhupesh.sharma@st.com, viresh.linux@gmail.com, bhavna.yadav@st.com,
        vincenzo.frascino@st.com, mirko.gardi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 8:26 AM, Viresh Kumar <viresh.kumar@st.com> wrote:

> Currently, if plchan->phychan is true, we return immediately from
> prep_phy_chan(). We must configure txd->ccfg and increment phychan_hold before
> returning. Otherwise, request line number wouldn't be configured in this txd.
>
> Reported-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij

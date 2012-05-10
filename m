Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2EJB2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 21:28:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45049 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab2EJB2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 21:28:23 -0400
Date: Wed, 09 May 2012 21:22:15 -0400 (EDT)
Message-Id: <20120509.212215.1769935497710663262.davem@davemloft.net>
To: viresh.kumar@st.com
Cc: akpm@linux-foundation.org, spear-devel@list.st.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        linux@arm.linux.org.uk, w.sang@pengutronix.de, LW@KARO-electronics.de,
        andrew@lunn.ch, bhupesh.sharma@st.com
Subject: Re: [PATCH V3 Resend 08/12] net/c_can: Remove conditional
 compilation of clk code
From: David Miller <davem@davemloft.net>
In-Reply-To: <5bde77a369c9bf2eb2efbd9f8d139443336ff849.1336448639.git.viresh.kumar@st.com>
References: <cover.1336448639.git.viresh.kumar@st.com>
	<5bde77a369c9bf2eb2efbd9f8d139443336ff849.1336448639.git.viresh.kumar@st.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 09 May 2012 18:22:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@st.com>
Date: Tue, 8 May 2012 09:22:35 +0530

> With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in clk.h,
> there is no need to have clk code enclosed in #ifdef CONFIG_HAVE_CLK, #endif
> macros.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Acked-by: David S. Miller <davem@davemloft.net>

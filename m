Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2EJB2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 21:28:39 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45055 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2EJB2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 21:28:37 -0400
Date: Wed, 09 May 2012 21:22:43 -0400 (EDT)
Message-Id: <20120509.212243.1590217502497756920.davem@davemloft.net>
To: viresh.kumar@st.com
Cc: akpm@linux-foundation.org, spear-devel@list.st.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        linux@arm.linux.org.uk, w.sang@pengutronix.de, LW@KARO-electronics.de,
        andrew@lunn.ch, peppe.cavallaro@st.com, netdev@vger.kernel.org
Subject: Re: [PATCH V3 Resend 09/12] net/stmmac: Remove conditional
 compilation of clk code
From: David Miller <davem@davemloft.net>
In-Reply-To: <8e66b900fe5ee10c8db93d2f12c912e3dfb0708f.1336448639.git.viresh.kumar@st.com>
References: <cover.1336448639.git.viresh.kumar@st.com>
	<8e66b900fe5ee10c8db93d2f12c912e3dfb0708f.1336448639.git.viresh.kumar@st.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 09 May 2012 18:22:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@st.com>
Date: Tue, 8 May 2012 09:22:36 +0530

> With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in clk.h,
> there is no need to have clk code enclosed in #ifdef CONFIG_HAVE_CLK, #endif
> macros.
> 
> This also fixes error paths of probe(), as a goto is required in this patch.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Acked-by: David S. Miller <davem@davemloft.net>

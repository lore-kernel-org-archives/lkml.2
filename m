Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567Ab2DLHYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 03:24:35 -0400
Received: from londo.lunn.ch ([80.238.139.98]:51677 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2DLHYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 03:24:34 -0400
Date: Thu, 12 Apr 2012 09:24:29 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Mike Turquette <mturquette@linaro.org>
Cc: arnd.bergmann@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Lunn <andrew@lunn.ch>, Rajendra Nayak <rnayak@ti.com>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: Re: [PATCH 01/13] clk: core: correct clk_set_rate kerneldoc
Message-ID: <20120412072429.GI18675@lunn.ch>
Mail-Followup-To: Mike Turquette <mturquette@linaro.org>,
	arnd.bergmann@linaro.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
	patches@linaro.org, Olof Johansson <olof@lixom.net>,
	Russell King <linux@arm.linux.org.uk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Shawn Guo <shawn.guo@freescale.com>,
	Richard Zhao <richard.zhao@linaro.org>,
	Saravana Kannan <skannan@codeaurora.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Andrew Lunn <andrew@lunn.ch>, Rajendra Nayak <rnayak@ti.com>,
	Viresh Kumar <viresh.kumar@st.com>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
 <1334192572-12499-2-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334192572-12499-2-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike

A general question to all these patches.

Do you want to get them into 3.4-rc, or linux-next?

   Thanks
	Andrew

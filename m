Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab2AMOmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 09:42:42 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57318 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab2AMOmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:42:38 -0500
Date: Fri, 13 Jan 2012 22:53:24 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Turquette, Mike" <mturquette@ti.com>, Rob Herring <robherring2@gmail.com>,
        andrew@lunn.ch, linaro-dev@lists.linaro.org, eric.miao@linaro.org,
        grant.likely@secretlab.ca, amit.kucheria@linaro.org,
        jeremy.kerr@canonical.com, linux@arm.linux.org.uk, sboyd@quicinc.com,
        magnus.damm@gmail.com, dsaxena@linaro.org,
        linux-arm-kernel@lists.infradead.org, arnd.bergmann@linaro.org,
        patches@linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-omap@vger.kernel.org, richard.zhao@linaro.org,
        shawn.guo@freescale.com, paul@pwsan.com, linus.walleij@stericsson.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@google.com>,
        Richard Zhao <richard.zhao@freescale.com>, skannan@quicinc.com
Subject: Re: [PATCH v4 3/6] clk: introduce the common clock framework
Message-ID: <20120113145321.GB1810@S2101-09.ap.freescale.net>
References: <1323834838-2206-1-git-send-email-mturquette@linaro.org>
 <1323834838-2206-4-git-send-email-mturquette@linaro.org>
 <alpine.LFD.2.02.1112141007550.3020@ionos>
 <CAJOA=zO=gM2r4pCVo+orLqE9Q1SSw4h5nXsAHo-e_SHZAfvKDA@mail.gmail.com>
 <20120104021541.GI2414@b20223-02.ap.freescale.net>
 <4F0462FF.1000308@gmail.com>
 <CAJOA=zPw7UuhE4R3SsBeyzQ2_iN29Zv-ExaUTTFCah+GoFSfNQ@mail.gmail.com>
 <4F0506D0.30109@gmail.com>
 <CAJOA=zPgwiOSoyZK1SpzZVZfTOmwruTR=WO+gRdVZrZVzNuPSA@mail.gmail.com>
 <4F0F7507.3080501@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0F7507.3080501@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 04:04:23PM -0800, Saravana Kannan wrote:
> While the original clk_hw suggestion was well intentioned, it just
> forces too many unnecessary dereferences and indirection. It also
> prevents static init of some fields as others have mentioned.
> Overall, it made the MSM clock code a mess when I tried to convert
> it to the common clock framework during Linaro Connect Q4 2011.
> 
> The current off-tree MSM clock code uses a very similar approach to
> what the original patches that Jeremy sent out did. When Mike sent
> out the patches that removed clk_hw, the MSM code was much clearer
> and easier to convert to the common clock framework.
> 
I share the same feeling with migrating imx6 clock support to v2 and
v3 of this series.  (v2 uses clk_hw, and v3 removes clk_hw.)

-- 
Regards,
Shawn

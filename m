Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761725Ab2DLHiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 03:38:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49092 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2DLHiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 03:38:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120412072429.GI18675@lunn.ch>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
	<1334192572-12499-2-git-send-email-mturquette@linaro.org>
	<20120412072429.GI18675@lunn.ch>
Date: Thu, 12 Apr 2012 10:38:08 +0300
X-Google-Sender-Auth: l5eizmetSNVAsy22F8tm7vxIT8E
Message-ID: <CAHLCerOC8j8bw15xwWbsnHCXEfuQjgjfUETUJp1zvm5gyoBECA@mail.gmail.com>
Subject: Re: [PATCH 01/13] clk: core: correct clk_set_rate kerneldoc
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Mike Turquette <mturquette@linaro.org>, arnd.bergmann@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Lunn <andrew@lunn.ch>, Rajendra Nayak <rnayak@ti.com>,
        Viresh Kumar <viresh.kumar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 10:24 AM, Andrew Lunn <andrew@lunn.ch> wrote:
> Hi Mike
>
> A general question to all these patches.
>
> Do you want to get them into 3.4-rc, or linux-next?
>
>   Thanks
>        Andrew

In 0/13, I think he did ask Arnd to take these in for 3.4-rc even if
they are not strictly bug fixes, since this is a new framework. Up to
the arm-soc maintainers now.

/Amit

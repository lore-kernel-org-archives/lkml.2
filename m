Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2KVSli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:41:38 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:34802
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201Ab2KVSlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:41:35 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(za62pz98dI1432Izz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 22 Nov 2012 14:12:41 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH v2 1/3] CLK: get rid of HAVE_CLK_PREPARE
Message-ID: <20121122061238.GB24693@S2100-06.ap.freescale.net>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
 <1353562482-12422-1-git-send-email-dmitry.torokhov@gmail.com>
 <1353562482-12422-2-git-send-email-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1353562482-12422-2-git-send-email-dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 09:34:40PM -0800, Dmitry Torokhov wrote:
> HAVE_CLK_PREPARE is automatically selected by COMMON_CLK and the only
> platform that explicitly selects HAVE_CLK_PREPARE is MXS which has been
> switched to common clk framework, so we can delete this option now.
> 
> As part of this change we move declarations of clk_prepare() and
> clk_unprepare() under HAVE_CLK and provide stubs if this option is not
> enabled.
> 
> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>


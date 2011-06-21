Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab1FULKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 07:10:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48842 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756014Ab1FULKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 07:10:12 -0400
Date: Tue, 21 Jun 2011 12:10:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, myungjoo.ham@gmail.com,
        dg77.kim@samsung.com
Subject: Re: [PATCH v2 1/4] Exynos4 NURI: configure regulators and PMIC
Message-ID: <20110621111010.GH22177@opensource.wolfsonmicro.com>
References: <20110620103124.GD31864@opensource.wolfsonmicro.com>
 <1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com>
 <1308622033-2521-2-git-send-email-myungjoo.ham@samsung.com>
 <4E002D18.2080401@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E002D18.2080401@linaro.org>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 11:03:12AM +0530, Tushar Behera wrote:

> Will it be possible to move PMIC specific defines to a common file
> and make appropriate calls in the board-specific file?

> In that way, we can re-use this PMIC code on some other boards (e.g.
> Insignal low-cost board Origen featuring Exynos4210 also features
> MAX8997).

If the board is similar enough in design to be sharing the PMIC code
that sounds like it should be sharing a lot more of the board setup
code.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab1FUL5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 07:57:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39625 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab1FUL5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 07:57:01 -0400
Date: Tue, 21 Jun 2011 12:56:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, dg77.kim@samsung.com,
        myungjoo.ham@gmail.com, Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/4] Exynos4 NURI: configure regulators and PMIC
Message-ID: <20110621115657.GE25032@sirena.org.uk>
References: <20110620103124.GD31864@opensource.wolfsonmicro.com> <1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com> <1308622033-2521-2-git-send-email-myungjoo.ham@samsung.com> <4E002D18.2080401@linaro.org> <20110621111010.GH22177@opensource.wolfsonmicro.com> <4E00853A.7010003@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E00853A.7010003@linaro.org>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 05:19:14PM +0530, Tushar Behera wrote:
> On Tuesday 21 June 2011 04:40 PM, Mark Brown wrote:

>> If the board is similar enough in design to be sharing the PMIC code
>> that sounds like it should be sharing a lot more of the board setup
>> code.

> Origen board details can be found at http://www.origenboard.org/

> Under 'Documents' section, there are some schematics for the board.

> As for other peripherals, I am not sure how much similar this is w.r.t.  
> NURI (I don't have NURI board schematics).

Right, and we can't really make the assessment about sharing the code if
we can't do a contrast and compare between the two schematics (or look
at the resulting code).

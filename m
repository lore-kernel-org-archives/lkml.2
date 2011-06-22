Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab1FVJRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:17:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19326 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1FVJRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:17:43 -0400
X-AuditID: cbfee61a-b7c59ae000003b70-a2-4e01b32891d3
Date: Wed, 22 Jun 2011 18:17:18 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH v2 1/4] Exynos4 NURI: configure regulators and PMIC
In-reply-to: <4E0164E8.8060708@linaro.org>
To: "'Tushar Behera'" <tushar.behera@linaro.org>, myungjoo.ham@gmail.com
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        dg77.kim@samsung.com
Message-id: <00bf01cc30bd$350b7fc0$9f227f40$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=UTF-8
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcwwjpnBQn22usCoRfOW5QU6EiJyCAALejGQ
References: <20110620103124.GD31864@opensource.wolfsonmicro.com>
 <1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com>
 <1308622033-2521-2-git-send-email-myungjoo.ham@samsung.com>
 <4E002D18.2080401@linaro.org>
 <BANLkTi=pv=y+1XC5bYEHgL1sy48JPztiOg@mail.gmail.com>
 <4E0164E8.8060708@linaro.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tushar Behera wrote:
> 
> On Wednesday 22 June 2011 08:01 AM, MyungJoo Ham wrote:
> > On Tue, Jun 21, 2011 at 2:33 PM, Tushar Behera<tushar.behera@linaro.org>
> wrote:
> >> On Tuesday 21 June 2011 07:37 AM, MyungJoo Ham wrote:
> >>>
> >>> Signed-off-by: MyungJoo Ham<myungjoo.ham@samsung.com>
> >>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> >>>
> >>> --
> >>> Changes from v1. Thanks so much for your valuable comments, Mark.
> >>> - Removed unnecessary initialization data
> >>> - Add __initdata where necessary
> >>> - Corrected a regulator name for ADC
> >>> ---
> >>>   arch/arm/mach-exynos4/mach-nuri.c |  622
> >>> ++++++++++++++++++++++++++++++++++++-
> >>>   1 files changed, 621 insertions(+), 1 deletions(-)
> >>>
> >> Will it be possible to move PMIC specific defines to a common file and make
> >> appropriate calls in the board-specific file?
> >>
> >> In that way, we can re-use this PMIC code on some other boards (e.g.
> >> Insignal low-cost board Origen featuring Exynos4210 also features MAX8997).
> >>
> >
> > Yes, we have tried creating PMIC defines at a seperated file in our
> > local repositories (still doing so in those repositories).
> > However, that ended up creating multiple PMIC defines (one PMIC define
> > file for each board); the connections between LDO# and devices are
> > different.
> >
> In that case, we can first post the Origen board support and PMIC code
> on the ML, then we would see if we can consolidate.
> 
> That looks more logical as per Mark's suggestion also.
> >>

Hi Tushar,

When you need to add similar or same functionality on your board, you can/should move it in common part.
Maybe 'should'...basically, nobody will apply same function into both place...

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


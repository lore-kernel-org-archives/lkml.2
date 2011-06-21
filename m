Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1FUFdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 01:33:22 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50058 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1FUFdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 01:33:20 -0400
Message-ID: <4E002D18.2080401@linaro.org>
Date: Tue, 21 Jun 2011 11:03:12 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: MyungJoo Ham <myungjoo.ham@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        myungjoo.ham@gmail.com, dg77.kim@samsung.com
Subject: Re: [PATCH v2 1/4] Exynos4 NURI: configure regulators and PMIC
References: <20110620103124.GD31864@opensource.wolfsonmicro.com> <1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com> <1308622033-2521-2-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1308622033-2521-2-git-send-email-myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 June 2011 07:37 AM, MyungJoo Ham wrote:
> Signed-off-by: MyungJoo Ham<myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>
> --
> Changes from v1. Thanks so much for your valuable comments, Mark.
> - Removed unnecessary initialization data
> - Add __initdata where necessary
> - Corrected a regulator name for ADC
> ---
>   arch/arm/mach-exynos4/mach-nuri.c |  622 ++++++++++++++++++++++++++++++++++++-
>   1 files changed, 621 insertions(+), 1 deletions(-)
>
Will it be possible to move PMIC specific defines to a common file and 
make appropriate calls in the board-specific file?

In that way, we can re-use this PMIC code on some other boards (e.g. 
Insignal low-cost board Origen featuring Exynos4210 also features MAX8997).


-- 
Tushar Behera

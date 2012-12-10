Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2LJJZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:25:23 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:52731 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674Ab2LJJZV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:25:21 -0500
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>, "cbou@mail.ru" <cbou@mail.ru>,
        "anton.vorontsov@linaro.org" <anton.vorontsov@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Date: Mon, 10 Dec 2012 10:24:38 +0100
Subject: RE: [PATCH 1/1] power/ab8500_charger: Use devm_regulator_get API
Thread-Topic: [PATCH 1/1] power/ab8500_charger: Use devm_regulator_get API
Thread-Index: Ac3UcnLs0Z3ikwVsQq22BoIB4IWl0gCRYoLA
Message-ID: <F45880696056844FA6A73F415B568C695BB09B0776@EXDCVYMBSTM006.EQ1STM.local>
References: <1354881208-9930-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1354881208-9930-1-git-send-email-sachin.kamat@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> devm_regulator_get() is device managed and makes error handling and code
> cleanup simpler.
> 
> Cc: Arun R Murthy <arun.murthy@stericsson.com>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> Compile tested using linux-next.
> ---
>  drivers/power/ab8500_charger.c |   11 +++--------
>  1 files changed, 3 insertions(+), 8 deletions(-)
> 

Acked-by: Arun Murthy <arun.murthy@stericsson.com>

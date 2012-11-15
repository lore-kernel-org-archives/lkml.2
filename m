Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768079Ab2KOOhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:37:34 -0500
Received: from antcom.de ([188.40.178.216]:44638 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993437Ab2KOOha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:37:30 -0500
Message-ID: <50A4FDED.8010408@antcom.de>
Date: Thu, 15 Nov 2012 15:36:29 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, jbe@pengutronix.de
Subject: Re: [PATCH] gpio: gpio-max710x: Support device tree probing
References: <1352987980-5112-1-git-send-email-stigge@antcom.de> <20121115141006.GB22896@pengutronix.de>
In-Reply-To: <20121115141006.GB22896@pengutronix.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/11/12 15:10, Wolfram Sang wrote:
> On Thu, Nov 15, 2012 at 02:59:40PM +0100, Roland Stigge wrote:
>> For probing via device tree, we need to support the case without
>> platform_data. In this case, chip.base is set to -1 for automatic
>> numbering.
>> 
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> Aren't there bindings for pullup configuration, top? Besides that:
> 
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Right. This is not supported yet by this binding. Should be added in a
subsequent patch.

Thanks,

Roland

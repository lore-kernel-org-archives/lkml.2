Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab0JFTpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 15:45:46 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:32973 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219Ab0JFTpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 15:45:45 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "lars\@metafoo.de" <lars@metafoo.de>,
        "kernel\@pengutronix.de" <kernel@pengutronix.de>,
        "philipp.zabel\@gmail.com" <philipp.zabel@gmail.com>,
        "robert.jarzmik\@free.fr" <robert.jarzmik@free.fr>,
        "marek.vasut\@gmail.com" <marek.vasut@gmail.com>,
        "eric.y.miao\@gmail.com" <eric.y.miao@gmail.com>,
        "rpurdie\@rpsys.net" <rpurdie@rpsys.net>,
        "sameo\@linux.intel.com" <sameo@linux.intel.com>,
        "kgene.kim\@samsung.com" <kgene.kim@samsung.com>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips\@linux-mips.org" <linux-mips@linux-mips.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "bgat\@billgatliff.com" <bgat@billgatliff.com>
Subject: Re: [PATCHv2 1/7] pwm: Add pwm core driver
Organization: Deep Root Systems, LLC
References: <1286280002-1636-1-git-send-email-arun.murthy@stericsson.com>
	<1286280002-1636-2-git-send-email-arun.murthy@stericsson.com>
	<20101005122225.6dda30ff.akpm@linux-foundation.org>
	<F45880696056844FA6A73F415B568C6953571D4F05@EXDCVYMBSTM006.EQ1STM.local>
Date: Wed, 06 Oct 2010 12:45:40 -0700
In-Reply-To: <F45880696056844FA6A73F415B568C6953571D4F05@EXDCVYMBSTM006.EQ1STM.local>
	(Arun MURTHY's message of "Wed, 6 Oct 2010 06:03:28 +0200")
Message-ID: <87ocb7jeaj.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun MURTHY <arun.murthy@stericsson.com> writes:

[...]

>> 
>> I suggest that you work on Kevin's comments before making any code
>> changes though.
>
> This pwm driver also supports the Davinci pwm driver as suggested by
> Kelvin.

My concern isn't whether it supports davinci or not.  Adapting existing
drivers is the easy part.

My concern is that there are now two proposals for a generic PWM
framework, and I would prefer to see that those projects are aligned
before anything merges.

Kevin

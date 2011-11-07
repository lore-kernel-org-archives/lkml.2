Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab1KGG1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 01:27:37 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:56315 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932224Ab1KGG1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 01:27:35 -0500
Message-ID: <4EB77A4F.5010007@ti.com>
Date: Mon, 07 Nov 2011 11:57:27 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        grant.likely@secretlab.ca, patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/4] regulator: helper routine to extract regulator_init_data
References: <1319721864-30067-1-git-send-email-rnayak@ti.com>	<20111104202905.GA3918@quad.lixom.net>	<20111104211447.GC2541@opensource.wolfsonmicro.com>	<20111104212216.GA5756@quad.lixom.net>	<20111104212910.GB8266@opensource.wolfsonmicro.com>	<CAOesGMgA7UayF9SJUP0YLnj86GmKBrajsBxv4_kRNNqCsvKTYg@mail.gmail.com>	<20111104214650.GC8266@opensource.wolfsonmicro.com> <CAOesGMjkcExKXhNN1nFGey=wBie0PQGp2XS_r-5Rr3X0p4eNhg@mail.gmail.com>
In-Reply-To: <CAOesGMjkcExKXhNN1nFGey=wBie0PQGp2XS_r-5Rr3X0p4eNhg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 November 2011 03:46 AM, Olof Johansson wrote:
>>> Yeah, ok, but it shouldn't be part of the description of regulator
>>> >>  properties per se. See how gpio does it, defining how a gpio-specifier
>>> >>  is crafted. The equivalent should be done for regulators.
>> >
>> >  That seems to be pretty much exactly what's being done here, and like
>> >  the GPIO bindings it's specified in the core document.  Though perhaps
>> >  there's some aspect of how the document is written that's missing.
 >
> Yep, sounds good. A slightly more elaborate description of the binding
> inspired by the gpio.txt document would be the way to do that.
>
Ok, will add more elaborate documentation for this in the core
bindings.

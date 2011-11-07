Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab1KGG1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 01:27:25 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:57314 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760Ab1KGG1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 01:27:23 -0500
Message-ID: <4EB77A43.8050206@ti.com>
Date: Mon, 07 Nov 2011 11:57:15 +0530
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
References: <1319721864-30067-1-git-send-email-rnayak@ti.com> <20111104202905.GA3918@quad.lixom.net> <20111104211447.GC2541@opensource.wolfsonmicro.com> <20111104212216.GA5756@quad.lixom.net>
In-Reply-To: <20111104212216.GA5756@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 November 2011 02:52 AM, Olof Johansson wrote:
>>> >  >  Also, lower-caps is common instead of V and A.
>> >
>> >  On the other hand the case is pretty important for SI units
> Yeah, true. The fixed regulators used microvolt instead, which could be a good
> way to do it.
>

Ok, will use microvolt and microamp across all bindings.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2AWTVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:21:49 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45740 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2AWTVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:21:47 -0500
Message-ID: <4F1DB34C.4030103@gmail.com>
Date: Mon, 23 Jan 2012 20:21:48 +0100
From: Karol Lewandowski <lmctlx@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Karol Lewandowski <k.lewandowsk@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 2/2] regulator: add device tree support for max8997
References: <1326353738-26864-1-git-send-email-thomas.abraham@linaro.org> <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org> <4F1D9DDE.2070106@samsung.com> <20120123182056.GA26409@opensource.wolfsonmicro.com>
In-Reply-To: <20120123182056.GA26409@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2012 07:20 PM, Mark Brown wrote:
> On Mon, Jan 23, 2012 at 06:50:22PM +0100, Karol Lewandowski wrote:
>
>> Aren't these fixed? i.e. - is it really needed to configure these
>> either by platform data or DT at all?
>>
>>
>> [1]
>>
>>  From 5cfba526210bc596c7d14e33fea93648baa0a227 Mon Sep 17 00:00:00 2001
>> From: Karol Lewandowski<k.lewandowsk@samsung.com>
>
> Documentation/SubmittingPatches please...

I should have stated explicitly that purpose of this patch (I should 
have called it sniplet) was to show my point only.

IMHO it's still up to debate how above problem should be solved.

I'm not entirely sure that we really need things like e.g. "EN32KHz AP" 
in DT (nor in platform data, for that matter).  I would like to see 
Thomas' opinion first.

Thanks

Regards,
Karol Lewandowski


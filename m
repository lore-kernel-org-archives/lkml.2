Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2HFIpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 04:45:08 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:35264 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753881Ab2HFIpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 04:45:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120730024049.GA10442@lizard>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
	<1343390750-3642-2-git-send-email-acourbot@nvidia.com>
	<20120727181923.GB23564@kroah.com>
	<5015E8AE.8060404@nvidia.com>
	<20120730024049.GA10442@lizard>
Date: Mon, 6 Aug 2012 10:45:02 +0200
Message-ID: <CAN5iSWokvOPa775CNF2XXeg4vM5QTmViJwH32J_=353ckFyt7A@mail.gmail.com>
Subject: Re: Gethering power management/policy hw drivers under
 drivers/power/? (Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences)
From: "Pihet-XID, Jean" <j-pihet@ti.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Alex Courbot <acourbot@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Liam Girdwood <lrg@ti.com>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        KEERTHY J <j-keerthy@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

Sorry for the late reply. I was away and back now.

On Mon, Jul 30, 2012 at 4:40 AM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Mon, Jul 30, 2012 at 10:51:42AM +0900, Alex Courbot wrote:
> [...]
>> On the other hand I have just noticed that the apparently unrelated
>> Adaptive Voltage Scaling driver just appeared in drivers/power/avs.
>> So if Anton and David are ok with this, maybe I could put the power
>> sequences code in its own subdirectory within drivers/power.
>
> Well, currently drivers/power/ is indeed just for power supply class
> subsystem and drivers. But if the trend is to gather power management
> ("policy") stuff under one directory, i.e.
>
> drivers/
>   power/
>     supplies/    <- former "power supply class and drivers"
>     regulators/
>     idle/
>     cpuidle/
>     cpufreq/
>     devfreq/
>     avs/
>     ...
>
> That would probably make sense, we could easily see the big picture.
> But if we're not going to do this long-term, I would suggest to stick
> to just a new directory under drivers (and move drivers/power/avs/ to
> drivers/avs).
>
> Cc'ing some more people...
>
> Thanks,
>
> p.s. Jean, why am I the last person who discovers drivers/power/avs/?
> Would be nice to Cc me on such patches; by moving AVS under
> drivers/power/ you effectively nominated me as its maintainer. :-)
Oops, I am really sorry about that ;-( . I wrongly assumed Rafael and
Greg KH were the contact persons for drivers/power and so I contacted
them before moving the code.

Thanks for letting me know. Are you ok with the changes? Let me know
if some more changes are needed.

Regards,
Jean

>
> --
> Anton Vorontsov
> Email: cbouatmailru@gmail.com

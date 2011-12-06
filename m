Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab1LFGyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:54:21 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:34473 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124Ab1LFGyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:54:17 -0500
Message-ID: <4EDDBC0E.7050806@ti.com>
Date: Tue, 06 Dec 2011 12:24:06 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Thomas Abraham <thomas.abraham@linaro.org>, grant.likely@secretlab.ca,
        robherring2@gmail.com, linaro-dev@lists.linaro.org, patches@linaro.org,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/4] regulator: helper routine to extract regulator_init_data
References: <1321615040-13257-1-git-send-email-rnayak@ti.com> <1321615040-13257-2-git-send-email-rnayak@ti.com> <CAJuYYwRO+AS=WmQfNAe8L6Gi5Dm4VsCuVqk3X5Nb8uUYAdLnJQ@mail.gmail.com> <20111204155433.GA16287@opensource.wolfsonmicro.com> <CAJuYYwQ-9wCu-+q0S2YYeFYemq74ULdZ-EwPGLWKHA4+0VZcsA@mail.gmail.com> <20111205103447.GC11150@opensource.wolfsonmicro.com> <CAJuYYwSRW-=XufvHS1miO2xNANwQMZqPbt=VyPEonywnAsvVUQ@mail.gmail.com> <20111205105733.GE11150@opensource.wolfsonmicro.com>
In-Reply-To: <20111205105733.GE11150@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 December 2011 04:27 PM, Mark Brown wrote:
> On Mon, Dec 05, 2011 at 04:14:40PM +0530, Thomas Abraham wrote:
>> On 5 December 2011 16:04, Mark Brown
>
>>> With the regulator device tree bindings if the regulator is configured
>>> to run a single voltage the bindings will set apply_uV unconditionally
>>> so there's no need for a separate constraint.
>
>> Sorry if I have missed this, but I could not find 'apply_uV' being set
>> as you described in the v5 of the regulator-dt patchset.
>
> Yes, looks like Rajendra missed that - just fixed it.

Thanks Mark, I certainly seem to have missed it.

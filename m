Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab1J0N1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 09:27:36 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:34579 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051Ab1J0N1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 09:27:34 -0400
Message-ID: <4EA95C38.2020804@ti.com>
Date: Thu, 27 Oct 2011 18:57:20 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com
Subject: Re: [PATCH v3 1/4] regulator: helper routine to extract regulator_init_data
References: <1319702185-16108-1-git-send-email-rnayak@ti.com> <1319702185-16108-2-git-send-email-rnayak@ti.com> <20111027080953.GB18360@opensource.wolfsonmicro.com> <CACYZBRG+_mm1O7Qg+ENCcLBX72iEWWyJohD_9EpAaT+Pb54cEA@mail.gmail.com> <20111027114935.GA7384@opensource.wolfsonmicro.com>
In-Reply-To: <20111027114935.GA7384@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 October 2011 05:19 PM, Mark Brown wrote:
> On Thu, Oct 27, 2011 at 04:13:08PM +0530, Nayak, Rajendra wrote:
>
>> okay, here's an updated patch which does that. I also added a binding to
>> specify a descriptive name to the regulator outputs as you suggested in
>> the other thread.
>
> Looks good!  I guess we may run into issues with the status change thing
> but I think we need to gather some experience to figure that out and
> since it's implicit hopefully that won't have any compatibility issues
> if it does happen.
>
> Acked-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
>
> I guess it might be useful to resend without this bit at the top to make
> it easier for Liam to apply.

Thanks Mark, just resent the patch with your Ack included.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1JJQel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:34:41 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:35285 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912Ab1JJQek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:34:40 -0400
Message-ID: <4E931E8F.9030808@ti.com>
Date: Mon, 10 Oct 2011 22:04:23 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] regulator: twl: Remove hardcoded board constraints
 from driver
References: <1318263578-7407-1-git-send-email-rnayak@ti.com> <1318263578-7407-2-git-send-email-rnayak@ti.com> <20111010162507.GF3607@opensource.wolfsonmicro.com>
In-Reply-To: <20111010162507.GF3607@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 October 2011 09:55 PM, Mark Brown wrote:
> On Mon, Oct 10, 2011 at 09:49:34PM +0530, Rajendra Nayak wrote:
>> Remove the hardcoded .valid_modes_mask and .valid_ops_mask for
>> each regulator from the twl driver and let the boards pass it.
>>
>> Signed-off-by: Rajendra Nayak<rnayak@ti.com>
>> Acked-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
>
> Please update this changelog - as I said in reply to your previous
> posting this isn't actually hardcoding anything, it's dropping things
> from the constraints which the hardware doesn't support.

Looks like I completely missed the "&=" and your comment
on the previous posting. Looking at it now, seems to me
this patch is just un-necessary and what the driver seems
to be doing (preventing users from setting flags which the
hardware does not support) seems perfectly fine.
I will just go ahead and drop this patch.



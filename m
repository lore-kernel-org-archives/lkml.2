Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1JXGCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 02:02:30 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:49499 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558Ab1JXGC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 02:02:29 -0400
Message-ID: <4EA4FF6B.2080906@ti.com>
Date: Mon, 24 Oct 2011 11:32:19 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract regulator_init_data
References: <1318263578-7407-1-git-send-email-rnayak@ti.com> <1318263578-7407-4-git-send-email-rnayak@ti.com> <20111018132032.GD30703@S2100-06.ap.freescale.net> <4E9EB61C.1040207@ti.com> <20111019144215.GA32007@S2100-06.ap.freescale.net> <4E9FAF42.5060200@ti.com> <20111020061408.GE32007@S2100-06.ap.freescale.net> <4EA00F7C.1080005@ti.com> <20111021082309.GA337@S2100-06.ap.freescale.net> <4EA13053.7080306@ti.com> <20111021115809.GB337@S2100-06.ap.freescale.net>
In-Reply-To: <20111021115809.GB337@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 October 2011 05:28 PM, Shawn Guo wrote:
> On Fri, Oct 21, 2011 at 02:11:55PM +0530, Rajendra Nayak wrote:
> [...]
>>> +       /* find device_node and attach it */
>>> +       rdev->dev.of_node = of_find_node_by_name(NULL, regulator_desc->name);
>>
>> so would this do a complete dt search for every regulator?
>
> Yes, with the first param being NULL, tthe entire device tree will be
> searched.
>
>> we would also need the driver names and dt names to match for this to
>> work, right?
>>
> Driver name does not matter.  The key for this search to work is having
> regulator's name (regulator_desc->name) match device tree node's name,
> case ignored.

Mark, whats your take on this? I am somehow not quite sure if we should
have this limitation put in to match DT node names with whats in the
driver structs (regulator_desc).

>
>> The approach otherwise looks fine to me and should work for both cases
>> of one device per regulator and one device for all regulators.
>>
>


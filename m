Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab0HEFnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:43:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:44213 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab0HEFnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:43:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,320,1278313200"; 
   d="scan'208";a="824892018"
Message-ID: <4C5A4F68.5030309@intel.com>
Date: Thu, 05 Aug 2010 13:43:04 +0800
From: Shuang He <shuang.he@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "Zou, Nanhai" <nanhai.zou@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: 2.6.35-rc6+: i915: Bisected regression
References: <201008011101.01429.thomas@m3y3r.de>	<4C555DA0.6020109@s5r6.in-berlin.de> <98E20220-BFC9-4231-AEF5-EB59588E6D2F@m3y3r.de>
In-Reply-To: <98E20220-BFC9-4231-AEF5-EB59588E6D2F@m3y3r.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 2010-8-1 18:51, Thomas Meyer wrote:
> Am 01.08.2010 um 13:42 schrieb Stefan Richter<stefanr@s5r6.in-berlin.de>:
>
>> Thomas Meyer wrote:
>>> This commit makes suspend to ram unreliable for me:
>>>
>>> commit d1b851fc0d105caa6b6e3e7c92d2987dfb52cbe0
>>> Author: Zou Nan hai<nanhai.zou@intel.com>
>>> Date:   Fri May 21 09:08:57 2010 +0800
>>>
>>>     drm/i915: implement BSD ring buffer V2
>>>
>>>     The BSD (bit stream decoder) ring is used for accessing the BSD engine
>>>     which decodes video bitstream for H.264 and VC1 on G45+.  It is
>>>     asynchronous with the render ring and has access to separate parts of
>>>     the GPU from it, though the render cache is coherent between the two.
>>>
>>>     Signed-off-by: Zou Nan hai<nanhai.zou@intel.com>
>>>     Signed-off-by: Xiang Hai hao<haihao.xiang@intel.com>
>>>     Signed-off-by: Eric Anholt<eric@anholt.net>
>>>
>>> git revert didn't work on 2.6.35-rc6 so I just changed the HAS_BSD thing to:
>>>
>>> #define HAS_BSD(dev)            (0)
>>>
>>> with this change applied suspend to ram is back to the reliability of 2.6.34.y
>>>
>>> with kind regards
>>> thomas
>> Added CCs.
>>
>> Thomas, on what hardware did you observe the regression?
> Is a Intel mobile express gm45 chipset.
>
>>   Is it suspend
>> or resume that is unreliable?
> suspend never finishes/hangs.
>
>>   What are the particular symptoms --- does
>> not suspend, crashes during suspend, crashes during resume...?
> Does not suspend, backlight is on.


Could you help report a bug for this issue by following 
http://intellinuxgraphics.org/how_to_report_bug.html

Thanks
     --Shuang

>> -- 
>> Stefan Richter
>> -=====-==-=- =--- ----=
>> http://arcgraph.de/sr/
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab0HAPSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 11:18:06 -0400
Received: from mx02.infracom.it ([62.196.48.10]:50117 "EHLO mx02.infracom.it"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757143Ab0HAPSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 11:18:04 -0400
Message-ID: <4C559022.1010406@gmail.com>
Date: Sun, 1 Aug 2010 17:17:54 +0200
From: Roberto Oppedisano <roberto.oppedisano@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100710 Thunderbird/3.1
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: Thomas Meyer <thomas@m3y3r.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zou Nan hai <nanhai.zou@intel.com>,
        "Xiang Hai hao" <haihao.xiang@intel.com>,
        Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: 2.6.35-rc6+: i915: Bisected regression
References: <201008011101.01429.thomas@m3y3r.de>	<4C555DA0.6020109@s5r6.in-berlin.de>	<98E20220-BFC9-4231-AEF5-EB59588E6D2F@m3y3r.de> <20100801151409.252be86b@tux.DEF.witbe.net>
In-Reply-To: <20100801151409.252be86b@tux.DEF.witbe.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 01/08/2010 15:14, Paul Rolland wrote:
> My machine has :
> 00:02.0 0300: 8086:2a42 (rev 07)
> 00:02.1 0380: 8086:2a43 (rev 07)
>
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
> 00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
>
> (Dell Vostro 1520, BIOS Revision A04)
>
>>>   Is it suspend
>>> or resume that is unreliable?
>> suspend never finishes/hangs.
> and is randomly suffering from exactly the same problems...
>
> So, I've applied your hint (in i915_drv.h), rebuilt a kernel, booted, and
> I've now successfully managed to go thru several suspend/resume cycles
> without having the machine hanging while suspend !
I have to add a me too (HP 6730B, same PCI ids).
I was suffering from the same problem which seem completely gone with 
the suggested hint.

R



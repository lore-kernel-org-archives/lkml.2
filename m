Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1H3BHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 21:07:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52422 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab1H3BHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 21:07:40 -0400
MIME-Version: 1.0
In-Reply-To: <4E59072A.5040108@gmail.com>
References: <4E506DEA.1070601@gmail.com>
	<20110821221602.GK25996@one.firstfloor.org>
	<4E53EB01.7080905@gmail.com>
	<987664A83D2D224EAE907B061CE93D5301EA5B717B@orsmsx505.amr.corp.intel.com>
	<4E59072A.5040108@gmail.com>
Date: Tue, 30 Aug 2011 09:07:39 +0800
Message-ID: <CAC=cRTNJgRfYk9qpeX4=8FtPSr-c0_MGr48VnOBrp01-d3yhWQ@mail.gmail.com>
Subject: Re: using mce_inject I get: RIP 10:<ffffffffa012c909>
 {ttm_bo_unref+0xf/0x45 [ttm]}
From: huang ying <huang.ying.caritas@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 11:03 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 08/23/2011 01:15 PM, Luck, Tony wrote:
>>>
>>> its easily fixable, but not sure its a good idea due to bisect going
>>> through commits(afraid I might go astray with the bisect if I add any
>>> patches).
>>
>> Rather than fixing a bad build - you can try moving to a nearby commit
>> (use "gitk" to get a view of the structure around the commit that git
>> bisect suggested).  In the early stages of a bisection, it doesn't really
>> matter much if you build the mid-point that bisect provided, or some
>> nearby on - just be sure to mark good/bad the commit you actually built.
>>
>> -Tony
>>
>>
>
> well.. after bisecting(with no results), I found that something in my
> .config was causing this, so after looking through, I found that having
> X86_MCE_INJECT = y causes the pauses when the timeouts occur
>
> let me know if I need to supply any info.

Which test case cause the pause?  Some test case with "timeout" in
name may cause timeout between CPUs.  Or you can try boot system with
kernel parameter "mce=3,0", which will disable timeout.

Best Regards,
Huang Ying

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1C1MEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 08:04:09 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:35459 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1C1MEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:04:07 -0400
Message-ID: <4D9078C1.2050207@snapgear.com>
Date: Mon, 28 Mar 2011 22:02:09 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: m68knommu: Convert to new irq function names
References: <alpine.LFD.2.00.1103251443180.31464@localhost6.localdomain6> <4D8FD892.3040200@snapgear.com> <alpine.LFD.2.00.1103281151450.31464@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103281151450.31464@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

On 28/03/11 19:53, Thomas Gleixner wrote:
> On Mon, 28 Mar 2011, Greg Ungerer wrote:
>> On 25/03/11 23:44, Thomas Gleixner wrote:
>>> Scripted conversion with coccinelle.
>>>
>>> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
>>
>> Looks good, and works fine after reworking for the m68k/m68knommu
>> merge. Do you want me to carry it for 2.6.40?
>
> That wants to go into .39 so we can get rid of all the compat cruft in
> the core code. I really want that to go away, otherwise I play the
> same cleanup game over and over.

Ok, no problem. I can send to Linus for 39.

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

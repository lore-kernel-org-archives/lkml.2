Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab1BJVI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:08:29 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:34402 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab1BJVI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:08:27 -0500
Message-ID: <4D5452E5.9080304@snapgear.com>
Date: Fri, 11 Feb 2011 07:04:37 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: manual merge of the tty tree with the m68knommu tree
References: <20110210162914.eec2f4b5.sfr@canb.auug.org.au> <20110210185115.GB15944@kroah.com>
In-Reply-To: <20110210185115.GB15944@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Feb 2011 21:05:28.0128 (UTC) FILETIME=[3E6BA400:01CBC966]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/11 04:51, Greg KH wrote:
> On Thu, Feb 10, 2011 at 04:29:14PM +1100, Stephen Rothwell wrote:
>> Hi Greg,
>>
>> Today's linux-next merge of the tty tree got a conflict in
>> drivers/tty/serial/68328serial.c between commit
>> abf67e214f867d16df6a9c4ac7d8fc0b98ebad97 ("m68knommu: fix derefernce of
>> port.tty") from the m68knommu tree and commit
>> f094298bae5f5d0e1cb3bff4621aae7ef486812a ("68328serial: remove unsed
>> m68k_serial->tqueue_hangup") from the tty tree.
>>
>> I just used the latter since it removed some of the code modified by the
>> former.
>
> Sounds fine, thanks.

The fix in commit abf67e214f867d16df6a9c4ac7d8fc0b98ebad97 ("m68knommu:
fix derefernce of port.tty") are needed to get that file to compile.
So I will be sending that to Linus for 2.6.38 (ie very soon).

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

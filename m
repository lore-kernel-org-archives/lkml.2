Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab0IXFby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 01:31:54 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:18932 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750898Ab0IXFbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 01:31:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBACfVm0xLd/sX/2dsb2JhbAAHgxSYV7svkiyBIoMtcwQ
X-IronPort-AV: E=Sophos;i="4.57,227,1283745600"; 
   d="scan'208";a="76605297"
Message-ID: <4C9C37B7.7060204@teksavvy.com>
Date: Fri, 24 Sep 2010 01:31:35 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stan Hoeppner <stan@hardwarefreak.com>
CC: Kyle McMartin <kyle@mcmartin.ca>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BF624.7090906@hardwarefreak.com> <20100924013748.GH13116@bombadil.infradead.org> <4C9C1F95.5000509@hardwarefreak.com>
In-Reply-To: <4C9C1F95.5000509@hardwarefreak.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-09-23 11:48 PM, Stan Hoeppner wrote:
> Kyle McMartin put forth on 9/23/2010 8:37 PM:
>> On Thu, Sep 23, 2010 at 07:51:48PM -0500, Stan Hoeppner wrote:
>>> ~$ man hdparm
>>>
>>
>> kyle@dreadnought ~ $ hdparm
>> hdparm - get/set hard disk parameters - version v9.27, by Mark Lord.
>>                                                         ^^^^^^^^^^^^
>> [...]
>
> Please pardon me while I wipe this egg off my face. :)
>
> My apologies Mark.  Please feel free to publicly flog me if you wish.

Chuckle.  :)

But you did manage to prompt me to remove that obsolete warning
from the --security-* commands in hdparm.  They are rather well tested
at this point in the game.

hdparm-9.31 is now released, with some fixes to --security,
and with the nasty warnings mostly removed.

Thanks!


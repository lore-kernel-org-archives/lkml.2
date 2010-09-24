Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0IXFCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 01:02:25 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43801 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab0IXFCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 01:02:24 -0400
Message-ID: <4C9C30D9.8090302@interlog.com>
Date: Fri, 24 Sep 2010 01:02:17 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Stan Hoeppner <stan@hardwarefreak.com>
CC: Kyle McMartin <kyle@mcmartin.ca>, Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BF624.7090906@hardwarefreak.com> <20100924013748.GH13116@bombadil.infradead.org> <4C9C1F95.5000509@hardwarefreak.com>
In-Reply-To: <4C9C1F95.5000509@hardwarefreak.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

I wonder if Mark every watched a program called
Sledge Hammer! whose signature line was "Trust me.
I know what I'm doing." Recently I needed to plead
with hdparm to corrupt a sector as follows:

# hdparm --make-bad-sector 976770000 --yes-i-know-what-i-am-doing /dev/sdb

Doug Gilbert

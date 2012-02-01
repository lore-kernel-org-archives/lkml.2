Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab2BAHUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:20:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51298 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab2BAHUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:20:15 -0500
Message-ID: <4F28E853.7000104@cn.fujitsu.com>
Date: Wed, 01 Feb 2012 15:22:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCH 4/6] netprio_cgroup: use IS_ENABLED() and family
References: <4F28E203.10502@cn.fujitsu.com>	<20120201.015954.2098592611164231843.davem@davemloft.net>	<4F28E48D.3040505@cn.fujitsu.com> <20120201.020738.1965865410881089752.davem@davemloft.net>
In-Reply-To: <20120201.020738.1965865410881089752.davem@davemloft.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-01 15:18:53,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-01 15:18:53,
	Serialize complete at 2012-02-01 15:18:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Do not mix genuine bug fixes and cleanups.
>>>
>>> Otherwise I cannot apply your bug fixes to the 'net' tree.
>>>
>>> Seperate things out, submit only pure bug fixes first, then
>>> later once those changes propagate you can submit the cleanups.
>>>
>>
>> I did seperate them out, so the first three patches are fixes,
>> and others are cleanups. I can resend cleanup patches once
>> fixes hit mainline.
> 
> Seperate them in different groups, don't submit them as one
> collection.  And definitely don't submit them all at the
> same damn time!  You have to wait with the dependent cleanups
> until the fixes go in, and subsequently show up in my net-next
> tree.
> 
> I'm not applying this stuff until you submit it properly, in
> two stages.
> 

I'll do this when I get some comments/acks.

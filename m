Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab1CDCBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 21:01:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62857 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759086Ab1CDCBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 21:01:40 -0500
Message-ID: <4D704888.7000707@cn.fujitsu.com>
Date: Fri, 04 Mar 2011 10:03:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Wolfram Sang <w.sang@pengutronix.de>, Jinqiu <crindy646@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Fix bug #13853: dereference pointer 'dev' before null
 check
References: <4D6EFAE5.4000400@gmail.com>	<4D6F01DA.3040307@cn.fujitsu.com>	<20110303081156.GA14163@pengutronix.de> <20110303084125.57f43b81.rdunlap@xenotime.net>
In-Reply-To: <20110303084125.57f43b81.rdunlap@xenotime.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 10:00:29,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 10:00:30,
	Serialize complete at 2011-03-04 10:00:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 3 Mar 2011 09:11:56 +0100 Wolfram Sang wrote:
> 
>> Hi,
>>
>>> Don't ever mention "bug #13853", because this number makes no sense
>>> for everyone except you. A proper subject may be:
>>>
>>> [PATCH] ariadne: fix possible null dereference.
>>
>> I agree for the subject line. Still, in the body or maybe after the "---" I'd
>> think it makes sense, so it is known there is a bugzilla entry to close? Also,
>> using search engines, one will be able to dig up the patch.
> 
> It should just refer to the full bugzilla #13853 URL:
> https://bugzilla.kernel.org/show_bug.cgi?id=13853
> 

Ok, then this should be made clear, for example add the URL in the changelog.


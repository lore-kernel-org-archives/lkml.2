Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab2EWBTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:19:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52203 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab2EWBTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:19:45 -0400
X-IronPort-AV: E=Sophos;i="4.75,642,1330876800"; 
   d="scan'208";a="5016066"
Message-ID: <4FBC3C07.5010201@cn.fujitsu.com>
Date: Wed, 23 May 2012 09:23:19 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: add max_addr boot option
References: <4FBB3A23.50102@cn.fujitsu.com> <4FBBEE49.2020806@landley.net>
In-Reply-To: <4FBBEE49.2020806@landley.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/23 09:18:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/23 09:18:15,
	Serialize complete at 2012/05/23 09:18:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 05/23/2012 03:51 AM, Rob Landley Wrote:
> On 05/22/2012 02:02 AM, Wen Congyang wrote:
>> If we only want to use node0, we can specify the max_addr. The boot
>> option "mem=" can do the same thing now. But the boot option "mem="
>> means the total memory used by the system. If we tell the user
>> that the boot option "mem=" can do this, it will confuse the user.
>> So we need an new boot option "max_addr" on x86 platform.
> 
> I didn't follow that reasoning at all.  Care to try again?
> 
> (mem= can do this, but telling users that would confuse them?  What?)

mem= means the total memory, but we implement it as max address.
I donot know why we implement it as max address. The users donot
know how we implement, and they only know that they can use
mem= to set the total memory. If you tell the users that mem=
can set max address, it will confuse them.

Thanks
Wen Congyang

> 
> Rob


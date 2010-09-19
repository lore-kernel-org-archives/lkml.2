Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab0ISJa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 05:30:29 -0400
Received: from freeflow.nu ([178.79.134.28]:50800 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab0ISJa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 05:30:27 -0400
Message-ID: <4C95D82F.2080001@kernel.org>
Date: Sun, 19 Sep 2010 12:30:23 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        mcgrof@gmail.com, Julia Lawall <julia@diku.dk>,
        Nicolas Palix <npalix@diku.dk>,
        Yoann Padioleau <yoann.padioleau@gmail.com>
Subject: Re: [PATCH v2] scripts: add typdef removal tool
References: <1250228384-19823-1-git-send-email-lrodriguez@atheros.com>	 <AANLkTi==_Tvt6hosvfKDdd9uivsa5SVPiqSHNg5Ob3-v@mail.gmail.com> <1284886192.1778.94.camel@Joe-Laptop>
In-Reply-To: <1284886192.1778.94.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 19.9.2010 11.49, Joe Perches wrote:
> On Sun, 2010-09-19 at 11:19 +0300, Pekka Enberg wrote:
>> On Fri, Aug 14, 2009 at 8:39 AM, Luis R. Rodriguez
>> <lrodriguez@atheros.com>  wrote:
>>> If you are porting drivers and need to remove tydpefs you can use
>>> this to help you port the driver faster. Until we don't have a fully
>>> correct and complete way to do this through Coccinelle spatch we
>>> might as well help developers porting drivers with something. spatch
>>> also has a learning curve, people working on staging may not end
>>> up using it for a while.
>> How come this script never made it to the kernel tree?
> General lack of interest?
>
> Probably the same reason that similar patches didn't.
> https://patchwork.kernel.org/patch/88026/
Scripts like these are sure handy when dealing with the crap in staging 
tree. Maybe we can convince Greg to take them in.

             Pekka

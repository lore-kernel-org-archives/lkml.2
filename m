Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0HXPwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:52:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:41782 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313Ab0HXPwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:52:45 -0400
Message-ID: <4C73E995.9030709@kernel.org>
Date: Tue, 24 Aug 2010 17:47:33 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: workqueue destruction BUG_ON
References: <1282640156.3695.5.camel@jlt3.sipsolutions.net>	 <4C739DC6.1040309@kernel.org>	 <1282646268.3695.9.camel@jlt3.sipsolutions.net>	 <4C73BC96.6000003@kernel.org>	 <1282655414.3695.25.camel@jlt3.sipsolutions.net>	 <4C73C425.20503@kernel.org>	 <1282655865.3695.27.camel@jlt3.sipsolutions.net>	 <4C73C5EE.2060501@kernel.org>	 <1282656218.3695.29.camel@jlt3.sipsolutions.net>	 <4C73DD81.2020300@kernel.org> <1282665139.3695.30.camel@jlt3.sipsolutions.net>
In-Reply-To: <1282665139.3695.30.camel@jlt3.sipsolutions.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 24 Aug 2010 15:52:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/24/2010 05:52 PM, Johannes Berg wrote:
> On Tue, 2010-08-24 at 16:56 +0200, Tejun Heo wrote:
>> On 08/24/2010 03:23 PM, Johannes Berg wrote:
>>>> I see, thanks for verifying.  I probably got confused about the line
>>>> number.  Hmm... weird.  I'll prep further debug patch but can you
>>>> please tell me what you did to trigger the bug?
>>>
>>> Not really sure. I think I need to trigger a firmware restart in iwlwifi
>>> and then try to unload the module.
>>
>> Does the following patch fix the problem?
> 
> Not sure. I can't seem to reproduce the exact conditions (firmware
> crash) right now... However I just ran into the WARN_ON_ONCE() your
> previous patch added as well, so that might explain the ath9k problem...

Can you please post the log of the WARN_ON_ONCE()?  That's something
which needs to be fixed from the caller.

Thanks.

-- 
tejun

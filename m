Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab1CQRE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:04:29 -0400
Received: from mail1.nippynetworks.com ([91.220.24.129]:59251 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab1CQRE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:04:27 -0400
Message-ID: <4D823F19.4070700@wildgooses.com>
Date: Thu, 17 Mar 2011 17:04:25 +0000
From: Ed W <lists@wildgooses.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: rpurdie@rpsys.net, linux-geode@lists.infradead.org, const@mimas.ru,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Feedback please: [PATCH] leds: New PCEngines Alix LED driver
 using gpio interface
References: <4D81D7FD.1040602@wildgooses.com> <20110317084328.41831b4c@debxo>
In-Reply-To: <20110317084328.41831b4c@debxo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres

Thanks for your feedback!

>> Additionally it relies on parts of the patch: 7f131cf3ed
>> by: Daniel Mack <daniel@caiaq.de> to perform detection of the Alix
>> board

..
>> - * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
> 
> This copyright line should not be removed, so long as parts of the
> original driver (such as alix_present) remain.

Thanks for guidance here.

Can I ask for further thought on this - there is very close to zero
original driver present, and although I had better do some more diffs to
be sure, I think you would see the only common code was the #includes, a
"force" param and a few other { }s?

I did deliberately reuse the "alix_present" function, but this appears
to be written by Daniel Mack and contributed in patch: 7f131cf3ed -
however, Daniel is not listed in the current copyright statement on the
module (I did copy him and Constantin in on this patch so that either
might object?).  Also I have tried to show this code attribution in the
commit statement?

I have also noted in the code that this is based on leds-net5501.c - is
this a sufficient and normal attribution?

Can someone offer a final "ruling" as to how I should state the
copyright line given that the code was written by taking the
leds-net5501.c skeleton and approximately applying the commit
7f131cf3ed, to give the current code?

Many thanks

Ed W

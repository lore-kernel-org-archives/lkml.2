Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab0ELOTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:19:20 -0400
Received: from server109c.appriver.com ([72.32.253.87]:2947 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752247Ab0ELOTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:19:18 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2010 10:19:18 EDT
X-Policy: GLOBAL - intcomgrp.com
X-Primary: jkosin@intcomgrp.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: JKosin@intcomgrp.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.54.13.100
X-Note-Reverse-DNS: mail.intcomgrp.com
X-Note-WHTLIST: JKosin@intcomgrp.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G193 G194 G195 G196 G200 G201 G212 G300 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
Message-ID: <4BEAB6FC.8090105@intcomgrp.com>
Date: Wed, 12 May 2010 10:11:08 -0400
From: James Kosin <jkosin@intcomgrp.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, dhaval.giani@gmail.com, peterz@infradead.org
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
References: <eJjRf-6YM-1@gated-at.bofh.it> <eJktY-7JG-7@gated-at.bofh.it> <eJktY-7JG-5@gated-at.bofh.it>
In-Reply-To: <eJktY-7JG-5@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2010 14:11:08.0836 (UTC) FILETIME=[F7F13640:01CAF1DC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/2010 9:50 AM, Dhaval Giani wrote:
> On Wed, May 12, 2010 at 3:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Wed, 2010-05-12 at 15:05 +0200, Dhaval Giani wrote:
>>> Where cpusets goes wrong is to have a *no* default values.
>>
>> It has a default, empty is still a valid value.
>>
> 
> Well, it is still not sane. And in the part you snipped, I did mention,
> 
>>> do we enforce a policy to have sane defaults
>>> for subsystems if they prevent attaching "regular" tasks by default.
> 
> And to add to it, a sane default can be defined as one, where a task
> can be attached to a cgroup on creation without changing any other
> parameter.
> 
> Dhaval

By keeping the insane policy, we force everyone to properly setup to
sane defaults.  By automatically inheriting the defaults, we would be
introducing the possibility of a lazy programmer forgetting to setup the
proper defaults for their application which may need different values
than the inherited settings.  This would lead to ensuing chaos eventually.

James

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab1CWSO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 14:14:59 -0400
Received: from mout1.freenet.de ([195.4.92.91]:39999 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab1CWSO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 14:14:58 -0400
Message-ID: <4D8A38DD.80207@dualc.maya.org>
Date: Wed, 23 Mar 2011 19:15:57 +0100
From: Andreas Hartmann <andihartmann@freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b13pre) Gecko/20110316 Firefox/4.0b13pre SeaMonkey/2.1b2pre
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: intel_ips produces constant load of 1
References: <im2ik4$3dd$1@ID-44327.news.uni-berlin.de> <20110321110404.6a71a404@jbarnes-desktop> <20110322132555.715dc096@jbarnes-desktop>
In-Reply-To: <20110322132555.715dc096@jbarnes-desktop>
X-Enigmail-Version: 1.2a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Mon, 21 Mar 2011 11:04:04 -0700
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
>>> ps aux | grep ips
>>> root       593  0.0  0.0      0     0 ?        S    17:20   0:00
>>> [ips-adjust]
>>> root       594  0.0  0.0      0     0 ?        D    17:20   0:00
>>> [ips-monitor]
>>>
>>> If the module isn't loaded, the load of the machine in idle mode is 0 as
>>> expected.  
>>
>> This is a reporting problem, and probably due to the schedule() call
>> and associated task state in the ips-monitor thread.  I thought setting
>> the task state to interruptible would prevent this, but it seems like
>> it's not enough for the deferrable on-stack timers?
>>
>> At any rate, it's not actually causing increased CPU usage, so you can
>> safely ignore it until we have a fix.
> 
> Oops, one task uses interruptible correctly, but the monitor thread
> doesn't.
> 
> Does this patch fix your load average?

Which patch? I can't see any patch :-).


Andreas

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab1H2Ndb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:33:31 -0400
Received: from mta11.charter.net ([216.33.127.80]:61773 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab1H2NdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:33:25 -0400
X-Authority-Analysis: v=1.1 cv=aYgz8SUnD4PtGxommIm5uNbVBOPq3891h1gxsHlFGpI=
 c=1 sm=1 a=B2KfuYyhElYA:10 a=gbogK0oHmqgA:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=SOGBUID8QfqVQLn9GRwA:9
 a=LXgThlvG-RunALsBaYEA:7 a=wPNLvfGTeEIA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4E5B9533.6000109@cuw.edu>
Date: Mon, 29 Aug 2011 08:33:39 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iwlegacy: change IWL_WARN to IWL_DEBUG_HT in iwl4965_tx_agg_start
References: <1314537977-20097-1-git-send-email-Gregory.Dietsche@cuw.edu> <20110829122013.GA3597@redhat.com>
In-Reply-To: <20110829122013.GA3597@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislaw,

On 08/29/2011 07:20 AM, Stanislaw Gruszka wrote:
> On Sun, Aug 28, 2011 at 08:26:16AM -0500, Greg Dietsche wrote:
>    
>> This message should be a debug message and not a warning. So
>> change it from IWL_WARN to IWL_DEBUG_HT.
>>      
> I'm currently doing massive iwlegacy driver cleanup. Would be easier
> for me to apply these patches on top of my changes instead of rebase
> my patches. I will queue these two patches and post them together with
> my pending patches.
>
>    
That sounds good to me. I have the 4065 card in my laptop and want to 
learn how it works. If you want someone to test your changes, I'm willing.

I have six other patches that are trivial in nature for the iwlegacy 
driver. One of those also applies to the iwlagn driver, so seven patches 
in total. They remove some null checks that aren't necessary and also 
cleanup a few unused variables. There are two patches in the set that 
I'm not 100% sure about. They remove null checks and I haven't been able 
to prove to myself that they are correct. However, if they aren't 
correct, then there are some null checks in other places that need to be 
added....

Anyway, I can hold off on these until you've done your cleanup and see 
what still applies, or if you have a tree someplace, I'd be happy to 
rebase them for you. I've been running them on my laptop for a few days 
now with no problems.

Thanks,
Greg

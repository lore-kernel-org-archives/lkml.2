Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab2ITNDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:03:50 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:3183 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab2ITNDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:03:48 -0400
Message-ID: <505B1419.2070706@atmel.com>
Date: Thu, 20 Sep 2012 15:03:21 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <havard@skinnemoen.net>,
        <bhutchings@solarflare.com>, <linux-arm-kernel@lists.infradead.org>,
        <plagnioj@jcrosoft.com>, <patrice.vilchez@atmel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/9] net/macb: driver enhancement concerning GEM support,
 ring logic and cleanup
References: <cover.1348055112.git.nicolas.ferre@atmel.com> <20120919.135006.394934820049386022.davem@davemloft.net>
In-Reply-To: <20120919.135006.394934820049386022.davem@davemloft.net>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 07:50 PM, David Miller :
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> Date: Wed, 19 Sep 2012 13:55:13 +0200
> 
>> This is an enhancement work that began several years ago. I try to catchup with
>> some performance improvement that has been implemented then by Havard.
>> The ring index logic and the TX error path modification are the biggest changes
>> but some cleanup/debugging have been added along the way.
>> The GEM revision will benefit from the Gigabit support.
>>
>> The series has been tested on several Atmel AT91 SoC with the two MACB/GEM
>> flavors.
>>
>> v2: - modify the tx error handling: now uses a workqueue
>>     - information provided by ethtool -i were not accurate: removed
> 
> Don't submit patches like this.
> 
> When you put an RFC right in the middle of the series, it screws everything
> up.
> 
> It means that I can't only apply the parts that are not RFC.

I will submit a v3 patch series when I am more confident about the patch
that I have tagged as RFC...

And as you noted last time that I have included a modified patch in a
series:
"Please, when you receive feedback on your patches, you need to
resubmit the whole patch series for review not just the patches where
changes were asked for."
==> I thought that it was a better idea to post the whole patch series
so that people could figure out the context. As the TX error path is
greatly modified, it could make senses.

Now, is it possible to review this series as it is or should I repost
patches? attached to the previous thread? RFC patch alone?

puzzled,
-- 
Nicolas Ferre

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab2I0WIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:08:47 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41755 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab2I0WIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:08:45 -0400
Message-ID: <5064CE6B.7020107@linaro.org>
Date: Thu, 27 Sep 2012 16:08:43 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 00/57] power: Upgrade to ux500 battery management driver
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org> <20120927033806.GA22791@lizard>
In-Reply-To: <20120927033806.GA22791@lizard>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-09-26 09:38 PM, Anton Vorontsov wrote:
> On Tue, Sep 25, 2012 at 10:11:57AM -0600, mathieu.poirier@linaro.org wrote:
>> From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>
>>
>> This patch set upgrades the current ux500 battery management driver
>> to the latest HW and functionality.
>>
>> Pull request for convenience:
>>
>> The following changes since commit 56d27adcb536b7430d5f8a6240df8ad261eb00bd:
>>
>>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2012-09-24 16:17:17 -0700)
>>
>> are available in the git repository at:
>>
>>   git://git.linaro.org/people/mpoirier/linux.git ux500-battery-management
> 
> I reviewed this series before, and all looked quite good overall. But I
> took another look, especially at the patches w/ empty commit messages, and
> there are some issues.
> 
> I tried to write some descriptions myself, but I failed: some changes are
> not obvious to me, so I couldn't write rationale for them. :-/
> 
> Thanks,
> Anton.
> 

Thank you very much for the review.

I am half way through your comments - some I can handle myself, for
others I needed to go back to the original author for clarification.
Another set will follow shortly.

Your time is much appreciated,
Mathieu.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab1LBCN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:13:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab1LBCN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:13:26 -0500
Message-ID: <4ED833A9.8040707@redhat.com>
Date: Fri, 02 Dec 2011 10:10:49 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, Alex Dubov <oakad@yahoo.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 20/62] mmc: remove the second argument of k[un]map_atomic()
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>	<1322371662-26166-21-git-send-email-amwang@redhat.com> <87vcq0jfin.fsf@laptop.org>
In-Reply-To: <87vcq0jfin.fsf@laptop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月02日 02:47, Chris Ball 写道:
> Hi,
>
> On Sun, Nov 27 2011, Cong Wang wrote:
>> Signed-off-by: Cong Wang<amwang@redhat.com>
>> ---
>>   drivers/mmc/host/at91_mci.c |    8 ++++----
>>   drivers/mmc/host/msm_sdcc.c |    6 +++---
>>   drivers/mmc/host/sdhci.c    |    4 ++--
>>   drivers/mmc/host/tifm_sd.c  |   16 ++++++++--------
>>   drivers/mmc/host/tmio_mmc.c |    1 -
>>   drivers/mmc/host/tmio_mmc.h |    4 ++--
>>   6 files changed, 19 insertions(+), 20 deletions(-)
>
> Looks good, thanks, pushed to mmc-next for 3.3.
>

Hello, Chris,

I am still not sure if Andrew wants to take all the patches together. :-/

But there should be no problem if you take this alone, after re-reading
the original code, it can still compile even without 01/62.

/*
  * Make both: kmap_atomic(page, idx) and kmap_atomic(page) work.
  */
#define kmap_atomic(page, args...) __kmap_atomic(page)

Regards.

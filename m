Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0G1V0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:26:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:3748 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530Ab0G1V0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:26:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,275,1278313200"; 
   d="scan'208";a="822655267"
Message-ID: <4C50A08A.6070108@linux.intel.com>
Date: Wed, 28 Jul 2010 14:26:34 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Patrick Pannuto <ppannuto@codeaurora.org>, linux-kernel@vger.kernel.org,
        apw@canonical.com, corbet@lwn.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/4] timer: Added usleep[_range] timer
References: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>	<1280345587-19725-2-git-send-email-ppannuto@codeaurora.org>	<20100728132314.29cd68c5.akpm@linux-foundation.org>	<4C509772.1070407@codeaurora.org>	<20100728135857.2a0ab8bd.akpm@linux-foundation.org>	<4C509BA3.7090403@codeaurora.org> <20100728142334.a0453c20.akpm@linux-foundation.org>
In-Reply-To: <20100728142334.a0453c20.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/2010 2:23 PM, Andrew Morton wrote

, it would never have happened.

>> In that case, it would pus
>> h me in the direction of only providing
>> usleep_range, and thus forcing people to think about it that way;
>> leave slack decisions to people who know what tolerances are acceptable.
>>      
> Well, I _think_ that would be a good approach.  I'm 45%/55% on that one
> and would be interested in other opinions ;)
>
>    

for new interfaces I'd really like a "range only" option... make people 
think.
And passing in a 0 is easy.


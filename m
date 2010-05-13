Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab0EMRhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:37:50 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:45690 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab0EMRht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:37:49 -0400
Message-ID: <4BEC38E8.7060707@linux.vnet.ibm.com>
Date: Thu, 13 May 2010 10:37:44 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@googlemail.com>
Subject: Re: [BUG] perf_event: when events are grouped, the time enabled /
 running values are incorrect
References: <4BE4C4BF.6020801@linux.vnet.ibm.com> <1273588935.1810.6.camel@laptop> <4BEAE476.1090100@linux.vnet.ibm.com> <20100513001036.GE11450@brick.ozlabs.ibm.com> <20100513101703.GA15387@brick.ozlabs.ibm.com>
In-Reply-To: <20100513101703.GA15387@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 03:17 AM, Paul Mackerras wrote:
> On Thu, May 13, 2010 at 10:10:36AM +1000, Paul Mackerras wrote:
>
>> Ugh.  I'll take a look today at that.
>
> Current tip/perf/core boots up just fine for me on a POWER5+ partition
> here.  If you're still seeing the problem, could you send me your
> config?
>
> Paul.

I'll pull and give it another go today and send you the .config if it fails.

- Corey


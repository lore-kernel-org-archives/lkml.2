Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935480Ab0KQVjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:39:25 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56452 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935390Ab0KQVjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:39:24 -0500
Message-ID: <4CE44B82.3010606@linux.vnet.ibm.com>
Date: Wed, 17 Nov 2010 13:39:14 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        "robert.richter" <robert.richter@amd.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH] perf: sysfs type id
References: <1289339119.2191.92.camel@laptop> <AANLkTi=ojOnLyRO4hTgYdCCXLsN0wUeTcme=5h8-mjdz@mail.gmail.com> <1289398207.2191.117.camel@laptop> <1289398763.2191.121.camel@laptop> <AANLkTimQ7w38wzrYT4MgjHFr6LCVj2M5fB11-n3XCD2w@mail.gmail.com> <1289421164.2084.56.camel@laptop> <AANLkTiku7UsVoYv_+6r79rvGPJU7OU=VGDiaYo0H=82y@mail.gmail.com> <1289423135.2084.63.camel@laptop>  <4CE33F86.7040403@linux.vnet.ibm.com> <1289993128.2109.714.camel@laptop>  <4CE43153.2070206@linux.vnet.ibm.com> <1290023834.2109.1240.camel@laptop> <1290024072.2109.1247.camel@laptop>
In-Reply-To: <1290024072.2109.1247.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 12:01 PM, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 20:57 +0100, Peter Zijlstra wrote:
>>> How about a compromise position: all of the arch-specific events are
>>> exposed to user space via sysfs iff some CONFIG_* variable to set to
>>> true.  Something like CONFIG_EXPOSE_ALL_HW_PERF_EVENTS_IN_SYSFS.
>>> This way you would only use all that memory when it's explicitly
>>> configured in.
>
> Another thing you could do is make all PMU drivers loadable modules
> (most of the infrastructure for that is present) and make the exhaustive
> list either a module parameter or another module extending the PMU
> driver.
>

That's an interesting approach.  Maybe there could be a perf command 
that would load the appropriate modules for all of the PMUs in the 
system - "perf load-event-modules".

- Corey


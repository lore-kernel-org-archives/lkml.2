Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1GZWYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 18:24:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41719 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab1GZWYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 18:24:08 -0400
Message-ID: <4E2F3D94.4000401@zytor.com>
Date: Tue, 26 Jul 2011 15:20:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        benh@kernel.crashing.org, tony.luck@intel.com, ralf@linux-mips.org,
        schwidefsky@de.ibm.com, liqin.chen@sunplusct.com, lethal@linux-sh.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCHSET tip:x86/memblock] memblock: Kill early_node_map[]
References: <1311694534-5161-1-git-send-email-tj@kernel.org> <CAE9FiQX0i2UwO9fSntwSEMUWiO6KdzbQth8Bf+_9OnKXntasKQ@mail.gmail.com> <CAOS58YPZLvXKHdy4nSeqNhk71o5hy-o6XQKbohvuUsGMMMirOA@mail.gmail.com>
In-Reply-To: <CAOS58YPZLvXKHdy4nSeqNhk71o5hy-o6XQKbohvuUsGMMMirOA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 02:49 PM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jul 26, 2011 at 11:14 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> it passes test with my x86 64bits setups.
> 
> Great, thanks for testing.
> 
>> looks like tip/master does not include tip/x86/memblock and tip/x86/mm yet.
>>
>> So tip/x86/memblock, tip/x86/mm will not get into 3.1?
> 
> Yeah, I think the whole thing including the last patchset was a bit
> too late for this merge window.  These are basically cleanups and
> could possibly cause weird boot regressions, so having enough time in
> -tip before going mainline seems like a good idea to me.
> 

It seems a bit scary, so holding this until 3.2 would definitely be my
preference.

	-hpa



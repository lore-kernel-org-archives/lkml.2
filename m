Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1AJO1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:27:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab1AJO13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:27:29 -0500
Date: Mon, 10 Jan 2011 15:19:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG stable, 2.6.32.27] sched: delayed cleanup of user_struct
Message-ID: <20110110141959.GA312@redhat.com>
References: <4D2AB8F7.7030506@profihost.ag> <20110110114913.GA22298@redhat.com> <20110110123630.GA27057@redhat.com> <4D2AFFB5.5000807@profihost.ag> <20110110133545.GA30163@redhat.com> <4D2B113A.2060303@profihost.ag> <20110110140817.GA31708@redhat.com> <4D2B1658.20201@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2B1658.20201@profihost.ag>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Stefan Priebe - Profihost AG wrote:
>
>>> You can find the logs here:
>>> http://pastebin.com/hNd15E8K
>>
>> Good. Sadly, I didn't see this trace before...
>>
>> 	kernel BUG at kernel/workqueue.c:287!
>>
>> this matches "INIT_DELAYED_WORK() can corrupt the pending work" I
>> mentioned.
> Sorry to ask this but this could also be "workarounded" by disabled
> GROUP_SCHED? Or is this another thing?

Yes, this looks like the same thing.

But let me repeat, today I looked at this code for the first time ;)

> Will wait if greg or anybody else can tell
> us something about it.

Indeed.

Oleg.


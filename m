Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab1HIHQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 03:16:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab1HIHQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 03:16:32 -0400
Message-ID: <4E40DEC4.5040401@redhat.com>
Date: Tue, 09 Aug 2011 15:16:20 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Paul Clements <Paul.Clements@steeleye.com>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] nbd: some trivial improvements
References: <1312794004-22047-1-git-send-email-amwang@redhat.com> <20110808172040.GA3191@suse.de>
In-Reply-To: <20110808172040.GA3191@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年08月09日 01:20, Greg KH 写道:
> On Mon, Aug 08, 2011 at 05:00:04PM +0800, Amerigo Wang wrote:
>> This patch 1) uses task_pid_nr(current) to get the pid of current process,
>>   2) replaces sysfs_create_file() with device_create_file(), 3) lower
>> the loglevel of an error message.
>
> As you are doing 3 different things, please make this 3 different
> patches (remember, one patch per logical thing being done.)

Since you insist, will do.

>
>>
>>   	if (max_part<  0) {
>> -		printk(KERN_CRIT "nbd: max_part must be>= 0\n");
>> +		printk(KERN_ERR "nbd: max_part must be>= 0\n");
>
> Again, dev_err() please.  That properly identifies exactly which device
> had problems.
>

Ok, thanks for pointing this out!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab0HJQKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 12:10:07 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49594 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab0HJQKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 12:10:03 -0400
Message-ID: <4C6179DD.7010000@kernel.dk>
Date: Tue, 10 Aug 2010 12:10:05 -0400
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: cfq: oops in __call_for_each_cic
References: <20100810064045.6996f3b7@tlielax.poochiereds.net>	<x49zkwu8s3y.fsf@segfault.boston.devel.redhat.com> <20100810102718.45bddc9d@tlielax.poochiereds.net>
In-Reply-To: <20100810102718.45bddc9d@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 10:27 AM, Jeff Layton wrote:
> On Tue, 10 Aug 2010 10:22:41 -0400
> Jeff Moyer <jmoyer@redhat.com> wrote:
> 
>> Jeff Layton <jlayton@redhat.com> writes:
>>
>>> Saw this oops on my test machine this morning. I rebooted the machine
>>> last night and hadn't done anything on it other than log in this
>>> morning. The kernel here is based on Steve French's git tree, which is
>>> based on Linus' as of Sunday Aug 8th. Last non-cifs commit is:
>>
>> This looks a lot like this bug:
>>   https://bugzilla.redhat.com/show_bug.cgi?id=577968
>>
>> See also:
>>   http://kerneloops.org/guilty.php?guilty=cfq_free_io_context&version=2.6.34-rc&start=2228224&end=2260991&class=oops
>>
>> It's been around since 2.6.30.8 according to kerneloops.org.  If you
>> find that you have a reliable way of reproducing the issue, that would
>> be great.
>>
> 
> Ok, thanks -- no clear reproducer so far. This morning was the
> first time I've seen it and it was on the console of my rawhide
> machine. The last thing I did with it was reboot it last night. I
> suspect that the gzip process came from a cron job or something.

What version did you hit it on?

-- 
Jens Axboe


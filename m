Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab0J0Mx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:53:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:60477 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab0J0MxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:53:24 -0400
Message-ID: <4CC820BA.3000203@windriver.com>
Date: Wed, 27 Oct 2010 07:53:14 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: kgdb-bugreport@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] input / sysrq fixes for use with kdb
References: <1286483748-1171-1-git-send-email-jason.wessel@windriver.com> <20101010211944.GB27553@core.coreip.homeip.net>
In-Reply-To: <20101010211944.GB27553@core.coreip.homeip.net>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 12:53:15.0775 (UTC) FILETIME=[EBFAB0F0:01CB75D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2010 04:19 PM, Dmitry Torokhov wrote:
> On Thu, Oct 07, 2010 at 03:35:45PM -0500, Jason Wessel wrote:
>   
>> The goal of this patch set is to help eliminate the problems of
>> resuming from the kernel debugger and having "stuck keys".
>>
>> I am completely open to moving the code chunks around if it makes more
>> sense to put the function in the input.c.
>>
>> I had posted the first patch in the series before and never received
>> an ack or acceptance into the linux-input merge queue.
>>
>>     
>
> Jason,
>
> I am aware of the problem however I am not quite happy with the proposed
> solution yet. Let me mull it over for a bit and I will get back to you.
>   
Ping :-)

The merge window for 2.6.37 is almost over, and I would really like to
fix this or make it better than it is today, given that remainder of the
atomic KMS API is now merged in 2.6.37.


Thanks,
Jason.

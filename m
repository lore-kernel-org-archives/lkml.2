Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab1JZRNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:13:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32835 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab1JZRNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:13:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=xlwAHVCNMwtWBjI2RyzaDgYNq0RD7JD5EwHCP27EblFvmXk33h+l0AigEq8DwpzQJ
	SCxEW/ZKAXhQLaEqgDgDg==
MIME-Version: 1.0
In-Reply-To: <CAGjg+kH577VE4cyq5zVNR962S6xbGCNnGS0w6N1DVuOppL3Khw@mail.gmail.com>
References: <1316804080-6396-1-git-send-email-venki@google.com>
	<CAGjg+kH577VE4cyq5zVNR962S6xbGCNnGS0w6N1DVuOppL3Khw@mail.gmail.com>
Date: Wed, 26 Oct 2011 10:13:27 -0700
Message-ID: <CABeCy1Y_OXPJkca6dRvK4-PCfKH8wD_2Aq-9r-JyBBSCetrsOw@mail.gmail.com>
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: Venki Pallipadi <venki@google.com>
To: alex shi <lkml.alex@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 5:46 PM, alex shi <lkml.alex@gmail.com> wrote:
>>
>> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
>> ---
>>  arch/x86/kernel/process_64.c |    2 +
>>  include/linux/hrtimer.h      |   14 ++++
>>  include/linux/sched.h        |    1 +
>>  include/linux/timerqueue.h   |   11 +++
>>  kernel/hrtimer.c             |  175 +++++++++++++++++++++++++++++++++++++-----
>>  kernel/sched.c               |    2 +
>>  kernel/sysctl.c              |    7 ++
>>  7 files changed, 191 insertions(+), 21 deletions(-)
>>
> Hi, venki, what version of thia patch against? I want to test the
> power consumption for your patch.

Hi Alex,

It should apply cleanly over 3.0. Thanks for testing the patch..

-Venki

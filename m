Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444Ab2DLNlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:41:04 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34112 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab2DLNlC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:41:02 -0400
MIME-Version: 1.0
In-Reply-To: <1334237738.23924.334.camel@gandalf.stny.rr.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	<1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
	<CAJd=RBBm8yDBrZFj48tP_5WsG=z0Rsv_=j=kArV1Mj6yJvQjVA@mail.gmail.com>
	<1334153450.23924.243.camel@gandalf.stny.rr.com>
	<CAJd=RBDqsr8aBNxokrb5Rc90RNu41ZRLEJJDdXibf238k2c6oQ@mail.gmail.com>
	<1334235109.23924.332.camel@gandalf.stny.rr.com>
	<CAJd=RBB1_USDhxgHojaQ27xVREz_jV8u-sCzwgmv8W-khtNZNQ@mail.gmail.com>
	<1334237738.23924.334.camel@gandalf.stny.rr.com>
Date: Thu, 12 Apr 2012 21:41:01 +0800
Message-ID: <CAJd=RBAYj1KJ=Nz-N0uMwk0Wy55GeJdEoisKnvbdiTCm46e9RQ@mail.gmail.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fcheccon@jasper.es
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 9:35 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2012-04-12 at 20:56 +0800, Hillf Danton wrote:
>
>> >>       if (2 == dl_nr_migratory + dl_nr_total)
>> >>               rq was not overloaded;
>> >>
>> >>       after enqueuing a deadline task that is not migratory,
>> >
>> > Now rq would be overloaded because:
>> >
>> >        dl_nr_migratory + dl_nr_total == 3
>> >
>>
>> Which is the current task, and where?
>
> More riddles?
>
As always:)

>
> The current task is the one executing on the CPU.
>
I will see rt tomorrow, and report if any new finding.

Best Regards
Hillf

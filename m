Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934361Ab0EZKxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:53:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60215 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab0EZKxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:53:32 -0400
MIME-Version: 1.0
In-Reply-To: <1274870970.5882.5311.camel@twins>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	 <1274863655.5882.4875.camel@twins>
	 <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	 <1274867106.5882.5090.camel@twins>
	 <AANLkTiksR3YozbBH0Iv5kNsQkEGKCH1APCvn_s6LkjV9@mail.gmail.com>
	 <1274868593.5882.5185.camel@twins>
	 <AANLkTinuxCbeBmxIR7b_1OtrqQYJCamiDZJbnNTih1Fb@mail.gmail.com>
	 <1274869966.5882.5262.camel@twins>
	 <AANLkTikRMBkoFxgaKsxMJ2lOMomTXpiHJDk3rVt0EtwM@mail.gmail.com>
	 <1274870970.5882.5311.camel@twins>
Date: Wed, 26 May 2010 03:53:31 -0700
Message-ID: <AANLkTinlxsokwralwRAL9_YRQ7-SZUSvrGHTlRISA9bC@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, felipe.balbi@nokia.com,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/26 Peter Zijlstra <peterz@infradead.org>:
> On Wed, 2010-05-26 at 03:40 -0700, Arve Hjønnevåg wrote:
>> 2010/5/26 Peter Zijlstra <peterz@infradead.org>:
>> > On Wed, 2010-05-26 at 03:25 -0700, Arve Hjønnevåg wrote:
>> >
>> >> and on systems where the
>> >> same power state can be used from idle and suspend, we use suspend so
>> >> we can stay in the low power state for minutes to hours instead of
>> >> milliseconds to seconds.
>> >
>> > So don't you think working on making it possible for systems to be idle
>> > _that_ long would improve things for everybody? as opposed to this
>> > auto-suspend which only improves matters for those that (can) use it?
>>
>> I'm not preventing anyone from working on improving this. Currently
>> both the kernel and our user-space code polls way too much. I don't
>> think it is reasonable to demand that no one should run any user-space
>> code with periodic timers when we have not even fixed the kernel to
>> not do this.
>
> All I'm saying is that merging a stop-gap measure will decrease the
> urgency and thus the time spend fixing the actual issues while adding
> the burden of maintaining this stop-gap measure.
>

Fixing the actually issue means fixing all user-space code, and
replacing most x86 hardware. I don't think keeping this feature out of
the kernel will significantly accelerate this.

-- 
Arve Hjønnevåg

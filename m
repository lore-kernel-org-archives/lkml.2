Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2CZXED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:04:03 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48109 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2CZXEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:04:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120228194508.624811514@linutronix.de>
References: <20120228194200.180923135@linutronix.de>
	<20120228194508.624811514@linutronix.de>
Date: Mon, 26 Mar 2012 16:04:00 -0700
X-Google-Sender-Auth: Eq6mX0D_-OFvwKVwFyCsfdIB494
Message-ID: <CA+8MBbK5J_1veoDwGNNZrmjJqAhxEQCC3JPSp36sMSRnr6y-4w@mail.gmail.com>
Subject: Re: [patch 4/4] ia64: vsyscall: Use seqcount instead of seqlock
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>        /* used by fsys_gettimeofday in arch/ia64/kernel/fsys.S */
> -       DEFINE(IA64_GTOD_LOCK_OFFSET,
> -               offsetof (struct fsyscall_gtod_data_t, lock));
> +       DEFINE(IA64_GTOD_SEQ_OFFSET,
> +               offsetof (struct fsyscall_gtod_data_t, seq);

Thomas,

Could you spare one more ")" here please? The compiler likes
it if they match :-)

Thanks

-Tony

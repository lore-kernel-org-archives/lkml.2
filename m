Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab1GLNJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 09:09:33 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59418 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab1GLNJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 09:09:32 -0400
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1310460101.18678.111.camel@twins>
References: <1310460101.18678.111.camel@twins>
Date: Tue, 12 Jul 2011 13:09:31 +0000
Message-ID: <CAMsRxfKPQ8gBp3TdDUS9MmB5KB1yhtJw5CqJw+coFRXGcwMDWQ@mail.gmail.com>
Subject: Re: perf error codes
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, paulus <paulus@samba.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 12, 2011 at 8:41 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Hi Stephane, Vince,
>
> Linus recently expressed dislike of our -ENOSPC usage for indicating the
> pmu is 'full'. Do either of your projects (libpfm, libpapi resp.) rely
> on this particular error code for this condition?
>
libpfm does not make perf syscalls. It would not be impacted
by a change in the error code.

I wonder what other meaningful code you might be able to use, though.

Thanks for asking.


>
>

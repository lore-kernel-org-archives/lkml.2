Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0JEVp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:45:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199Ab0JEVp4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:45:56 -0400
MIME-Version: 1.0
In-Reply-To: <20101005210904.GQ2369@linux.vnet.ibm.com>
References: <20101005191223.GA31795@elte.hu> <AANLkTik9E0dr=Qah0d_+9YaAsA7WfeawA1c4oDbiJK-j@mail.gmail.com>
 <20101005210904.GQ2369@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Oct 2010 14:45:07 -0700
Message-ID: <AANLkTi==ZE7+PTPdB1JjdSdqus0Ox+rjTAxMMMJk0fBi@mail.gmail.com>
Subject: Re: [GIT PULL] core kernel fixes
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 2:09 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Good point!!!  If the following diff looks good to you, I will get it
> tested and pushed.

Looks good. Except since I pulled the thing despite my complaint,
you'll also need to undo the extra irqs_disabled() test.

                Linus

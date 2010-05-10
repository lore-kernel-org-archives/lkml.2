Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab0EJPwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:52:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45125 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab0EJPwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:52:39 -0400
Subject: Re: [BUG] perf_event: crash in perf_output_begin
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       perfmon2-devel@lists.sf.net
In-Reply-To: <AANLkTilxN7Lq8yywpsz8voqYo0hqOX0DGcoqHmAdmFW_@mail.gmail.com>
References: <AANLkTilxN7Lq8yywpsz8voqYo0hqOX0DGcoqHmAdmFW_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 May 2010 17:52:19 +0200
Message-ID: <1273506739.5605.3407.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 17:33 +0200, Stephane Eranian wrote:
> Hi,
> 
> While testing 2.6.34-rc7 I ran into the following issue when
> using BTS sampling on Intel Core. It seems like something
> is not terminated properly. I am sampling BTS per-thread
> on a test program, then hit CTRL-C, one second later my
> machine crashes while running bash. Crash dump below:
> 
> [  750.249109] general protection fault: 0000 [#1] SMP
> [  750.249270] CPU 3
> [  750.249270] Pid: 6132, comm: bash Not tainted 2.6.34-rc7-tip+ #46

Can you try and reverting 4fd38e4595e2f6c9d27732c042a0e16b2753049c, I
spend most of the day chasing that, and I can't say I'm much wiser.



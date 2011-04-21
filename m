Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab1DUGZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 02:25:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54271 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab1DUGZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 02:25:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=foOOPIod1R8yIalfqO5fjCiGC+8wob7xo8EWCLVLTx37UPzP9tivenvhHYIGjQHgth
         gHbqrsbwMkrjTfvpr3LagfHrV7FVJ9K0aix3LokK0MJ63zxokZTiUJ4/9Lz3ojMIAiJM
         5pgy5GjHtazxXYJkS98yl5zApBVyUn4CDHR2U=
MIME-Version: 1.0
In-Reply-To: <20110421014153.126662477@goodmis.org>
References: <20110421014153.126662477@goodmis.org>
Date: Thu, 21 Apr 2011 14:25:36 +0800
Message-ID: <BANLkTik79LZTOrNMmokr6_OZgx+WinedcA@mail.gmail.com>
Subject: Re: [PATCH 0/7] [GIT PULL] lockdep: Show description of lockdep problems
From: Yong Zhang <yong.zhang0@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 9:41 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Steven Rostedt (7):
>      lockdep: Print a nice description of an irq locking issue
>      lockdep: Print a nice description of normal deadlocks
>      lockdep: Print a nice description of simple deadlock
>      lockdep: Printk nice description for irq inversion bug
>      lockdep: Replace bad path error message with something sane
>      lockdep: Print a nice description of simple irq inversion
>      lockdep: Remove cmpxchg to update nr_chain_hlocks
>
> ----
>  kernel/lockdep.c |  206 +++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 195 insertions(+), 11 deletions(-)

This looks very nice :)

Thanks,
Yong


-- 
Only stand for myself

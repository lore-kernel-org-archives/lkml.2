Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab1AOVvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 16:51:17 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43649 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab1AOVvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 16:51:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tm0KBYRxWfR0BVlLAAS+8+9+FUZUatkcAKVZq35TEkNZBmrxS8cwyBQW4aTvlcYnPa
         cAGQQ3T+YG6M8+Qg+O2a4AEbwm78Nvz88MmqZhneOYWwZM/6NL933+pzC8dHkvsF+kVc
         2KOhtEZzARH88uKZ6w7mtqTWEJnuSqcWoT5So=
MIME-Version: 1.0
In-Reply-To: <20110115015749.692623529@google.com>
References: <20110115015749.692623529@google.com>
Date: Sun, 16 Jan 2011 08:34:14 +1100
Message-ID: <AANLkTi=K8uo+wBQM3HzW6mc8-zeyEorUL=ZHo9HZzzWT@mail.gmail.com>
Subject: Re: [wake_afine fixes/improvements 0/3] Introduction
From: Nick Piggin <npiggin@gmail.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 12:57 PM, Paul Turner <pjt@google.com> wrote:
>
> I've been looking at the wake_affine path to improve the group scheduling case
> (wake affine performance for fair group sched has historically lagged) as well
> as tweaking performance in general.
>
> The current series of patches is attached, the first of which should probably be
> considered for 2.6.38 since it fixes a bug/regression in the case of waking up
> onto a previously (group) empty cpu.  While the others can be considered more
> forwards looking.
>
> I've been using an rpc ping-pong workload which is known be sensitive to poor affine
> decisions to benchmark these changes,

Not _necessarily_ the best thing to use :) As a sanity check maybe, but it would
be nice to have at least an improvement on one workload that somebody
actually uses (and then it's a matter of getting a lot more testing to
see it does
not cause regressions on others that people use).

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1HCOSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:18:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49367 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab1HCOS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:18:27 -0400
MIME-Version: 1.0
In-Reply-To: <1312317372.18583.101.camel@gandalf.stny.rr.com>
References: <1312317372.18583.101.camel@gandalf.stny.rr.com>
Date: Wed, 3 Aug 2011 22:18:25 +0800
Message-ID: <CAJd=RBDiU02XVwDeDwLZ-MNDq_Vn5ONYOFoQz1Fe4EAV9W=1fw@mail.gmail.com>
Subject: Re: [PATCH][GIT PULL] sched/cpupri: Remove the vec->lock
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <mgalbraith@suse.de>,
        "Luis Claudio R." <lgoncalv@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 3, 2011 at 4:36 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>    The migrate code does stress the RT tasks a bit. This shows that
>    the loop did increase a little after the patch, but not by much.
>    The vec code dropped dramatically. From 4.3us down to .42us.
>    That's a 10x improvement!
>
>    Tested-by: Mike Galbraith <mgalbraith@suse.de>
>    Tested-by: Luis Claudio R. Gonçalves <lgoncalv@redhat.com>
>    Tested-by: Matthew Hank Sabins<msabins@linux.vnet.ibm.com>
>    Reviewed-by: Gregory Haskins <gregory.haskins@gmail.com>
>    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
Acked-by: Hillf Danton <dhillf@gmail.com>

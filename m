Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1HVNXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:23:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51646 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab1HVNXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:23:17 -0400
MIME-Version: 1.0
In-Reply-To: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com>
References: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com>
Date: Mon, 22 Aug 2011 09:23:16 -0400
Message-ID: <CACV3sbL3j7qDPq=Dadnsw3HZCokF5V_tnGPhfocP-b1haQq_=g@mail.gmail.com>
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
From: Jovi Zhang <bookjovi@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Oleg Nesterov <oleg@redhat.com>, dhowells@redhat.com, roland@redhat.com,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I should dig the problem more deeply.
I will resend the patch for fix the comments. Thanks.

On Sun, Aug 21, 2011 at 6:36 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>
> Concur.  The comment should be changed
> Neil
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> >On 08/21, Oleg Nesterov wrote:
> >>
> >> On 08/21, bookjovi@gmail.com wrote:
> >> >
> >> > For non-pipe case, limit 0 also means drop the coredump, so just put
> >> > the zero limit check at do_coredump function begining.
> >>
> >> Neil, what do you think? Should we change the code or the comment?
> >
> >Personally I think we should fix the comment. I think RLIMIT_CORE
> >doesn't apply in this case, limit == 1 check is very special. And
> >this is what linux always did, except between 725eae32 and 898b374a.
> >
> >
> >Oleg.
> >
> >

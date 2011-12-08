Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab1LHSRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:17:40 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58562 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1LHSRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:17:38 -0500
MIME-Version: 1.0
In-Reply-To: <20111208154127.GB2499@redhat.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
 <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com> <1323198694-7186-22-git-send-email-jim.cromie@gmail.com>
 <87zkf5i3yv.fsf@rustcorp.com.au> <20111208154127.GB2499@redhat.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Thu, 8 Dec 2011 11:17:06 -0700
Message-ID: <CAJfuBxwv-dLAk-FQ9AQ7L7oEEYMo9iBURcPFRZ_UX2LQnV9tHg@mail.gmail.com>
Subject: Re: [PATCH 21/25] kernel/module: replace DEBUGP with pr_debug
To: Jason Baron <jbaron@redhat.com>
Cc: Rusty Russell <rusty@ozlabs.org>, greg@kroah.com, joe@perches.com,
        bart.vanassche@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 8, 2011 at 8:41 AM, Jason Baron <jbaron@redhat.com> wrote:
> On Wed, Dec 07, 2011 at 11:37:52AM +1030, Rusty Russell wrote:
>> On Tue,  6 Dec 2011 12:11:31 -0700, jim.cromie@gmail.com wrote:
>> > From: Jim Cromie <jim.cromie@gmail.com>
>> >
>> > Use more flexible pr_debug.  This allows:
>> >
>> >   echo "module module +p" > /dbg/dynamic_debug/control
>> >
>> > to turn on debug messages when needed.
>> >
>> > Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
>> > ---
>> >  kernel/module.c |   44 +++++++++++++++++++-------------------------
>> >  kernel/params.c |   14 ++++----------
>> >  2 files changed, 23 insertions(+), 35 deletions(-)
>>
>> Split into 2 and applied.  This is a win, independent of the rest.
>>
>
> Probably also want to pick up patch 1 in the series too, which actually allows
> this one to build ;)
>
> Thanks,
>
> -Jason

He did, in effect.

sorry for not ccing Rusty on 01/
I was thinking that it would go to trivial, and be done by then...

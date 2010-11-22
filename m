Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0KVBup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:50:45 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38289 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab0KVBuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:50:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=II0iVUIH89K+aPb1afc6fw6EVU/5gIhHRha9zeyjPyfbI6cobY8TOuHVhhh7K9+Nzp
         Dr570bROvXxggvfAvmIER1Gtt2xC2cqk+GcEI+n8+A1F6qxAm8WZMWtn0mNGT3yfkjq4
         MnnOzPQTnZzpFS85ArXDrO1dpi3n5z1+DdEqQ=
MIME-Version: 1.0
In-Reply-To: <20101122013655.GA10126@localhost>
References: <1290349496-13297-1-git-send-email-minchan.kim@gmail.com>
	<20101122013655.GA10126@localhost>
Date: Mon, 22 Nov 2010 10:50:44 +0900
Message-ID: <AANLkTimVvgKuND8tVyubkanEr5L4Vgy66jiOqxpF7ZQ_@mail.gmail.com>
Subject: Re: [PATCH] vmscan: Make move_active_pages_to_lru more generic
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wu,

On Mon, Nov 22, 2010 at 10:36 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Sun, Nov 21, 2010 at 10:24:56PM +0800, Minchan Kim wrote:
>> Now move_active_pages_to_lru can move pages into active or inactive.
>> if it moves the pages into inactive, it itself can clear PG_acive.
>> It makes the function more generic.
>
> Do you plan to use this "more generic" function? Because the patch in
> itself makes code slightly less efficient. It adds one "if" test, and
> moves one operation into the spin lock.

I tried to use it in my deactivate page series but couldn't use it due
some problem.
So I don't have a plan to use it. It's just my preference(and I hope
others think like me :) )

I hope function itself would be generic and clear because some people
in future might use it and reference it.
If my change makes big cost, I am not against you. otherwise, I hope
move_active_pages_to_lru become self-contained.

>
> Thanks,
> Fengguang
>



-- 
Kind regards,
Minchan Kim

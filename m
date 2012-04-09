Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab2DIUIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:08:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47532 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754810Ab2DIUIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:08:04 -0400
Message-ID: <1334002083.3228.15.camel@joe2Laptop>
Subject: Re: [00/02] add BUILD_BUG_DECL assertion (for 3.4??)
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 09 Apr 2012 13:08:03 -0700
In-Reply-To: <CAJfuBxxBY3Mq3EnuginFw_JkK3AE15V-u6C7uvi2L03tFfHOXQ@mail.gmail.com>
References: <1333924698-3894-1-git-send-email-jim.cromie@gmail.com>
	 <1333925535.2508.15.camel@joe2Laptop>
	 <CAJfuBxz2fD2KDxpg5gZfGW4bFvuviTG709Aev0=p-ojuzRNpCQ@mail.gmail.com>
	 <1333939078.2508.19.camel@joe2Laptop>
	 <CAJfuBxxBY3Mq3EnuginFw_JkK3AE15V-u6C7uvi2L03tFfHOXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-09 at 13:52 -0600, Jim Cromie wrote:
> On Sun, Apr 8, 2012 at 8:37 PM, Joe Perches <joe@perches.com> wrote:
> > Discontiguous array definitions must be ugly.
> Ugly ?
> too pejorative IMO

Ugly code is not a pejorative, it's more an
artifact of creation and always a beholder
issue.

> each array defn is a single statement.

I thought you meant the array entries not
the arrays themselves.

> there may be functions between the 2 defns being compared.
> 
> Maybe not ideal,
> 
> >
> >> Do you see advantages other than stylistic ones ?
> >
> > Not really.
> >
> > Contiguous declarations.
> > No need for other markings.
> >
> > Seems useful enough.
> >
> 
> OK.  Id expect your construct to be built upon mine,
> we'd still need to start with something.
> 
> Also, mine is usable for things yours isnt.
> I dont have a good example, but a simple/silly one is:
> 
> BUILD_BUG_DECL( wifi_channels_must_be_14,
>                   ARRAY_SIZE(channels_table) == 14 );

Do what you think best.

I think it's a solution for a relatively
minor problem.

The BUILD_BUG_DECL marking might be improved.
BUILD_BUG_DECL might be a bit short or not
descriptive enough.

Maybe BUILD_BUG_DIFF_SIZE or BUILD_BUG_SIZE_NE?



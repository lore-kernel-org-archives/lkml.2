Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab2HFVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:25:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54478 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab2HFVZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:25:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSV4_-53WEAP66bLqw=mFi8jQnQ8D6YRQY_wmK9+Rg_Og@mail.gmail.com>
References: <20120605051238.GA30614@redhat.com>
	<20120806164914.GA25940@redhat.com>
	<CAHC9VhSV4_-53WEAP66bLqw=mFi8jQnQ8D6YRQY_wmK9+Rg_Og@mail.gmail.com>
Date: Mon, 6 Aug 2012 17:25:56 -0400
Message-ID: <CACLa4ptkezizPCXmuwiTGHpHHfgbCOc0y-kELY_wkp5JChEuMQ@mail.gmail.com>
Subject: Re: Fix sel_netnode_insert suspicious rcu dereference.
From: Eric Paris <eparis@parisplace.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        eparis@redhat.com, paulmck@linux.vnet.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought I HAD committed it months ago!

Man I suck at this....

On Mon, Aug 6, 2012 at 3:10 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Mon, Aug 6, 2012 at 12:49 PM, Dave Jones <davej@redhat.com> wrote:
>> On Tue, Jun 05, 2012 at 01:12:39AM -0400, Dave Jones wrote:
>>  > I reported this a year ago (https://lkml.org/lkml/2011/4/20/308).
>>  > It's still a problem apparently ...
>>
>> And another two months pass in silence.
>>
>> This is happening to other people too.
>> https://bugzilla.redhat.com/show_bug.cgi?id=846037
>>
>> Can someone please apply this patch, or at least point out what's wrong with it ?
>
> I thought Eric had applied it a few months ago, but I just checked and
> I don't see it in Linus' tree for some reason?  I know multiple
> patches have been posted from different authors, all fixing the same
> thing ...
>
> Acked-by: Paul Moore <paul@paul-moore.com>
>
> --
> paul moore
> www.paul-moore.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

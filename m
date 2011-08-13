Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1HMBE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 21:04:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4933 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1HMBE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 21:04:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=o6XoQAPBdcxnbQwf/+bZbiZH8bINdFKp8ceMusg1edvHP/qA8Uo8VpE5ygVojSTag
	INHbiutk5slxC7OIYZAgA==
MIME-Version: 1.0
In-Reply-To: <20110809170118.880377f8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110722171540.74eb9aa7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110808124333.GA31739@redhat.com>
	<20110809083345.46cbc8de.kamezawa.hiroyu@jp.fujitsu.com>
	<20110809080159.GA32015@redhat.com>
	<20110809170118.880377f8.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 12 Aug 2011 18:04:52 -0700
Message-ID: <CALWz4iwm+q-LcMjfaCmjy1Z-4tmO6Cpx2nA4Ems_RKsyWQDq0w@mail.gmail.com>
Subject: Re: [PATCH v3] memcg: add memory.vmscan_stat
From: Ying Han <yinghan@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        abrestic@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 1:01 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> On Tue, 9 Aug 2011 10:01:59 +0200
> Johannes Weiner <jweiner@redhat.com> wrote:
>
> > On Tue, Aug 09, 2011 at 08:33:45AM +0900, KAMEZAWA Hiroyuki wrote:
> > > On Mon, 8 Aug 2011 14:43:33 +0200
> > > Johannes Weiner <jweiner@redhat.com> wrote:
> > > > On a non-technical note: as Ying Han and I were the other two people
> > > > working on reclaim and statistics, it really irks me that neither of
> > > > us were CCd on this.  Especially on such a controversial change.
> > >
> > > I always drop CC if no reply/review comes.
> >
> > There is always the possibility that a single mail in an otherwise
> > unrelated patch series is overlooked (especially while on vacation ;).
> > Getting CCd on revisions and -mm inclusion is a really nice reminder.
> >
> > Unless there is a really good reason not to (is there ever?), could
> > you please keep CCs?
> >
>
> Ok, if you want, I'll CC always.
> I myself just don't like to get 3 copies of mails when I don't have
> much interests ;)
>
> Thanks,
> -Kame

Hi Kame, Johannes,

Sorry for getting into this thread late and here are some comments:

There are few patches that we've been working on which could change
the memcg reclaim path quite bit. I wonder if they have chance to be
merged later, this patch might need to be adjusted accordingly as
well. If the ABI needs to be changed, that would be hard.

There is a patch Andrew (abrestic@) has been testing which adds the
same memory.vmscan_stat, but based on some page reclaim patches.
(Mainly the memcg-aware global reclaim from Johannes ). And it does
adjust to the hierarchical reclaim change as Johannes mentioned.

So, may I suggest us to hold on this patch for now? while the other
page reclaim changes being settled, we can then add it in.

Thanks

--Ying





>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

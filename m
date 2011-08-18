Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab1HRRxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:53:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27520 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab1HRRxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:53:08 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Dan Merillat <dan.merillat@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BTRFS Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: processes stuck in llseek
In-reply-to: <CAKcLGm8rY+3TYpe=ivmNrsZgUcBcgk3-6RRe81vGComN2bqgMw@mail.gmail.com>
References: <CAPL5yKdvMtCo8qqqJGM-FXk7CmhkY98QeDa8uH=ZDFLjus7Wng@mail.gmail.com> <1313499055-sup-2296@shiny> <CAPL5yKc7wztLatbk-4sVDnTLeiSeeXaXZd45r_rxDhdtR3mtPg@mail.gmail.com> <4E4B181E.8000508@cn.fujitsu.com> <CAKcLGm-c8zEi+=j2M_QjvS3GGJezvN_DTbUwb-tZtjPj9ZhNrQ@mail.gmail.com> <1313683211-sup-3134@shiny> <CAKcLGm8rY+3TYpe=ivmNrsZgUcBcgk3-6RRe81vGComN2bqgMw@mail.gmail.com>
Date: Thu, 18 Aug 2011 13:52:51 -0400
Message-Id: <1313689626-sup-7057@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4E4D517E.002B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Mitch Harder's message of 2011-08-18 12:53:33 -0400:
> On Thu, Aug 18, 2011 at 11:00 AM, Chris Mason <chris.mason@oracle.com> wrote:
> > Excerpts from Mitch Harder's message of 2011-08-18 11:40:17 -0400:
> >> On Tue, Aug 16, 2011 at 8:23 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> >> > Dan Merillat wrote:
> >> >> On Tue, Aug 16, 2011 at 8:51 AM, Chris Mason <chris.mason@oracle.com> wrote:
> >> >>> Excerpts from Dan Merillat's message of 2011-08-15 23:59:50 -0400:
> >> >>
> >> >>> Dan Carpenter sent a patch for this, I'll get it queued up for rc3.
> >> >>
> >> >> Can you send it?  I'd like to test it to see if it fixes my system.
> >> >
> >> > Here it is.
> >> >
> >> > http://marc.info/?l=linux-btrfs&m=131176036219732&w=2
> >> >
> >>
> >> Doesn't this patch rely on Josef's SEEK_HOLE/SEEK_DATA patch set which
> >> isn't in the kernel yet?
> >>
> >> http://marc.info/?l=linux-btrfs&m=130927580606177&w=2
> >
> > It does, but the hang was reported on 3.1-rc1, which does have Josef's
> > code.
> >
> 
> Thanks.
> 
> That gives me some insights regarding the differences between the
> 'for-linus' and the 'for-linus-merged' branches.

for-linus is usually what I send him to pull, and master is usually the
stable things against the last release (3.0 as of today).

for-linus-merged is used when there is a conflict between his current
tree and my for-linus branch.  Linus almost never uses this directly,
since he really likes to resolve conflicts himself.  This is mostly
because he wants to see what the conflicts are and make sure the
integration is done correctly.

But I still provide a for-linus-merged just so we can double check 
the results of the conflict resolution.

-chris

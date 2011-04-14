Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1DNEub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 00:50:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1DNEua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 00:50:30 -0400
Subject: Re: Unionmount status?
From: Ian Kent <ikent@redhat.com>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, miklos@szeredi.hu,
        Christoph Hellwig <hch@infradead.org>
In-Reply-To: <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	 <4DA4B6A8.7030804@gmail.com>
	 <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	 <4DA5DCB8.3040101@gmail.com>
	 <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>
	 <4DA5F569.9020309@gmail.com>
	 <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 12:50:08 +0800
Message-ID: <1302756608.2854.10.camel@perseus.themaw.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 21:47 +0200, Michal Suchanek wrote:
> On 13 April 2011 21:11, Ric Wheeler <ricwheeler@gmail.com> wrote:
> > On 04/13/2011 02:58 PM, Michal Suchanek wrote:
> >>
> >> On 13 April 2011 19:26, Ric Wheeler<ricwheeler@gmail.com>  wrote:
> >>>
> >>> On 04/12/2011 05:36 PM, Michal Suchanek wrote:
> >>>>
> >>>> On 12 April 2011 22:31, Ric Wheeler<ricwheeler@gmail.com>    wrote:
> >>>>>
> >>>>> On 04/12/2011 11:00 AM, Michal Suchanek wrote:
> >>>>>>
> >>>>>> Hello,
> >>>>>>
> >>>>>> as some already know the Unionmount VFS union which has been in
> >>>>>> development for some years now is the only True Union (TM) that can be
> >>>>>> accepted into the kernel mainline by the VFS maintainers (for reasons
> >>>>>> of their own which you can surely find if you search the web or ask
> >>>>>> them directly).
> >>>>>>
> >>>>>> The current UnionMount version that can be found here:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> http://git.kernel.org/?p=linux/kernel/git/val/linux-2.6.git;a=shortlog;h=refs/heads/ext2_works
> >>>>>>
> >>>>>> works for me as good as aufs does. That is I can build a live CD using
> >>>>>> this unioning solution and it boots and runs without any apparent
> >>>>>> issues.
> >>>>>>
> >>>>>> There are probably many possible uses of the union which I did not
> >>>>>> test nor did I test long term stability of using the unioned
> >>>>>> filesystem. As far as ephemeral live systems go it works fine for me,
> >>>>>> though.
> >>>>>>
> >>>>>> The issue is that while the code is (nearly) finished it is not yet
> >>>>>> merged into mainline and as I am not familiar with the details of
> >>>>>> ever-changing Linux VFS layer forward-porting this code to current
> >>>>>> kernels is somewhat challenging.
> >>>>>>
> >>>>>> What is the plan with unionmount now?
> >>>>>>
> >>>>>> What is required  for it to be merged into mainline?
> >>>>>>
> >>>>>> Thanks
> >>>>>>
> >>>>>> Michal
> >>>>>
> >>>>> Hi Michal,
> >>>>>
> >>>>> People are actively looking to see what union mount (or overlayfs)
> >>>>> solution
> >>>>> to pursue. Val has shifted her focus away from kernel hacking these
> >>>>> days,
> >>>>> but did refresh her patch set in the last month or so.
> >>>>
> >>>> I am not aware of such refreshed patch set, at least it is not
> >>>> published in her repo.
> >>>>
> >>> Val posted the refreshed patches with the title on March 22nd:
> >>>
> >>> http://lwn.net/Articles/435019/
> >>>
> >> That article references the same four months old repo which I
> >> mentioned at the start of the thread, only a slightly different
> >> branch.
> >>
> >> While it maybe useful for testing unionmount (which I already tried)
> >> it is not a patch against current kernel which could be used to build
> >> current live images.
> >>
> >> Thanks
> >>
> >> Michal
> >
> > She did post the patch series that same date in March - you can probably
> > grab the series from linux-fsdevel, look for this series:
> >
> > "[PATCH 00/74] Union mounts version something or other"
> >
> > Al Viro was planning on looking at her refreshed patches (he had reviewed
> > them with her in person), but that is not going to happen any time soon so
> > getting more eyes and testing would be great!
> >
> 
> Even gmame can't collect the patches back from the ML, I don't want to try.
> 
> However, the discussion suggests that these are exactly the 4 months
> old branch ending in a commit with the summary "Temporary commit"
> which did not inspire confidence in me so I used the previous (also 4
> moths old) branch.

Yes, that's the impression I have too.

I believe David was working to update the patches and his silence
indicates he is probably bogged down with other priority work. If that's
the case, and your still interested, I might be able to help updating
the series some time soon. I haven't reviewed any of Val's series posts
for a while now so I'd need to catch up with the current state of the
project first.

I guess the first thing is to find out if David has made any progress,
David?

As for the overlayfs from Miklos I haven't looked closely at it but
since Miklos hasn't replied so far I'm guessing there's still a way to
with that as well.

Ian



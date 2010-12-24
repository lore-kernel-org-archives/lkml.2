Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab0LXBcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 20:32:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:44173 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0LXBcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 20:32:41 -0500
Date: Fri, 24 Dec 2010 10:32:33 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: linux-next: manual merge of the sound tree with the s5p tree
In-reply-to: <s5h7hf0tvct.wl%tiwai@suse.de>
To: "'Takashi Iwai'" <tiwai@suse.de>,
        "'Russell King'" <rmk+kernel@arm.linux.org.uk>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Jassi Brar'" <jassi.brar@samsung.com>
Message-id: <008f01cba30a$72f5c160$58e14420$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=US-ASCII
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcuirfQvcOjcqakeR7GggfoJbWGviwAWoaYQ
References: <20101223115339.1ce18216.sfr@canb.auug.org.au>
 <003f01cba28c$872214f0$95663ed0$%kim@samsung.com>
 <s5hk4j0n43g.wl%tiwai@suse.de>
 <004001cba292$3827d2d0$a8777870$%kim@samsung.com>
 <s5hvd2ku49r.wl%tiwai@suse.de>
 <004101cba294$8639de30$92ad9a90$%kim@samsung.com>
 <s5h7hf0tvct.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> 
> At Thu, 23 Dec 2010 20:28:27 +0900,
> Kukjin Kim wrote:
> >
> > Takashi Iwai wrote:
> > >
> >
> > (snip)
> >
> > > > > > Anyway I need above commits from sound-2.6.git in my tree...
> > > > > > so how method is better to me instead of cherry-pick it?
> > > > >
> > > > > You can merge topic/asoc branch of sound git tree.
> > > > > This brach contains the all necessary commits for ASoC and is
almost
> > > > > never rebased.
> > > >
> > > > Hi,
> > > >
> > > > But I can't merge it because there is no 'topic/asoc' branch in
> > > > sound-2.6.git.
> > > >
(git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git)
> > > >
> > > > Is there another repository?
> > >
> > > OK, Mark's tree doesn't contain.  But you can merge for-2.6.38 tree
there.
> > >
> > > The main sound git tree is found in
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
> > >
> > Aha~ :-)
> >
> > > > And should I merge it in my tree even though don't need all of ASoC
> > commits
> > > > :-( ?
> > >
> > > In general yes because this is the tree to be merged to 2.6.38.
> > >
> > Yeah, I know it.
> >
> > > > I'm not sure how many commits are in there...
> > >
> > > You can keep two branches.  One contains only your fixes, and another
> > > is the merged branch from yours and from sound git tree.  Expose the
> > > latter merged tree for linux-next.
> > >
> > Yeah...however, firstly, my tree will be sent to rmk during 38 merge
window,
> > if I merge from sound git, for avoiding build error I should send all
> > including them not only my patches. I think there is no need to
rmk...hmm
> >
> > So I did 'cherry-pick' only needed 2 commits in my tree.
> 
> And that caused problems :)
> 
Yup...you're right. As I said, I couldn't suitable some branch for me.

> > > There are many other ways to manage such things, but the above has
> > > worked for me well, at least.
> >
> > Yeah I think so...but is there another better way in this case?
Hehehe...
> 
> Well, ideally, create a separate branch containing these cross-tree
> commits based on vanilla.  Then pull this branch to both arm (or your)
> and sound trees.  In that way, both trees share the same commits in
> the least amount.
> 
Yeah...

> I basically don't like to rebase and the commits have been already in
> sound tree, but if this is the only way and Russell prefers this, it
> can be a possible option.
> 
I agree with you...now, rebase stuff is unnecessary load to you.

Ok...firstly, need to ask to Russell.
(Added Russell in To)

Hi Russell,

Sorry for bothering...
If possible, please read this thread :-)

So...

May/Should I merge sound tree for avoiding build error and conflict between
each other for 37 merge window instead of cherry-pick?
Or sound maintainer should rebase his tree so that can make some branch
which can support to avoid build error for me?
...Or because Stephen already informed about that so you or Linus can care
just current tree during merge window?

Which one is better to us? Or another method? Please let me know.

Thanks and Merry Christmas everyone :-)

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


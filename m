Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab0LWL2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:28:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37699 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab0LWL2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:28:31 -0500
Date: Thu, 23 Dec 2010 20:28:27 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: linux-next: manual merge of the sound tree with the s5p tree
In-reply-to: <s5hvd2ku49r.wl%tiwai@suse.de>
To: "'Takashi Iwai'" <tiwai@suse.de>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Jassi Brar'" <jassi.brar@samsung.com>
Message-id: <004101cba294$8639de30$92ad9a90$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=US-ASCII
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acuikw13IiVQazPDSmqqEwGYfa84dwAADyAw
References: <20101223115339.1ce18216.sfr@canb.auug.org.au>
 <003f01cba28c$872214f0$95663ed0$%kim@samsung.com>
 <s5hk4j0n43g.wl%tiwai@suse.de>
 <004001cba292$3827d2d0$a8777870$%kim@samsung.com>
 <s5hvd2ku49r.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> 

(snip)

> > > > Anyway I need above commits from sound-2.6.git in my tree...
> > > > so how method is better to me instead of cherry-pick it?
> > >
> > > You can merge topic/asoc branch of sound git tree.
> > > This brach contains the all necessary commits for ASoC and is almost
> > > never rebased.
> >
> > Hi,
> >
> > But I can't merge it because there is no 'topic/asoc' branch in
> > sound-2.6.git.
> > (git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git)
> >
> > Is there another repository?
> 
> OK, Mark's tree doesn't contain.  But you can merge for-2.6.38 tree there.
> 
> The main sound git tree is found in
>     git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
> 
Aha~ :-)

> > And should I merge it in my tree even though don't need all of ASoC
commits
> > :-( ?
> 
> In general yes because this is the tree to be merged to 2.6.38.
> 
Yeah, I know it.

> > I'm not sure how many commits are in there...
> 
> You can keep two branches.  One contains only your fixes, and another
> is the merged branch from yours and from sound git tree.  Expose the
> latter merged tree for linux-next.
> 
Yeah...however, firstly, my tree will be sent to rmk during 38 merge window,
if I merge from sound git, for avoiding build error I should send all
including them not only my patches. I think there is no need to rmk...hmm

So I did 'cherry-pick' only needed 2 commits in my tree.

> There are many other ways to manage such things, but the above has
> worked for me well, at least.

Yeah I think so...but is there another better way in this case? Hehehe...

Anyway Merry Xmas ;-)
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


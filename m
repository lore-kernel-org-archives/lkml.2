Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab0IHW2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 18:28:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35179 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267Ab0IHW2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 18:28:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nico Schottelius <nico-nospam@schottelius.org>
Subject: Re: 2.6.36-rc3 suspend issue (was: 2.6.35-rc4 / X201 issues)
Date: Thu, 9 Sep 2010 00:27:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20100709170432.GA7691@schottelius.org> <201009080128.52849.rjw@sisk.pl> <20100908062141.GA2813@schottelius.org>
In-Reply-To: <20100908062141.GA2813@schottelius.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201009090027.38375.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 08, 2010, Nico Schottelius wrote:
> Rafael J. Wysocki [Wed, Sep 08, 2010 at 01:28:52AM +0200]:
> > On Wednesday, September 08, 2010, Nico Schottelius wrote:
> > > Rafael J. Wysocki [Tue, Sep 07, 2010 at 11:48:41PM +0200]:
> > > > On Tuesday, September 07, 2010, Jeff Chua wrote:
> > > > > 
> > > > > Cool. Thanks for the short-cut! At least now, I can resume, but got a
> > > > > lot of BUGS showing up upon resume after applying the patch.
> > > > 
> > > > This also was reported IIRC, but there's no resolution so far.  It's a
> > > > different issue.
> > > 
> > > Can somebody ping me, as soon as a git pull on linux-2.6
> > > should be as "stable" (or more stable) than 2.6.34?
> > 
> > No one can say when that happens for your machine.
> 
> True. I was more wondering, when the bisected issue will
> be fixed, as this may give my machine some more chances
> to work on Linux.
> 
> Btw, do you also recognize a different pattern on LKML?
> 
> In the past it was mostly "$device not support" && wait
> for third party patch to go into upstream, whereas today
> it "should be supported", but crashes/freezes sometimes.

Unfortunately, suspend to RAM is easy to break, so that happens in every merge
window and if nobody reports the problem timely, it just slips through.

Thanks,
Rafael

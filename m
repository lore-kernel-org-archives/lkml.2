Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab0IGXaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 19:30:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58999 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505Ab0IGXaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 19:30:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nico Schottelius <nico-linux-20100709@schottelius.org>
Subject: Re: 2.6.36-rc3 suspend issue (was: 2.6.35-rc4 / X201 issues)
Date: Wed, 8 Sep 2010 01:28:52 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20100709170432.GA7691@schottelius.org> <201009072348.41344.rjw@sisk.pl> <20100907225004.GA2805@schottelius.org>
In-Reply-To: <20100907225004.GA2805@schottelius.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201009080128.52849.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 08, 2010, Nico Schottelius wrote:
> Rafael J. Wysocki [Tue, Sep 07, 2010 at 11:48:41PM +0200]:
> > On Tuesday, September 07, 2010, Jeff Chua wrote:
> > > On Tue, Sep 7, 2010 at 2:37 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Monday, September 06, 2010, Jeff Chua wrote:
> > > >> On Mon, Sep 6, 2010 at 3:17 PM, Nico Schottelius
> > > >> <nico-linux-20100709@schottelius.org> wrote:
> > > >> Same problem here. X201s. Haven't had time to bisect.
> > > > Somebody has already done that:
> > > >
> > > > http://marc.info/?l=linux-kernel&m=128376394825563&w=4
> > > 
> > > Rafael,
> > > 
> > > Cool. Thanks for the short-cut! At least now, I can resume, but got a
> > > lot of BUGS showing up upon resume after applying the patch.
> > 
> > This also was reported IIRC, but there's no resolution so far.  It's a
> > different issue.
> 
> Can somebody ping me, as soon as a git pull on linux-2.6
> should be as "stable" (or more stable) than 2.6.34?

No one can say when that happens for your machine.

For me -rc3 is pretty much usable already.

Thanks,
Rafael

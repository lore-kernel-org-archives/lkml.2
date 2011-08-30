Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab1H3ROi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 13:14:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:59646 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753849Ab1H3ROd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 13:14:33 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX1/kiYIPTYXkWakRFNVtY/05TmfZv7a+S3DALlGNeV
	u3DNmsTOYZDJDz
Date: Tue, 30 Aug 2011 19:14:26 +0200
From: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Jiri Kosina <trivial@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] input: apanel: remove a redundant MODULE_ALIAS
Message-ID: <20110830171426.GA1732@debian.debian>
References: <1314653189-31020-1-git-send-email-j.neuschaefer@gmx.net>
 <201108291507.14497.dmitry.torokhov@gmail.com>
 <20110829161015.323c20a3@nehalam.ftrdhcpuser.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110829161015.323c20a3@nehalam.ftrdhcpuser.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 04:10:15PM -0700, Stephen Hemminger wrote:
> On Mon, 29 Aug 2011 15:07:14 -0700
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > On Monday, August 29, 2011 02:26:29 PM Jonathan Neuschäfer wrote:
> > > Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> > > ---
> > >  drivers/input/misc/apanel.c |    1 -
> > >  1 files changed, 0 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/input/misc/apanel.c b/drivers/input/misc/apanel.c
> > > index a8d2b8d..1dd1bd3 100644
> > > --- a/drivers/input/misc/apanel.c
> > > +++ b/drivers/input/misc/apanel.c
> > > @@ -346,5 +346,4 @@ MODULE_DESCRIPTION(APANEL_NAME " driver");
> > >  MODULE_LICENSE("GPL");
> > >  MODULE_VERSION(APANEL_VERSION);
> > > 
> > > -MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifeBook*:pvr*:rvnFUJITSU:*");
> > >  MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifebook*:pvr*:rvnFUJITSU:*");
> >                                         ^
> > 
> > Not necessarily redundant, if you notice the register is different.
> > 
> 
> At one point I found machines with both values, that is why there
> are two entries.

Okay, I didn't see the difference, sorry.

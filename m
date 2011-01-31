Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab1AaNnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:43:01 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56069 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab1AaNm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:42:59 -0500
Date: Mon, 31 Jan 2011 13:42:52 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: tapio.vihuri@nokia.com, ext Michal Marek <mmarek@suse.cz>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Checkpatch problem with Kconfig help symbol ?
Message-ID: <20110131134252.GD16804@shadowen.org>
References: <1295440968.2276.46.camel@dell>
 <ih8qf2$41t$3@dough.gmane.org>
 <4D380279.4070502@suse.cz>
 <1295594371.27658.3.camel@dell>
 <20110121101755.GP16804@shadowen.org>
 <1296461958.4168.5.camel@dell>
 <AANLkTi=0Gpvtvi8RyHbPAeh__YWLLPz+dE7iMdFbgGEW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=0Gpvtvi8RyHbPAeh__YWLLPz+dE7iMdFbgGEW@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 12:15:10PM +0200, Tomas Winkler wrote:
> On Mon, Jan 31, 2011 at 10:19 AM, Tapio Vihuri <tapio.vihuri@nokia.com> wrote:
> > On Fri, 2011-01-21 at 10:17 +0000, ext Andy Whitcroft wrote:
> >> On Fri, Jan 21, 2011 at 09:19:31AM +0200, Tapio Vihuri wrote:
> >> > On Thu, 2011-01-20 at 10:38 +0100, ext Michal Marek wrote:
> >> > > On 20.1.2011 09:06, WANG Cong wrote:
> >> > > > On Wed, 19 Jan 2011 14:42:48 +0200, Tapio Vihuri wrote:
> >> > > >
> >> > > >> Hi
> >> > > >>
> >> > > >> Is this false positive ?
> >> > > >>
> >> > > >> WARNING: please write a paragraph that describes the config symbol fully
> >> > > >> #60: FILE: drivers/input/misc/Kconfig:159: +       help
> >> > > >>
> >> > > >>
> >> > > >> Interesting enough, also:
> >> > > >>
> >> > > >> ./scripts/checkpatch.pl --file drivers/input/misc/Kconfig WARNING:
> >> > > >> please write a paragraph that describes the config symbol fully #430:
> >> > > >> FILE: input/misc/Kconfig:430:
> >> > > >> +       help
> >> > > >>
> >> > > >>
> >> > > >> But this is different line.
> >> > > >>
> >> > > >
> >> > > > Seems yes, the Kconfig part of your patch looks fine.
> >> > >
> >> > > The check is complaining that the help text is too short:
> >> > >
> >> > > +config ECI_CTRL_DEBUG
> >> > > + bool "ECI controller debug"
> >> > > + depends on INPUT_ECI_AT20
> >> > > + help
> >> > > +   Say Y here to enable debugging messages for ECI controller driver.
> >> > >
> >> > > Michal
> >> >
> >> > Hi.
> >> >
> >> > That I suspect, and I tried to add four lines more.
> >> > But it still complain the same.
> >>
> >> If you have a patch which has four or more lines and trips this message
> >> it is false yes.  Please do send me your example, as my current tests
> >> pass.
> >>
> >> -apw
> >
> > Hi.
> >
> > Sorry for the delay, I had made stupid email filter. Mea Culpa.
> >
> > It's working OK. If there is only three lines of help, checkpatch will
> > complain.
> > With four lines, it's not.
> >
> > I add more help in my case. It toggle driver debug on/off, so I try
> > harder to figure out how to say it with more words ;)
> >
> > BR,
> > Tapio
> >
> 
> I believe that the warning is not descriptive enough, I also had to
> look into the checkpatch script to
> figure out what is going on.
> What about adding little explanation like that:
> 
> WARNING: please write a paragraph that describes the config symbol
> fully (4 lines at least)

Yeah that is a little better.  I do remind you that if the description
is good enough shorter than 4 lines then you can ignore checkpatch.  It
is a style guide not a style enforcer.  You are allowed to ignore things
if you can justify it.

-apw

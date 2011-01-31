Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab1AaIT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 03:19:27 -0500
Received: from smtp.nokia.com ([147.243.128.24]:57132 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab1AaIT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 03:19:26 -0500
Subject: Re: Checkpatch problem with Kconfig help symbol ?
From: Tapio Vihuri <tapio.vihuri@nokia.com>
Reply-To: tapio.vihuri@nokia.com
To: ext Andy Whitcroft <apw@canonical.com>
Cc: ext Michal Marek <mmarek@suse.cz>, WANG Cong <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110121101755.GP16804@shadowen.org>
References: <1295440968.2276.46.camel@dell> <ih8qf2$41t$3@dough.gmane.org>
	 <4D380279.4070502@suse.cz> <1295594371.27658.3.camel@dell>
	 <20110121101755.GP16804@shadowen.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Mon, 31 Jan 2011 10:19:18 +0200
Message-ID: <1296461958.4168.5.camel@dell>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 10:17 +0000, ext Andy Whitcroft wrote:
> On Fri, Jan 21, 2011 at 09:19:31AM +0200, Tapio Vihuri wrote:
> > On Thu, 2011-01-20 at 10:38 +0100, ext Michal Marek wrote:
> > > On 20.1.2011 09:06, WANG Cong wrote:
> > > > On Wed, 19 Jan 2011 14:42:48 +0200, Tapio Vihuri wrote:
> > > > 
> > > >> Hi
> > > >>
> > > >> Is this false positive ?
> > > >>
> > > >> WARNING: please write a paragraph that describes the config symbol fully
> > > >> #60: FILE: drivers/input/misc/Kconfig:159: +       help
> > > >>
> > > >>
> > > >> Interesting enough, also:
> > > >>
> > > >> ./scripts/checkpatch.pl --file drivers/input/misc/Kconfig WARNING:
> > > >> please write a paragraph that describes the config symbol fully #430:
> > > >> FILE: input/misc/Kconfig:430:
> > > >> +       help
> > > >>
> > > >>
> > > >> But this is different line.
> > > >>
> > > > 
> > > > Seems yes, the Kconfig part of your patch looks fine.
> > > 
> > > The check is complaining that the help text is too short:
> > > 
> > > +config ECI_CTRL_DEBUG
> > > +	bool "ECI controller debug"
> > > +	depends on INPUT_ECI_AT20
> > > +	help
> > > +	  Say Y here to enable debugging messages for ECI controller driver.
> > > 
> > > Michal
> > 
> > Hi.
> > 
> > That I suspect, and I tried to add four lines more.
> > But it still complain the same.
> 
> If you have a patch which has four or more lines and trips this message
> it is false yes.  Please do send me your example, as my current tests
> pass.
> 
> -apw

Hi.

Sorry for the delay, I had made stupid email filter. Mea Culpa.

It's working OK. If there is only three lines of help, checkpatch will
complain.
With four lines, it's not.

I add more help in my case. It toggle driver debug on/off, so I try
harder to figure out how to say it with more words ;)

BR,
Tapio



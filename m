Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab1AUKSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 05:18:05 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59452 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1AUKSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 05:18:03 -0500
Date: Fri, 21 Jan 2011 10:17:55 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Tapio Vihuri <tapio.vihuri@nokia.com>
Cc: ext Michal Marek <mmarek@suse.cz>, WANG Cong <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Checkpatch problem with Kconfig help symbol ?
Message-ID: <20110121101755.GP16804@shadowen.org>
References: <1295440968.2276.46.camel@dell>
 <ih8qf2$41t$3@dough.gmane.org>
 <4D380279.4070502@suse.cz>
 <1295594371.27658.3.camel@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295594371.27658.3.camel@dell>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 09:19:31AM +0200, Tapio Vihuri wrote:
> On Thu, 2011-01-20 at 10:38 +0100, ext Michal Marek wrote:
> > On 20.1.2011 09:06, WANG Cong wrote:
> > > On Wed, 19 Jan 2011 14:42:48 +0200, Tapio Vihuri wrote:
> > > 
> > >> Hi
> > >>
> > >> Is this false positive ?
> > >>
> > >> WARNING: please write a paragraph that describes the config symbol fully
> > >> #60: FILE: drivers/input/misc/Kconfig:159: +       help
> > >>
> > >>
> > >> Interesting enough, also:
> > >>
> > >> ./scripts/checkpatch.pl --file drivers/input/misc/Kconfig WARNING:
> > >> please write a paragraph that describes the config symbol fully #430:
> > >> FILE: input/misc/Kconfig:430:
> > >> +       help
> > >>
> > >>
> > >> But this is different line.
> > >>
> > > 
> > > Seems yes, the Kconfig part of your patch looks fine.
> > 
> > The check is complaining that the help text is too short:
> > 
> > +config ECI_CTRL_DEBUG
> > +	bool "ECI controller debug"
> > +	depends on INPUT_ECI_AT20
> > +	help
> > +	  Say Y here to enable debugging messages for ECI controller driver.
> > 
> > Michal
> 
> Hi.
> 
> That I suspect, and I tried to add four lines more.
> But it still complain the same.

If you have a patch which has four or more lines and trips this message
it is false yes.  Please do send me your example, as my current tests
pass.

-apw

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1DALzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:55:24 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:57801 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082Ab1DALzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:55:23 -0400
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
In-Reply-To: <201104011322.44729.arnd@arndb.de>
References: <201103301906.42429.arnd@arndb.de>
	 <201103311723.02301.arnd@arndb.de> <1301643157.3393.17.camel@deskari>
	 <201104011322.44729.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 14:55:19 +0300
Message-ID: <1301658919.27593.72.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(dropping people from cc, as this is getting quite DSS spesific)

On Fri, 2011-04-01 at 13:22 +0200, Arnd Bergmann wrote:
> On Friday 01 April 2011, Tomi Valkeinen wrote:
> > On Thu, 2011-03-31 at 17:23 +0200, Arnd Bergmann wrote:
> > 
> > > * The DSS display drivers introduce new infrastructure include new bus
> > >   types that have the complexity to make them completely generic, but
> > >   in practice can only work on OMAP, and are clearly not written with
> > >   cross-vendor abstractions in mind.
> > 
> > If you mean the panel drivers, then I disagree. They are currently OMAP
> > specific, but they are designed so that making them generic shouldn't be
> > too difficult. It's been my aim for a long time already to make the
> > panel drivers generic, but I've never had time and it's never been quite
> > clear to me what would be the best way to do that.
> > 
> > The core DSS driver is OMAP specific, and while the DSS IP could in
> > theory be used in some other platform, that is not currently the case
> > and I wouldn't want to needlessly start abstracting things for just the
> > sake of abstracting.
> 
> Ok, fair enough. I haven't looked at the OMAP DSS code in detail, so
> I apologise if I did it injustice. What I did review is the ST Ericsson
> MCDE code which was written by taking the OMAP code as an example.
> 
> The symptom I'm describing is that infrastructure is getting added
> to platform specific code without making clear that it is mean to
> be generic. I.e. the code is hidded away in the drivers/video/omap
> directory, where other people would not go looking for it.
> 
> What I would have hoped you to do is to tell the ST Ericsson people
> when they posted their code that they should instead work with you
> to integrate the two implementations. As far as I remember (I may be
> wrong again), that did not happen.

I don't seem to remember seeing anything from ST Ericsson... While my
memory doesn't always serve me well, I would imagine I'd remember if I'd
seen code based on my code.

Ah, found them from fbdev mail archive. I was rather busy at that
period, I didn't really read the mailing lists.

I totally agree with you that we should have a common panel interface
layer. As I said, I've had it as a target for a long time. And hopefully
now that I moved from Nokia to TI I'll finally have time to work on it
also.

Thanks for pointing me to the MCDE stuff. I doesn't seem to be merged,
though. I need to contact them and see if they're still interested in
working on the common interface.

 Tomi



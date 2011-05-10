Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab1EJSnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:43:12 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60318 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750860Ab1EJSnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:43:10 -0400
Date: Tue, 10 May 2011 18:43:02 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andrew Lutomirski <luto@mit.edu>, ibm-acpi-devel@lists.sourceforge.net,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [ibm-acpi-devel] [RFC] Controlling the ThinkPad battery charger
Message-ID: <20110510184302.GA15631@localhost.ucw.cz>
References: <BANLkTinWna2sDDjbNC5xyGX3ELROs=Wd0w@mail.gmail.com> <20110509144546.GB13275@khazad-dum.debian.net> <BANLkTikB2TFF12vdwLqV9NRw4meEyDjvdA@mail.gmail.com> <20110509152941.GD13275@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509152941.GD13275@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-05-09 12:29:41, Henrique de Moraes Holschuh wrote:
> On Mon, 09 May 2011, Andrew Lutomirski wrote:
> > > The SBS interface exposes more data about the battery, including
> > > per-cell-group voltage and pack microcontroller aging counters, alarms, and
> > > the "needs to get through the fuel-gaugue reset procedure" semasphore.
> > 
> > If I'm feeling really motivated, I'll look at that.  I'm currently
> > more interested in the charging thresholds, though, which I think is
> > independent of the choice of SBS vs ACPI to access the battery state.
> > (From a quick glance at the SBS spec, you can inhibit charging
> > entirely but you can't ask for thresholds.  I assume that the EC takes
> > care of that.  If I'm wrong, please tell me, but SMAPI seems like a
> > fine way to access the thresholds.)
> 
> Yeah, SMAPI is the safest way to deal with all this.  It is an interface
> layer that Lenovo is not fond of breaking (or touches very rarely.  Amounts
> to the same in the end).
> 
> SBS does not take care of thresholds, indeed.  The EC does (and I know how
> to program the threshold in a few models, if you do want to test it in your
> X220, I can send you the information.  It is safe to test if you use it
> together with SMAPI to cross-check).

Hmm, I jave a battery pack with reasonably good cells, but firmware killed it. IOW available for testing.

(And who know, perhaps recalibrate command would bring it back to life?)
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

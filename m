Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1DDQpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:45:41 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:42990 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754696Ab1DDQpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:45:39 -0400
Date: Mon, 4 Apr 2011 18:44:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] APM: delete APM in Linux-2.6.40
Message-ID: <20110404164456.GA13215@elf.ucw.cz>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1103240336590.4529@x980>
 <20110324102116.GA17446@khazad-dum.debian.net>
 <alpine.LFD.2.02.1103241903030.16085@x980>
 <20110325010705.GB4535@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325010705.GB4535@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > People with a ThinkPad T23, T30 will really not appreciate this, and it
> > > should not be too difficult to recruit some as testers.
> > 
> > I have both, and they both support ACPI.
> 
> I wonder why I had some users of those two boxes advocating APM, maybe
> it used to work better or something.  Or I got the T21 and A30 confused
> with the T23.
> 
> Well, I don't think we need to support the thre-digit series ThinkPads,
> the number of those still working is probably on the four digits
> world-wide.  And I haven't heard from anyone with a T21 or A31 in a
> while, so they might be down to five digits already.

I still have working thinkpad 560X, my brother occassionaly uses it...

I do not think we should remove APM support like this. It does not
seem to be huge maintainance burden...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

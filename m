Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab2BIWaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:30:46 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46307 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab2BIWao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:30:44 -0500
Date: Thu, 9 Feb 2012 22:30:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] SubmittingPatches: Increase the line length limit from
 80 to 100 colums
Message-ID: <20120209223033.GA20746@sirena.org.uk>
Mail-Followup-To: Jan Engelhardt <jengelh@medozas.de>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Cyrill Gorcunov <gorcunov@openvz.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Pavel Emelyanov <xemul@parallels.com>,
	Serge Hallyn <serge.hallyn@canonical.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu>
 <20120203083530.GD1968@moon>
 <20120203090929.GA23996@elte.hu>
 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
 <20120203100743.GA3334@elte.hu>
 <alpine.LNX.2.01.1202092206040.11004@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1202092206040.11004@frira.zrqbmnf.qr>
X-Cookie: Measure twice, cut once.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 10:55:45PM +0100, Jan Engelhardt wrote:
> On Friday 2012-02-03 11:07, Ingo Molnar wrote:
> >[PATCH] SubmittingPatches: Increase the line length limit from 80 to 100 colums

> >As far as I'm aware I was the last regular kernel contributor who
> >still used a standard VGA text console, but both text (100 cols is
> >also arguably closer to various brain limits such as vision of field
> >and resolution restrictions

> Please, no.

> (Corollary 1) The older you get, the larger you like your glyphs to
> be (...and the FOV is likely to lower as well).

> 14pt and up usually. And there is not a whole lot that fit on
> 10.1-inch netbook screens that way.

> (Corollary 2) Travelers desire minimizing size and weight.

Or your vision is a bit better but you like multiple things over the
screen width...

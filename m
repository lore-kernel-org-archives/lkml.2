Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2HEJVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 05:21:23 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52007 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab2HEJVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 05:21:21 -0400
Date: Sun, 5 Aug 2012 11:21:18 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Sven Joachim <svenjoac@gmx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kevin Winchester <kjwinchester@gmail.com>
Subject: Re: [ 33/73] x86, microcode: Sanitize per-cpu microcode reloading
 interface
Message-ID: <20120805092118.GA16462@aftab.osrc.amd.com>
References: <20120731044310.013763753@decadent.org.uk>
 <20120731044316.585695559@decadent.org.uk>
 <87y5lw73eh.fsf@turtle.gmx.de>
 <20120803094314.GB31792@aftab.osrc.amd.com>
 <20120803122727.GA32299@aftab.osrc.amd.com>
 <1344094877.4642.183.camel@deadeye.wl.decadent.org.uk>
 <20120804160745.GA17188@khazad-dum.debian.net>
 <1344101021.4642.187.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1344101021.4642.187.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 06:23:41PM +0100, Ben Hutchings wrote:

[ … ]

> > > Thanks everyone for working this out.
> > >
> > > If you combine multiple mainline commits like this, the new commit
> > > message should refer to all of them. I've fixed that up this time.

Thanks.

> > Ben, the backport is also needed on 3.0 and 3.4, do you have your patch
> > queue available for download/pull somewhere?
> 
> This is in v3.2.26, tagged in git
> <git://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-3.2.y.git>.
> I'll wait for Greg to generate tarballs etc. before sending the
> announcement.

Ok, guys.

Pls let me know if I should send the backported patch for 3.0 and 3.4 to
Greg or you are doing this.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

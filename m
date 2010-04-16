Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0DPFdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 01:33:14 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:47906 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab0DPFdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 01:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wq+IrFlOw3Ld1QhVjLqTgl9NFz2aI2wr2XpvsWG3ff0bUoeRuzirqLr+rBa/OD+6zn
         d1WvcJeGpP8TX2E31D/ahaT6G0A/85XQJnEaBBGBfftwC4iNEIExP9rtgTugSiXrQEDR
         ekDfFRsfKjKMwMGok8WnuEhIqNONv/5Ed0qkM=
Date: Thu, 15 Apr 2010 22:33:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Linux Input <linux-input@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC] Input: implement sysrq as an input handler
Message-ID: <20100416053305.GC1078@core.coreip.homeip.net>
References: <20100317061952.GA19789@core.coreip.homeip.net>
 <20100319000043.GC12017@khazad-dum.debian.net>
 <20100319000931.GA5671@core.coreip.homeip.net>
 <20100319160641.GC16743@khazad-dum.debian.net>
 <20100319180314.GB12143@core.coreip.homeip.net>
 <20100320025329.GA2468@khazad-dum.debian.net>
 <20100322045910.GE31621@core.coreip.homeip.net>
 <20100401133454.GA1291@ucw.cz>
 <20100401154212.GA7900@core.coreip.homeip.net>
 <20100404132734.GB1346@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404132734.GB1346@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 03:27:34PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > If userspace disables sysrq during normal operation, that makes it
> > > useless.
> > > 
> > > If normal user could do that, that's a security problem.
> > > 
> > 
> > Yes, and...? This patch does not change the way one enables, disables,
> > intercepts, etc. SysRq and SAK compared to how it was handled when SysRq
> > was part of keyboard _input handler_. The only thisng this patch does is
> > moving the code into a _separate_ input handler.
> 
> Yep, that was just a note.
> 
> > > > The problem is that device does not know what SysRq and especially SAK are.
> > > > User can reassign key codes and key symbols easily.
> > > 
> > > That was not case in original implementation; it had hardcoded keymap.
> > 
> > The earth was also flat back then and the only keyboard was AT one. SAK
> > was always part of keymap so could be reassinged at any time.
> 
> Well, there are two SAKs.
> 
> One SAK -- in keymap, is remappable and always was.
> 
> Second, sysrq-saK -- is (was?) hardcoded and not affected by
> keymap. Please don't change that.

Can I change Alt? Just saying... ;)

Anyway, yes, it was hardcodced in 2.4. It also was only working on AT
keyboards, and now we support much wider range.

-- 
Dmitry

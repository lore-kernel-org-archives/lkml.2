Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2H3W02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 18:26:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57923 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2H3W0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 18:26:25 -0400
Date: Thu, 30 Aug 2012 15:26:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Guenter Roeck <linux@roeck-us.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Simon Budig <simon.budig@kernelconcepts.de>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: Let the FT5x06 driver build without debugfs
In-Reply-To: <20120822054919.GB20624@core.coreip.homeip.net>
Message-ID: <alpine.DEB.2.00.1208301524560.14189@chino.kir.corp.google.com>
References: <87k3wy1ii3.fsf@xmission.com> <502DFC1D.20903@kernelconcepts.de> <87boi91g01.fsf@xmission.com> <20120820135303.GA9278@roeck-us.net> <20120822054919.GB20624@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Dmitry Torokhov wrote:

> > > > On 08/17/2012 02:15 AM, Eric W. Biederman wrote:
> > > >> When testing to make certain my user namespace code works in
> > > >> various configurations I tripped over the tf5x06.c not building
> > > >> with debugfs disabled.
> > > >
> > > > Sorry for that.
> > > >
> > > > There already is a patch for this issue which I slightly prefer. You
> > > > can find it in the mail from Guenther Roeck:
> > > >    http://www.mail-archive.com/linux-input@vger.kernel.org/msg00646.html
> > > 
> > > If you guys could get that merged into 3.6 I would appreciate it.
> > > 
> > Yes, that would be great. I don't recall seeing an e-mail from Dmitry accepting
> > it, though.
> 
> Applied, sorry for the delay.
> 

This still affects Linus' tree and causes a build breakage without debugfs 
configured.  Considering the driver went into 3.5-rc5, could you please 
push this fix for 3.6 (and mark it for stable backport)?

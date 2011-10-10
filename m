Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1JJJoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 05:44:13 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44129 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753097Ab1JJJoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 05:44:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/eJVQLHOTecap/5dEfVa7EZAkLSPQInjtsv8y+DN
	twW0XAvo0H/Crw
Subject: Re: Please revert "debug: Make CONFIG_EXPERT select
 CONFIG_DEBUG_KERNEL to unhide debug options"
From: Mike Galbraith <efault@gmx.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Ingo Molnar <mingo@elte.hu>, Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20111010084811.GG4586@localhost.pp.htv.fi>
References: <20110930134245.GB21474@localhost.pp.htv.fi>
	 <20110930150519.GA7980@leaf> <20110930155012.GC9049@localhost.pp.htv.fi>
	 <20111010072946.GA29035@elte.hu>
	 <20111010084811.GG4586@localhost.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 11:44:06 +0200
Message-ID: <1318239846.6527.28.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 11:48 +0300, Adrian Bunk wrote:

> DEBUG_BUGVERBOSE does not depend on EXPERT.
> 
> But EXPERT is currently required for disabling it.

Why would anyone other than poor embedded sods turn that off?

	-Mike


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab1HAInH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 04:43:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:34753 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab1HAImn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 04:42:43 -0400
Subject: Re: [PATCH] kbuild: honor the ARCH setting of the existing
 configuration
From: David Woodhouse <dwmw2@infradead.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Mon, 01 Aug 2011 09:42:17 +0100
In-Reply-To: <317e3210947c039a33b970300e62d53d.squirrel@xenotime.net>
References: <1312141497-13854-1-git-send-email-lacombar@gmail.com>
	 <1312143643.12369.32.camel@i7.infradead.org>
	 <CACqU3MXak0Yo+VDQNEqT9rTJ5CjdU6jJ-C1Km7GauMQ+qGW+vg@mail.gmail.com>
	 <1312151687.18010.31.camel@i7.infradead.org>
	 <317e3210947c039a33b970300e62d53d.squirrel@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312188139.18010.104.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 19:05 -0700, Randy Dunlap wrote:
> 
> > I would love to see $ARCH turned into a proper configuration option.
> 
> I don't object in principle, but I'm expecting to have to modify/update
> multiple *working* scripts as a result.  But of course this won't be
> the first time and I don't expect it to be the last time either.
> [signed:  eeyore] 

:)

Yeah, that's why I'd kind of like to see it done *once*, *properly*.

Arnaud's hack to read it from .config is cute, but might give behaviour
that people will come to depend on in their scripts and then we take it
away again.

-- 
dwmw2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab0I3UCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:02:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756126Ab0I3UCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:02:53 -0400
Date: Thu, 30 Sep 2010 22:02:46 +0200
From: Michal Marek <mmarek@suse.cz>
To: Naohiro Aota <naota@elisp.net>
Cc: Roman Zippel <zippel@linux-m68k.org>, Arnaud Lacombe <lacombar@gmail.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Ulf Magnusson <ulfalizer.lkml@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH -next] kconfig: Don't go out from read config loop when
 you read new symbol
Message-ID: <20100930200246.GA25629@sepie.suse.cz>
References: <87sk0rghne.fsf@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sk0rghne.fsf@elisp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 04:23:17AM +0900, Naohiro Aota wrote:
> commit 8baefd30b5b0101aa07aa75da44a9eee881eed28 of linux-next replaced
> a `switch()' statement with some `if()' statements, but left `break's
> in the `switch()' statement untouched. This cause read config loop to
> exit and so "make oldconfig" is not much usable (see below).

Good catch, applied.

Michal

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab0FQHAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 03:00:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab0FQHAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 03:00:42 -0400
Subject: Re: Slow pty's (was Re: libdivecomputer interfaces?)
From: Mike Galbraith <mgalbraith@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Brian Bloniarz <bmb@athenacr.com>, Chris Wedgwood <cw@f00f.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jef Driesen <jefdriesen@telenet.be>, linux-kernel@vger.kernel.org
In-Reply-To: <1276756770.8248.20.camel@marge.simson.net>
References: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>
	 <20100610181042.GA19210@puku.stupidest.org> <4C116652.8010408@athenacr.com>
	 <alpine.LRH.2.00.1006161702470.2497@twin.jikos.cz>
	 <1276701411.30669.6.camel@marge.simson.net>
	 <1276756770.8248.20.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 17 Jun 2010 09:00:38 +0200
Message-Id: <1276758038.9628.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-17 at 08:39 +0200, Mike Galbraith wrote:

> I'm not seeing any problem with serial console here, seems to work just
> fine P4->Q6600, both running NOHZ kernels with nohz_ratelimit(), 33.5 on
> the P4, and tip.today on the Q6600.

Of course, as soon as I say that, the problem appeared.  Hopefully,
It'll stick around a while.

	-Mike


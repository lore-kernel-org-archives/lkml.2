Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1GNJho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 05:37:44 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:41105 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1GNJhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 05:37:39 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Cc: julia@diku.dk, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk
In-Reply-To: <1310520405-1558-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1310520405-1558-1-git-send-email-Gregory.Dietsche@cuw.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 10:37:19 +0100
Message-ID: <1310636239.634.493.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 0/3] coccinelle: add parallel execution
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 20:26 -0500, Greg Dietsche wrote:
> This patch series adds a new flag PARALLEL= to the coccicheck build target and documents the new feature.
> It works a lot like make's -j flag. I looked for a way to have make pass on the value of -j, but
> didn't find one - if anyone knows how to do that, I'd love to hear about it! 

I suppose in principal you could parse $MAKEFLAGS (or $MFLAGS) for
--jobserver-fds and implement compatibility with make's jobserver
protocol ( http://mad-scientist.net/make/jobserver.html ). I don't know
stable or outward facing the make guys consider that interface, plus it
all sounds a bit fiddly to me...

Ian.

-- 
Ian Campbell

QOTD:
	"I thought I saw a unicorn on the way over, but it was just a
	horse with one of the horns broken off."


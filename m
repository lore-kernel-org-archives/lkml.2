Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1FXVVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 17:21:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38622 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1FXVVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:21:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 24 Jun 2011 23:20:48 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jesper Juhl <jj@chaosbits.net>,
        LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
        Sage Weil <sage@newdream.net>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a
 per-driver version - Was: Re: [PATCH 03/37] Remove unneeded version.h
 includes from include/
Message-ID: <20110624232048.66f1f98c@stein>
In-Reply-To: <1308949448.2093.20.camel@morgan.silverblock.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
	<4E04912A.4090305@infradead.org>
	<BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>
	<201106241554.10751.hverkuil@xs4all.nl>
	<4E04A122.2080002@infradead.org>
	<20110624203404.7a3f6f6a@stein>
	<BANLkTimj-oEDvWxMao6zJ_sudUntEVjO1w@mail.gmail.com>
	<1308949448.2093.20.camel@morgan.silverblock.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 24 Andy Walls wrote:
> I also use the driver version for troubleshooting problem with users.  I
> roughly know what wasn't working in what version of the cx18 and ivtv
> drivers.  If the end user can tell me the driver version (using v4l2-ctl
> --log-status) along with his symptoms, it makes my life easier.

Easier:
  "I run Ubuntu 10.4".
  "I run kernel 2.6.32."
One of these is usually already included in the first post or IRC message
from the user.

Separate driver versions are only needed on platforms where drivers are
not distributed by the operating system distributor, or driver source code
is not released within kernel source code.
-- 
Stefan Richter
-=====-==-== -==- ==---
http://arcgraph.de/sr/

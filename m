Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab0IZLba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 07:31:30 -0400
Received: from khc.piap.pl ([195.187.100.11]:45057 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486Ab0IZLb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 07:31:29 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Joe Perches <joe@perches.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
        T Dent <tdent48227@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
	<20100925233600.GA2854@lst.de>
	<AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
	<20100925235643.GA3224@lst.de> <20100926000154.GB5299@thunk.org>
	<1285459769.6115.74.camel@Joe-Laptop>
	<20100926003255.GA19690@thunk.org>
	<1285462243.6115.89.camel@Joe-Laptop>
	<1285462722.6115.95.camel@Joe-Laptop>
	<m3iq1t6m5s.fsf@intrepid.localdomain>
	<1285483766.6115.180.camel@Joe-Laptop>
Date: Sun, 26 Sep 2010 13:31:11 +0200
In-Reply-To: <1285483766.6115.180.camel@Joe-Laptop> (Joe Perches's message of
	"Sat, 25 Sep 2010 23:49:26 -0700")
Message-ID: <m3d3s07ncw.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> It's relatively easy to see if named
> maintainer has authored or signed a
> commit in the past few years.
>
> Perhaps you'll go through the effort to
> mark the sections as orphaned.

It wouldn't make sense to orphan code based solely on the maintainer
not committing anything in X years. Many parts of the kernel are already
finalized and need nothing from the maintainers (the only changes they
receive are things like these caused by internal kernel interface
changes). Example: ISA drivers. And I assume you look at drivers,
subsystems, directories, not mere files (many .h files weren't touched
since they were written).

You orphan the code when
a) it needs action from the maintainer, and
b) the maintainer isn't there, and
c) the above isn't going to change.
-- 
Krzysztof Halasa

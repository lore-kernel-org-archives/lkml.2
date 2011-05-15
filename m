Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1EOMW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 08:22:56 -0400
Received: from serv04.lahn.de ([213.239.197.57]:38132 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab1EOMWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 08:22:54 -0400
Date: Sun, 15 May 2011 14:20:18 +0200
From: Michael Leun <lkml20100708@newton.leun.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jian Peng <jipeng2005@gmail.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine compliant
 to AHCI spec"
Message-ID: <20110515142018.081d8a47@xenia.leun.net>
In-Reply-To: <201105151125.19614.rjw@sisk.pl>
References: <201105120025.34531.rjw@sisk.pl>
	<20110514102804.GB23665@htj.dyndns.org>
	<BANLkTik1nFKX1Eyov_o0Xd0rr01Si5hSqA@mail.gmail.com>
	<201105151125.19614.rjw@sisk.pl>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 May 2011 11:25:19 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday, May 15, 2011, Jian Peng wrote:
> > Hi, Michael/Rafael/Gu,
> > 
> > Could you help me understand the testing environme? I like to
> > reproduce it if it is possible and debug it. The host controller
> > this patch dealing with is not used on PC so my testing environment
> > is quite different.

We have seen it on at least 3 different controllers from at least 2
different vendors (I do not know, what hardware Gu has).

So, for now, it looks like to happen on more different controllers than
not.

Testing environment - uhm, what shall I say? On each of the two
notebooks affected runs 64bit openSuSE 11.4 in more or less default
configuration (apart from kernel, of course).

Just do a "ls -lR /" and watch kernel log while plugging/unplugging
power.

Maybe running a 64bit system/kernel is part of picture? As far as I can
see all affected machines run 64bit.

> Well, the system I can reproduce it on is a production one, so I can't
> really test too much on it.  What exactly would you like to do?

I've at least one machine available where I can test. So, if there is
anything (preferably non destructive ;-) ) you want me to test this
should be possible.

Maybe I'll have a look if my netbook (running 32bit) is also affected.

-- 
MfG,

Michael Leun


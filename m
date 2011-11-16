Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab1KPRnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:43:33 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41820 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757802Ab1KPRnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:43:32 -0500
Message-ID: <1321465409.16820.12.camel@Joe-Laptop>
Subject: Re: [PATCH] MAINTAINERS: update maintainers for blackfin arch and
 drivers.
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, Sonic Zhang <sonic.adi@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 16 Nov 2011 09:43:29 -0800
In-Reply-To: <201111161211.03784.vapier@gentoo.org>
References: <1321429708-13862-1-git-send-email-sonic.adi@gmail.com>
	 <201111161020.53989.vapier@gentoo.org>
	 <1321461375.16820.7.camel@Joe-Laptop>
	 <201111161211.03784.vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 12:11 -0500, Mike Frysinger wrote:
> On Wednesday 16 November 2011 11:36:15 Joe Perches wrote:
> > On Wed, 2011-11-16 at 10:20 -0500, Mike Frysinger wrote:
> > > On Wednesday 16 November 2011 08:12:06 Joe Perches wrote:
> > > > Drivers or arches without specific people to maintain
> > > > them really should not have "S: Supported".
> > > > These should really be "S: Orphan".
> > > all the drivers are still maintained.  use the L: option to find the
> > > maintainer.
> > I believe I know how the MAINTAINERS
> > entries work.
> > From MAINTAINERS:
> > 	M: Mail patches to: FullName <address@domain>
> > 	L: Mailing list that is relevant to this area
> > Mailing lists aren't maintainers.
> they contain all the maintainers

That's akin to lkml as the kernel maintainer.

> > Maybe Analog Devices should create
> > an email address alias like
> > linux-devel@analog.com
> 
> so we should duplicate the ml into an alias to keep MAINTAINERS happy ?

When there is a company but not individuals responsible for
an arch or drivers, then yes.

> makes no sense.  use the ml.

You mean the list that bounces my email?

>-----Original Message-----
>From: uclinux-dist-devel-bounces@blackfin.uclinux.org
>[mailto:uclinux-dist-devel-bounces@blackfin.uclinux.org]

That's suboptimal.


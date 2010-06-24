Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab0FXTkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 15:40:37 -0400
Received: from mail.perches.com ([173.55.12.10]:1283 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752Ab0FXTkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 15:40:36 -0400
Subject: Re: [PATCH 0/3] b43: logging cleanups
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Larry.Finger@lwfinger.net, mb@bu3sch.de, zajec5@gmail.com
In-Reply-To: <20100624185339.GC2368@tuxdriver.com>
References: <cover.1276988387.git.joe@perches.com>
	 <20100624185339.GC2368@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 12:40:32 -0700
Message-ID: <1277408432.1654.80.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 14:53 -0400, John W. Linville wrote:
> On Sat, Jun 19, 2010 at 04:30:08PM -0700, Joe Perches wrote:
> > Just some small cleanups
> > Joe Perches (3):
> >   drivers/net/wireless/b43: Use local ratelimit_state
> >   drivers/net/wireless/b43: Logging cleanups
> >   drivers/net/wireless/b43: Rename b43_debug to b43_debugging
> Any of the b43 guys want to express an opinion on these?

Stefano, are you active here?
Your last ack for b43 was Feb 2008.
There have been 400+ commits to b43 without your ack.

Should your name be moved from MAINTAINERS to CREDITS?

$ ./scripts/get_maintainer.pl --rolestats -f drivers/net/wireless/b43/
Stefano Brivio <stefano.brivio@polimi.it> (maintainer:B43 WIRELESS DRIVER)
"John W. Linville" <linville@tuxdriver.com> (maintainer:NETWORKING [WIREL...,commit_signer:204/240=85%)
"Rafał Miłecki" <zajec5@gmail.com> (commit_signer:83/240=35%)
"Gábor Stefanik" <netrolller.3d@gmail.com> (commit_signer:44/240=18%)
Michael Buesch <mb@bu3sch.de> (commit_signer:39/240=16%)
Larry Finger <Larry.Finger@lwfinger.net> (commit_signer:13/240=5%)
linux-wireless@vger.kernel.org (open list:B43 WIRELESS DRIVER)
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)



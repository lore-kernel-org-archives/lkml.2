Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab2CMUNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:13:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43059 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab2CMUNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:13:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL] Renesas SoC updates for v3.4, take 2
Date: Tue, 13 Mar 2012 21:17:50 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Paul Mundt <lethal@linux-sh.org>
References: <201203092155.04731.rjw@sisk.pl> <201203132036.22991.rjw@sisk.pl> <201203131939.36186.arnd@arndb.de>
In-Reply-To: <201203131939.36186.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203132117.50390.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 13, 2012, Arnd Bergmann wrote:
> On Tuesday 13 March 2012, Rafael J. Wysocki wrote:
> > > Note that the __io() issue has turned out to be more urgent than I first
> > > thought when we discussed it, so it would be good to apply the patch below
> > > on top of your series.
> > 
> > Do you want me to apply it now or will you do that in your tree?
> 
> Doesn't matter to me, as long as one of you applies it ;-)

OK, so I will add it to the soc branch in the Renesas tree.

Thanks,
Rafael

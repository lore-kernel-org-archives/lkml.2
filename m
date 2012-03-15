Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031978Ab2COVc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:32:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47674 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756761Ab2COVcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:32:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the arm-soc tree with Linus' tree
Date: Thu, 15 Mar 2012 22:36:27 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <damm@opensource.se>, Paul Mundt <lethal@linux-sh.org>
References: <20120315175000.897f1172c296d4a687be0537@canb.auug.org.au> <1362815.uO65s14ojU@avalon> <201203152001.12353.arnd@arndb.de>
In-Reply-To: <201203152001.12353.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203152236.27977.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 15, 2012, Arnd Bergmann wrote:
> On Thursday 15 March 2012, Laurent Pinchart wrote:
> > The following patch (5d7220ec000f rebased on top of 1740d3448012) shows the
> > correct conflict resolution in my opinion.
> > 
> > From f040ba69632a54c86767974768d68b308901061c Mon Sep 17 00:00:00 2001
> > From: Magnus Damm <damm@opensource.se>
> > Date: Wed, 29 Feb 2012 12:37:19 +0900
> > Subject: [PATCH] ARM: mach-shmobile: sh7372 map_io and init_early update
> > 
> > ARM: mach-shmobile: sh7372 map_io and init_early update
> > 
> > Update the sh7372 SoC and the AP4EVB and Mackerel boards to make use
> > of the functions sh7372_map_io() and sh7372_add_early_devices().
> > 
> > Signed-off-by: Magnus Damm <damm@opensource.se>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Hi Laurent,
> 
> I've merged Paul's branch into my renesas/soc branch, because I don't
> rebase the branches once they are merged into arm-soc. Thanks a lot
> for the resolution you suggested, I used the same resulting code
> in the merge commit.
> 
> I'm not particularly happy about how we got here. Obviously, the bug
> fixes that Paul sent should have gone through the arm-soc tree to
> avoid this situation, and they should have been based on a -rc release
> rather than some random commit after -rc6. It's not a big issue
> because the next/soc branch already contains -rc7 though.

This is a consequece of our decision that Paul would handle v3.3 fixes
and push them directly to Linus, while I would take new material for v3.4,
sorry about that.

It should be a temporary problem only, though, because once v3.3 has been
released, all arm/mach-shmobile fixes will go through the arm-soc tree.

Thanks,
Rafael

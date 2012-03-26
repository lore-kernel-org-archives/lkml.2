Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab2CZUkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:40:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36572 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab2CZUkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:40:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] PM / SDIO: Use empty system suspend/resume callbacks at the bus level
Date: Mon, 26 Mar 2012 22:44:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
References: <20120325203849.7a908e32@notabene.brown> <201203262159.09335.rjw@sisk.pl> <87vclrxhhk.fsf@laptop.org>
In-Reply-To: <87vclrxhhk.fsf@laptop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203262244.34184.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 26, 2012, Chris Ball wrote:
> Hi Rafael,
> 
> On Mon, Mar 26 2012, Rafael J. Wysocki wrote:
> > OK, I don't see any objections.  Does it mean I can push this patch as a fix
> > for 3.4?  Chris?
> 
> Sounds good, I'll push it through the MMC tree.  (With a stable@ tag for
> 3.3 to fix the regression there.)

Cool, thanks!

Rafael

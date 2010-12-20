Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab0LTAPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 19:15:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39578 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab0LTAPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 19:15:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] ath9k: Do not use legacy PCI power management
Date: Mon, 20 Dec 2010 01:14:23 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        "John W. Linville" <linville@tuxdriver.com>
References: <201010160036.17653.rjw@sisk.pl> <201012200032.21704.rjw@sisk.pl> <4D0E9DE3.8050100@hauke-m.de>
In-Reply-To: <4D0E9DE3.8050100@hauke-m.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012200114.23527.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 20, 2010, Hauke Mehrtens wrote:
> On 12/20/2010 12:32 AM, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The ath9k driver uses legacy PCI power management (system suspend
> > and resume) callbacks, so make it use struct dev_pm_ops callbacks and
> > let the PCI subsystem handle all of the PCI-specific details of
> > system power transitions.
> > 
> > This change has been tested on Acer Ferrari One with the
> > Atheros AR928X PCI Express network adapter (rev. 01).
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> > 
> > Hi,
> > 
> > This patch has been sent already once under a slightly different subject
> > and with a different changelog.  I'm not sure what happened to it that time,
> > so here it goes again.
> > 
> > I'm quite confident it doesn't break things and it simplifies the driver's
> > suspend and resume routines quite a bit, so please apply.
> > 
> > Thanks,
> > Rafael
> > 
> Hi Rafael,
> 
> Your patch was already applied (see commit
> f0e94b479c987abef17eb18e5c8e0ed178d00cd4 in linux-next) or didn't I got
> your problem?

Oh, is it?  Sorry for the noise, then.

Thanks,
Rafael

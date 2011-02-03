Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab1BCTDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:03:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42450 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab1BCTDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:03:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthias Hopf <mat@mshopf.de>
Subject: Re: [Bug #26932] [SNB mobile] Oops in DRM intel driver, esp. during S3/S4 stress test
Date: Thu, 3 Feb 2011 20:03:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera> <-tcJxClTQPH.A.AWE.Q7eSNB@chimera> <20110203133524.GB5123@suse.de>
In-Reply-To: <20110203133524.GB5123@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102032003.29812.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 03, 2011, Matthias Hopf wrote:
> On Feb 03, 11 01:05:28 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.36 and 2.6.37.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.36 and 2.6.37.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> 
> The original issue of this bug is not a regression. Though during trying
> to reproduce with the latest kernel I stumbled over two regressions (one
> regarding frame buffer compression, already fixed in intel-drm-fixes,
> one regarding S3 trampoline code and NX, fix available, bug 27472).

I'm going to drop this bug from the list of recent regressions, then.

Thanks,
Rafael

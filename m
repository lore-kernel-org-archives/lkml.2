Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0LCVc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 16:32:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52722 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab0LCVcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:32:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: [Bug #23462] DVI/EDID broken with Intel i945 graphics and 2.6.37-rc2
Date: Fri, 3 Dec 2010 22:31:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <1OMp3vU_qjP.A.JXG.uxC-MB@chimera> <gUkHV_Vc3aE.A.xzG.SyC-MB@chimera> <20101203065515.GA4414@mac.home>
In-Reply-To: <20101203065515.GA4414@mac.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012032231.45615.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 03, 2010, Tino Keitel wrote:
> On Fri, Dec 03, 2010 at 00:41:45 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.36.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23462
> > Subject		: DVI/EDID broken with Intel i945 graphics and 2.6.37-rc2
> > Submitter	: Tino Keitel <tino.keitel@tikei.de>
> > Date		: 2010-11-16 18:49 (17 days old)
> > Message-ID	: <20101116184914.GA15794@mac.home>
> > References	: http://marc.info/?l=linux-kernel&m=128993389113001&w=2
> 
> 
> Hi,
> 
> this is fixed with 2.6.37-rc4-git2, works fine on my Mac mini.

Do you know the change that fixed it or you just can't reproduce it any more?

Rafael

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab1FSNp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 09:45:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39649 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab1FSNpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 09:45:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shawn Starr <shawn.starr@rogers.com>
Subject: Re: [Bug #37232] [3.0-rc1][NMI/DMAR][iwlagn] errors - PCI system error (SERR) for reason a1 on CPU 0
Date: Sun, 19 Jun 2011 15:46:02 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <vv0uv79EvLN.A.jiC.pNS9NB@chimera> <JL7O0m0yLjL.A.suC.xNS9NB@chimera> <9766569.DLsi33Yrbe@segfault.sh0n.net>
In-Reply-To: <9766569.DLsi33Yrbe@segfault.sh0n.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106191546.02503.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 19, 2011, Shawn Starr wrote:
> On Sunday, June 12, 2011 10:30:54 PM Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.39.  Please verify if it still should be listed and let the
> > tracking team know (either way).
> > 
> This continues in -rc3 (3.0-0.rc3.git5.1.fc16.x86_64)
> 
> [   22.675931] NMI: PCI system error (SERR) for reason a1 on CPU 0.
> [  163.002909] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe48000 
> [  163.002911] DMAR:[fault reason 05] PTE Write access is not set
> 
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] 
> Network Connection
> 
> I assume both of those are separate issues, but they continue in any case.

Thanks for the update.

Rafael

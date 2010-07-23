Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab0GWTyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 15:54:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53674 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037Ab0GWTyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:54:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tim.gardner@canonical.com
Subject: Re: [Bug #16111] hostap_pci: infinite registered netdevice wifi0
Date: Fri, 23 Jul 2010 21:53:06 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Petr Pisar <petr.pisar@atlas.cz>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera> <PRbv8sgxY6G.A.kQG.0VYSMB@chimera> <4C49958E.6060808@mail.tpi.com>
In-Reply-To: <4C49958E.6060808@mail.tpi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007232153.06721.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 23, 2010, Tim Gardner wrote:
> On 07/23/2010 02:15 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.33 and 2.6.34.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16111
> > Subject		: hostap_pci: infinite registered netdevice wifi0
> > Submitter	: Petr Pisar<petr.pisar@atlas.cz>
> > Date		: 2010-06-02 20:55 (52 days old)
> > Handled-By	: Tim Gardner<tim.gardner@canonical.com>
> > 		Petr Pisar<petr.pisar@atlas.cz>
> > Patch		: https://patchwork.kernel.org/patch/105008/
> > 		  https://bugzilla.kernel.org/attachment.cgi?id=27109
> >
> >
> 
> Commit d6a574ff6bfb842bdb98065da053881ff527be46 in Linus' tree

Thanks, closed.

Rafael


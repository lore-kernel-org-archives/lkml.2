Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931Ab0GWUG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:06:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53785 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758205Ab0GWUGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:06:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kees Cook <kees.cook@canonical.com>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [Bug #16294] [Q35 bisected] hang at init of i915 driver
Date: Fri, 23 Jul 2010 22:05:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera> <tneGvaw1wLL.A.9fB.v3XSMB@chimera> <20100723131825.GT3948@outflux.net>
In-Reply-To: <20100723131825.GT3948@outflux.net>
MIME-Version: 1.0
Message-Id: <201007232205.14936.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 23, 2010, Kees Cook wrote:
> Hi Rafael,
> 
> On Fri, Jul 23, 2010 at 01:47:30PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.34.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> 
> The regression still exists[1] in the mainline kernel -- the confirmed fix
> mentioned below has not been committed.

That's why the bug entry hasn't been closed yet. :-)

Rafael

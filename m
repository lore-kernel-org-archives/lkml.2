Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0GIUxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:53:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33713 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab0GIUxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:53:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #16197] [BUG on 2.6.35-rc2] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:11.0/0000:02:03.0/slot'
Date: Fri, 9 Jul 2010 22:52:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Alex Chiang" <achiang@canonical.com>,
       "Ryan Wang" <openspace.wang@gmail.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <TXb9XdQzJoD.A.5eD.pNmNMB@chimera> <20100708173344.2d108ffd@virtuousgeek.org>
In-Reply-To: <20100708173344.2d108ffd@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007092252.17784.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 09, 2010, Jesse Barnes wrote:
> On Fri,  9 Jul 2010 01:41:34 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.34.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16197
> > Subject		: [BUG on 2.6.35-rc2] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:11.0/0000:02:03.0/slot'
> > Submitter	: Ryan Wang <openspace.wang@gmail.com>
> > Date		: 2010-06-07 0:23 (32 days old)
> > Message-ID	: <AANLkTincwMZPnYW3S4uz4k2GOn52RpgBIBRfzyD010Yo@mail.gmail.com>
> > References	: http://marc.info/?l=linux-kernel&m=127587022219378&w=2
> 
> I thought this one was closed with the revert of the slot symlink?

You're right, closing.

Thanks,
Rafael

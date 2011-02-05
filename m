Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1BESYz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 13:24:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46777 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab1BESYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 13:24:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH 8/8] ACPI / PM: Use existing ACPI iomaps for NVS save/restore (v2)
Date: Sat, 5 Feb 2011 19:24:42 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <201101201226.41021.rjw@sisk.pl> <201101250032.07423.rjw@sisk.pl> <AANLkTi=nAhadVy6y6f4uOy0-pvTQrdwYgQ0y_4ukui2z@mail.gmail.com>
In-Reply-To: <AANLkTi=nAhadVy6y6f4uOy0-pvTQrdwYgQ0y_4ukui2z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102051924.43158.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 05, 2011, Jeff Chua wrote:
> The suspend monster is back! The suspend-to-ram is fine, but upon
> resume, screen is blank. Haven't bisected in case someone has also
> done so.
> 
> It's very recent. ... between commit
> 831d52bc153971b70e64eccfbed2b232394f22f8 and
> 44f2c5c841da1b1e0864d768197ab1497b5c2cc1.

BTW, please don't reply to messages containing patches with reports of problems
that aren't caused by those patches.  It's confusing at best and at worst it
may result in the patches being rejected.

Thanks,
Rafael

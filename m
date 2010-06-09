Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab0FILnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:43:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:42581 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754420Ab0FILny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:43:54 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/yYrYiAvbyDifD0zhK272/hKwi6VbW7E3HMReNd3
	ipljLxC8VEnGoU
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: ThinkPad T400 : should kernel option "reboot=pci" be hard coded ?
Date: Wed, 9 Jun 2010 13:43:48 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.4; i686; ; )
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <201006071122.21925.toralf.foerster@gmx.de> <20100607141103.GA9477@srcf.ucam.org>
In-Reply-To: <20100607141103.GA9477@srcf.ucam.org>
MIME-Version: 1.0
Message-Id: <201006091343.48924.toralf.foerster@gmx.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Matthew Garrett wrote at 16:11:03
> On Mon, Jun 07, 2010 at 11:22:21AM +0200, Toralf Förster wrote:
> > Since some kernel version (IIRC since 2.6.31) it is necessary to boot the
> > linux kernel with that option to prevent an extra 9 seconds delay during
> > reboot.
> > I found this tip on the LKML -and now I'm wondering whether this option
> > should be hard coded in the kernel sources b/c it seems to be necessary
> > for current kernels too.
> 
> No, the best thing to do would be to figure out what changed to require
> the extra 9 seconds. Are you able to work out which the last kernel
> release without this timeout was?
The delay exists since 2.6.27, versions before them I can't test due to 
udev-149 which don't work together with version < 2.6.27.

Since version 2.6.29 that kernel boot parameter avoids the extra delay, 2.6.28 
needs the 9 sec pause independend from what I specify during boot.

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


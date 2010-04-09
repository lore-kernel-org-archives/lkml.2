Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab0DITwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:52:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44748 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab0DITww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:52:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: 2.6.34-rc3-git8: Reported regressions 2.6.32 -> 2.6.33
Date: Fri, 9 Apr 2010 21:56:05 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
References: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera> <4BBE92AE.6090301@gmail.com>
In-Reply-To: <4BBE92AE.6090301@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004092156.05674.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 April 2010, Gertjan van Wingerde wrote:
> On 04/09/10 00:54, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15699
> > Subject		: rt2500usb driver cannot remain connected
> > Submitter	:  <abcd@gentoo.org>
> > Date		: 2010-04-05 19:30 (4 days old)
> > Handled-By	: Ivo van Doorn <IvDoorn@gmail.com>
> > 
> 
> This one ought to be fixed by commit 9e76ad2a27f592c1390248867391880c7efe78b3
> in Linus' tree.

Thanks, closing.

Rafael

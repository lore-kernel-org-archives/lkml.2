Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab0KSU2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:28:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38121 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797Ab0KSU23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:28:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Gross <jesse@nicira.com>
Subject: Re: 2.6.37-rc2-git4: Reported regressions 2.6.35 -> 2.6.36
Date: Fri, 19 Nov 2010 21:27:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera> <AANLkTinzHyWcfS++R_d+yqR9JQu7W51h0XRr-ikd_6y1@mail.gmail.com>
In-Reply-To: <AANLkTinzHyWcfS++R_d+yqR9JQu7W51h0XRr-ikd_6y1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011192127.30556.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 19, 2010, Jesse Gross wrote:
> On Thu, Nov 18, 2010 at 3:50 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=20462
> > Subject         : 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
> > Submitter       : Nikola Ciprich <extmaillist@linuxbox.cz>
> > Date            : 2010-10-15 7:10 (35 days old)
> > Message-ID      : <20101015071008.GA8714@pcnci.linuxbox.cz>
> > References      : http://marc.info/?l=linux-kernel&m=128712984831303&w=2
> 
> A fix for this has been sent to -stable:
> http://www.spinics.net/lists/netdev/msg146227.html

OK, status updated.

Thanks,
Rafael

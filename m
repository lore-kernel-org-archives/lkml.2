Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0DTENH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 00:13:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48899 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab0DTEND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 00:13:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.34-rc5: Reported regressions from 2.6.33
Date: Tue, 20 Apr 2010 06:13:33 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <20100419205723.8724338c.akpm@linux-foundation.org>
In-Reply-To: <20100419205723.8724338c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004200613.33696.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 April 2010, Andrew Morton wrote:
> On Tue, 20 Apr 2010 05:15:57 +0200 (CEST) "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15812
> > Subject		: utsname.domainname not set in x86_32 processes (causing "YPBINDPROC_DOMAIN: domain not bound" errors)
> > Submitter	:  <adi@hexapodia.org>
> > Date		: 2010-04-19 21:28 (1 days old)
> 
> I merged hch's fix for this twelve seconds ago.

I updated the entry.

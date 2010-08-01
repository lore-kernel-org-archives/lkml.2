Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab0HAVi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 17:38:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53673 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab0HAVi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 17:38:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.35-rc6-git6: Reported regressions from 2.6.34
Date: Sun, 1 Aug 2010 23:37:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
References: <2dWFdr9kTFM.A.P0D.spXVMB@chimera> <AANLkTimcH7+Bq1UEbaSU7SQpzArPgmSLegiqE13V8=CF@mail.gmail.com>
In-Reply-To: <AANLkTimcH7+Bq1UEbaSU7SQpzArPgmSLegiqE13V8=CF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008012337.09961.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 01, 2010, Linus Torvalds wrote:
> On Sun, Aug 1, 2010 at 6:46 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
...
> 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16369
> > Subject         : Yet another 2.6.35 regression (AGP)?
> > Submitter       : Woody Suwalski <terraluna977@gmail.com>
> > Date            : 2010-07-09 14:21 (24 days old)
> > Message-ID      : <4C373084.8000503@gmail.com>
> > References      : http://marc.info/?l=linux-kernel&m=127868797119254&w=2
> 
> Should hopefully be fixed by commit e7b96f28c58c ("agp/intel: Use the
> correct mask to detect i830 aperture size.")

Closed.

> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16365
> > Subject         : kernel BUG at fs/btrfs/extent-tree.c:1353
> > Submitter       : Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
> > Date            : 2010-07-08 14:27 (25 days old)
> > Message-ID      : <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>
> > References      : http://marc.info/?l=linux-kernel&m=127859960725931&w=2
> 
> This one is reportedly fixed by commit 83ba7b071f30 ("writeback:
> simplify the write back thread queue")

Closed.

> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16215
> > Subject         : sysfs: cannot create duplicate filename '/class/net/bnep0'
> > Submitter       : Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > Date            : 2010-06-15 14:55 (48 days old)
> > Handled-By      : Eric W. Biederman <ebiederm@xmission.com>
> 
> Fixed by commit 24b1442d01ae155ea716dfb94ed21605541c317d.

Closed.

Thanks,
Rafael

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab0HDNwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:52:43 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:51727 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622Ab0HDNwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:52:42 -0400
Date: Wed, 4 Aug 2010 14:51:46 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Kevin Cernekee <cernekee@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: Additional fix : (was [v2]printk: fix delayed messages from CPU
 hotplug events)
Message-ID: <20100804135145.GA21004@linux-mips.org>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C5DB6D1F@dbde02.ent.ti.com>
 <20100802154434.5615bcf9.akpm@linux-foundation.org>
 <EAF47CD23C76F840A9E7FCE10091EFAB02C641D8EC@dbde02.ent.ti.com>
 <20100803165926.2e37d355.akpm@linux-foundation.org>
 <20100804033034.GA15098@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804033034.GA15098@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 12:30:34PM +0900, Paul Mundt wrote:

> > An older version of this patch is present in linux-next, committed by
> > Paul Mundt, who wasn't cc'ed here(!).
> > 
> > Paul, please update.  Be aware that the version of the patch to which I
> > replied is also not the latest.
> > 
> I just reviewed it, it went in through the MIPS tree if memory serves
> correctly, so Ralf (added to Cc) would have been the one that checked it
> in. I'll take a look at the thread though.

Authored by Kevin Cernekee and committed by me.  No idea where akpm found
Paul's name.

commit 4251bce66898298b03824b7d94ce94c431404b54
Author:     Kevin Cernekee <cernekee@gmail.com>
AuthorDate: Thu Jun 3 22:11:25 2010 -0700
Commit:     Ralf Baechle <ralf@linux-mips.org>
CommitDate: Mon Aug 2 14:00:10 2010 +0100

Will update the patch.

  Ralf

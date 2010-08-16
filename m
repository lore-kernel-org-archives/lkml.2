Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0HPBWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 21:22:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891Ab0HPBWX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 21:22:23 -0400
Date: Sun, 15 Aug 2010 18:21:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: sedat.dilek@gmail.com, Andi Kleen <ak@linux.intel.com>,
        len.brown@intel.com, Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull request] ACPI patches for 2.6.36.merge
Message-Id: <20100815182153.994179c1.akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=Ok3NH3k5EF1Da2Z3xA7uahABRtH7pEdOEuZH2@mail.gmail.com>
References: <AANLkTikV2eVo6KM5dSqfDwAwT=bVxnuWSpBE7F+JQU+_@mail.gmail.com>
	<AANLkTi=vngT_5XYz1=3P6GjExFNtCVCdBMhaz4Sc4oEk@mail.gmail.com>
	<20100815133015.883c7069.akpm@linux-foundation.org>
	<AANLkTi=Ok3NH3k5EF1Da2Z3xA7uahABRtH7pEdOEuZH2@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Aug 2010 14:04:09 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Aug 15, 2010 at 1:30 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > I'd be suspecting that we have two patches both of which worked
> > separately but which broke when combined.  Is there some other patch in
> > that tree which adds a new reference to `ref' in acpi_power_seq_show()?
> 
> The offending patch isn't about acpi_power_seq_show(), it's about
> acpi_power_off_device().

The patch I sent Len patched acpi_power_seq_show().

> 
> ...
>
> What does that say about the _rest_ of the patches?

Not tested in combination?

> What does that say about (lack of) -next testing?

That code compiled OK in -mm which includes linux-next.  I assume that
some last-minute merging broke things.


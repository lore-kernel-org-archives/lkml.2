Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2DKFrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 01:47:32 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37733 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2DKFrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 01:47:31 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] irq_domain: fix formatting of chip data pointer in virq_debug_show()
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, benh@kernel.crashing.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
In-Reply-To: <20120410232708.CAC3D3E079B@localhost>
References: <1334060743-7901-1-git-send-email-mika.westerberg@linux.intel.com> <1334060743-7901-2-git-send-email-mika.westerberg@linux.intel.com> <20120410232708.CAC3D3E079B@localhost>
Date: Tue, 10 Apr 2012 23:47:28 -0600
Message-Id: <20120411054728.A6C093E081E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012 17:27:08 -0600, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue, 10 Apr 2012 15:25:43 +0300, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> > On 32-bit machines reading the /sys/kernel/debug/irq_domain_mapping file
> > outputs following:
> > 
> > virq   hwirq    chip name        chip data           domain name
> >     9  0x00000  IO-APIC          0x        c175a0f8  none
> >    10  0x00000  IO-APIC          0x        c175a108  none
> >    11  0x00000  IO-APIC          0x        c175a118  none
> > ...
> > 
> > which looks a bit funny. Fix that with filling the gap with zeroes instead
> > of spaces.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Applied, thanks.

I've dropped this one again.  There is actually an easier way to
achieve the same result.  By dropping the precision entirely from the
format string the output will always get 0 extended.  I'll post an
alternate patch soon.

g.


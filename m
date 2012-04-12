Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab2DLALe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:11:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35050 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab2DLALc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:11:32 -0400
MIME-Version: 1.0
In-Reply-To: <1334187888.2984.50.camel@pasglop>
References: <1334186326-22649-1-git-send-email-grant.likely@secretlab.ca>
 <1334186326-22649-2-git-send-email-grant.likely@secretlab.ca> <1334187888.2984.50.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 11 Apr 2012 18:11:11 -0600
X-Google-Sender-Auth: U24i1QyTBBu5tA1xrPvikbV9JlI
Message-ID: <CACxGe6tAu8ZR7S4qqWGWaKjRQ-vZemwXoso8T=noRstkuXmgXg@mail.gmail.com>
Subject: Re: [PATCH 1/3] irq_domain: remove "hint" when allocating irq numbers
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Milton Miller <miltonm@bga.com>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 5:44 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2012-04-11 at 17:18 -0600, Grant Likely wrote:
>> The 'hint' used to try and line up irq numbers with hw irq numbers is
>> rather a hack and not very useful.  It also had some value when irq
>> reverse mapping was lazy, and not done right at map time.  However, the
>> lazy mapping is to be removed, so keeping around 'hint' isn't helpful
>> anymore.  This patch removes it.
>
> Please document that this also removes the support for irq_virq_count,
> which breaks PS3, to be "fixed" by your patch 3/3 (you may want to
> re-order the patches here) and that fixes an actual bug with mapping of
> interrupts above NR_IRQS

Yes, I'll either fix this patch or reorder before merging.

g.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab2GXEh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 00:37:58 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56367 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2GXEh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 00:37:57 -0400
MIME-Version: 1.0
In-Reply-To: <1343100106.3715.2.camel@pasglop>
References: <alpine.LSU.2.00.1207211911160.1585@eggly.anvils>
 <1343011543.2957.2.camel@pasglop> <CACxGe6uFvtro7iR8FewgChLr_6PnZA-EaRMKQjrFEaEHg7SKRQ@mail.gmail.com>
 <1343082371.2957.39.camel@pasglop> <CACxGe6uo8jx3GQFQpQ5RTHF5JyN2hEgvcvdmSYfGyTQnzK9fOA@mail.gmail.com>
 <CACxGe6udruWL7oo6Qp6jkwQYceduTO1h1gKFz9TFX1TPZoNFNQ@mail.gmail.com> <1343100106.3715.2.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 23 Jul 2012 22:37:35 -0600
X-Google-Sender-Auth: HdpG26iRZrTLdBZ5FQQ0BFq43pE
Message-ID: <CACxGe6vx0isTS6e9W6+QsYfYsMKNiqc8haGdmre2aFE91yhthQ@mail.gmail.com>
Subject: Re: next/mmotm unbootable on G5: irqdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hughd@google.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 9:21 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2012-07-23 at 16:32 -0600, Grant Likely wrote:
>> > As-is I'm backing off from the linear/legacy/tree merge patch as just
>> > too risky. I've already pulled that stuff out of linux-next.
>>
>> Can I pull you pseries fix into my tree (my preference), or do I need
>> to rebase on top of yours?
>
> The mpic fix for the g5 is in Linus tree already, I added it on top of
> powerpc -next before I asked Linus to pull.
>
> For pseries (ie the fix for irq_find_mapping vs. radix), I don't have a
> formal patch, just the one I hand typed in my previous email, so do
> whatever you want with it.

Okay, I'll merge in Linus' tree at the appropriate point to protect
against bisection, and I'll fix up the appropriate patch that touches
irq_find_mapping.

g.

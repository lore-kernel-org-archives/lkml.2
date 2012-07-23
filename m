Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2GWWcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 18:32:54 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49140 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab2GWWcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 18:32:52 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6uo8jx3GQFQpQ5RTHF5JyN2hEgvcvdmSYfGyTQnzK9fOA@mail.gmail.com>
References: <alpine.LSU.2.00.1207211911160.1585@eggly.anvils>
 <1343011543.2957.2.camel@pasglop> <CACxGe6uFvtro7iR8FewgChLr_6PnZA-EaRMKQjrFEaEHg7SKRQ@mail.gmail.com>
 <1343082371.2957.39.camel@pasglop> <CACxGe6uo8jx3GQFQpQ5RTHF5JyN2hEgvcvdmSYfGyTQnzK9fOA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 23 Jul 2012 16:32:31 -0600
X-Google-Sender-Auth: _UyTJtmaREgZTQRGWi_pW5Tb0Kk
Message-ID: <CACxGe6udruWL7oo6Qp6jkwQYceduTO1h1gKFz9TFX1TPZoNFNQ@mail.gmail.com>
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

On Mon, Jul 23, 2012 at 4:31 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Jul 23, 2012 at 4:26 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>> On Mon, 2012-07-23 at 01:59 -0600, Grant Likely wrote:
>>> My tree must be rebased to eliminate bisect breakage. The existing
>>> commits in my tree have the breakage, and fiddling with the merge
>>> order doesn't affect that. I don't want to rebase though. The safest
>>> approach (smallest window of breakage) is to apply that fix onto my
>>> irqdomain tree.
>>
>> With your other breakage on pseries I'm thinking rebasing might be the
>> only option...
>
> Fair enough. I'm not planning to ask Linus to pull for a few days yet
> anyway. I've been pretty useless as a kernel maintainer for the last 3
> months so I want to give a bit more time in linux-next to catch
> fallout before it gets merged.
>
> As-is I'm backing off from the linear/legacy/tree merge patch as just
> too risky. I've already pulled that stuff out of linux-next.

Can I pull you pseries fix into my tree (my preference), or do I need
to rebase on top of yours?

g.

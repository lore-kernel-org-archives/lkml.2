Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2GWW0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 18:26:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:55173 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab2GWW0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 18:26:48 -0400
Message-ID: <1343082371.2957.39.camel@pasglop>
Subject: Re: next/mmotm unbootable on G5: irqdomain
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Hugh Dickins <hughd@google.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Tue, 24 Jul 2012 08:26:11 +1000
In-Reply-To: <CACxGe6uFvtro7iR8FewgChLr_6PnZA-EaRMKQjrFEaEHg7SKRQ@mail.gmail.com>
References: <alpine.LSU.2.00.1207211911160.1585@eggly.anvils>
	 <1343011543.2957.2.camel@pasglop>
	 <CACxGe6uFvtro7iR8FewgChLr_6PnZA-EaRMKQjrFEaEHg7SKRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-23 at 01:59 -0600, Grant Likely wrote:
> My tree must be rebased to eliminate bisect breakage. The existing
> commits in my tree have the breakage, and fiddling with the merge
> order doesn't affect that. I don't want to rebase though. The safest
> approach (smallest window of breakage) is to apply that fix onto my
> irqdomain tree.

With your other breakage on pseries I'm thinking rebasing might be the
only option...

Cheers,
Ben.



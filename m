Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab1D3HOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 03:14:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58891 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab1D3HOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 03:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Nufe+zdmHIA8ILLPUJ5Y5Rh0YOfcRsKJ93DpjxxOb1BB6aQnSfevGPGJ/v4nsPULLi
         iapJQbFSpKYUT7qVwHDH3dFAvxxAXfh6/89MTbu4RU2lI/8OWwLD14Bc5Ow9XVVixcIF
         0mzoaqTfmrnsKOCWdevFN8Fdnsh9L9DQEbP2Y=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1104292200110.9459@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
	<20110429164227.GA25491@elte.hu>
	<alpine.DEB.2.00.1104291353310.23685@cl320.eecs.utk.edu>
	<20110429185741.GB10217@elte.hu>
	<alpine.DEB.2.00.1104292200110.9459@cl320.eecs.utk.edu>
Date: Sat, 30 Apr 2011 10:14:32 +0300
X-Google-Sender-Auth: Zl4hPNPmYbaL5-FMf8cKLnrnpIY
Message-ID: <BANLkTimOcaFRxyr=sfdNbe0MXGWu9u1o1w@mail.gmail.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
From: Pekka Enberg <penberg@kernel.org>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince,

On Sat, Apr 30, 2011 at 5:17 AM, Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> But your argument isn't that.  Your argument is that you're blocking raw
> event access as some sort of punishment because us HPC people aren't
> providing patches for "generalized" events that we never plan to use.
> That's not a technical argument, that's some sort of weird power play.

That's not his argument at all and if you fail to see that you really
have no idea what the concept "working with the maintainer" means.

Yes, raw event access was reverted from 2.6.39 but that doesn't mean
it's blocked forever. If you want to keep pushing your feature, please
tone down your crazy-talk and start acting like a developer who's
genuinely interested in Linux, not on your own narrow, selfish goals.

I mean really, I haven't even had the pleasure of interracting a lot
with you and while I personally don't see the problem with raw event
access (if done in a well-thought out manner from ABI pov), you've
already managed to convince me that applying _any_ patch from you is a
bad idea because the baggage that comes with it is simply not worth
it.

If you want to alienate other developers, keep doing what you're doing
- otherwise consider changing your tactics. It's boring to watch you
repeat the same mistakes over and over again.

                        Pekka

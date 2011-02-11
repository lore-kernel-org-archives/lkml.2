Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab1BKNNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 08:13:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:41736 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab1BKNMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 08:12:53 -0500
Subject: Re: 2.6.37 kernel warning in perf_events code
From: Peter Zijlstra <peterz@infradead.org>
To: Arun Sharma <arun@sharma-home.net>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
In-Reply-To: <AANLkTimwaOSC9CmO0rCPrRkCac-=Yj2PGg1DE_d0aM55@mail.gmail.com>
References: <AANLkTi=4_p73eHhQbj5DDDEzTWaLou+u2igiY+yNiPQ9@mail.gmail.com>
	 <20110210190843.GE20676@ghostprotocols.net>
	 <AANLkTi=WRrBnyiDqOeR7PnqVhh8wLFx5W0tgjNaPvkLg@mail.gmail.com>
	 <20110210202023.GG20676@ghostprotocols.net>
	 <AANLkTi=H9+rKjgkmfbS2jzfPjryah0cc9sajSgN8WOaQ@mail.gmail.com>
	 <20110211004232.GA22440@ghostprotocols.net>
	 <AANLkTimwaOSC9CmO0rCPrRkCac-=Yj2PGg1DE_d0aM55@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 13:16:09 +0100
Message-ID: <1297426569.5226.41.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 16:57 -0800, Arun Sharma wrote:
> On Thu, Feb 10, 2011 at 4:42 PM, Arnaldo Carvalho de Melo
> <acme@redhat.com> wrote:
> > Is it possible for you to test this with 2.6.38-rc4? At least the user
> > level tools, just do:
> 
> I tried the 2.6.38rc3 perf binary on two machines:
> 
> kernel = 2.6.37: The machine hung solid on the first try.
> kernel = 2.6.38rc3: I could run it 10 times in a loop and no bad runs.
> 
> Looks like this is already fixed in newer kernels.

I couldn't actually reproduce on .37 with the given details, so while
its already fixed it would be nice to figure out what patch fixed it so
we can make sure it ends up in .37-stable.

Could you provide exact reproduction details or maybe bisect the thing?


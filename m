Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab1C2VNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:13:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:49757 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab1C2VNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:13:20 -0400
Subject: Re: [PATCH] POWER: perf_event: Skip updating kernel counters if
 register value shrinks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric B Munson <emunson@mgebm.net>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org
In-Reply-To: <20110329142519.GA3527@mgebm.net>
References: <1301059689-4556-1-git-send-email-emunson@mgebm.net>
	 <1301378637.2402.671.camel@pasglop>  <20110329142519.GA3527@mgebm.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 08:12:45 +1100
Message-ID: <1301433165.2402.689.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 10:25 -0400, Eric B Munson wrote:
> Here I made the assumption that the hardware would never remove more events in
> a speculative roll back than it had added.  This is not a situation I
> encoutered in my limited testing, so I didn't think underflow was possible.  I
> will send out a V2 using the signed 32 bit delta and remeber to CC stable
> this time. 

I'm not thinking about underflow but rollover... or that isn't possible
with those counters ? IE. They don't wrap back to 0 after hitting
ffffffff ?

Cheers,
Ben.



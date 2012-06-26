Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2FZWK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 18:10:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:35103 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab2FZWK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 18:10:26 -0400
Message-ID: <1340748603.3732.26.camel@pasglop>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org,
        Zhao Chenhui <chenhui.zhao@freescale.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Jun 2012 08:10:03 +1000
In-Reply-To: <4FEA2D93.3030002@freescale.com>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
	 <AB6D43A9-FC54-40D2-A9B0-8B2E785124F9@kernel.crashing.org>
	 <4FEA2D93.3030002@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 16:45 -0500, Scott Wood wrote:

> Some parts are due to corenet versus non-corenet, such as the actual
> register you write to to disable/enable the timebase.
> 
> There's also a two-core assumption in the synchronization code which
> I've complained about multiple times -- although on closer inspection it
> looks like this is done under cpu_add_remove_lock, and we can assume
> that there's only one core at a time in take_timebase(), regardless of
> how many cores are in the system.

Right, it should work fine with any number of cores or am I missing
something ? (btw, since when complaining about something helps ? :-)

Cheers,
Ben.



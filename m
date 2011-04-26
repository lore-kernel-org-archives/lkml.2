Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab1DZOX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:23:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab1DZOXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:23:25 -0400
Subject: Re: [PATCH 00/13] Swap-over-NBD without deadlocking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>
In-Reply-To: <1303803414-5937-1-git-send-email-mgorman@suse.de>
References: <1303803414-5937-1-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 16:23:05 +0200
Message-ID: <1303827785.20212.266.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 08:36 +0100, Mel Gorman wrote:
> Comments?

Last time I brought up the whole swap over network bits I was pointed
towards the generic skb recycling work:

  http://lwn.net/Articles/332037/

as a means to pre-allocate memory, and it was suggested to simply pin
the few route-cache entries required to route these packets and
dis-allow swap packets to be fragmented (these last two avoid lots of
funny allocation cases in the network stack).



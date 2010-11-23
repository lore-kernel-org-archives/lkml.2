Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab0KWX6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:58:00 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49421 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab0KWX57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:57:59 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Subject: Re: [RFC] mlock: release mmap_sem every 256 faulted pages
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Nick Piggin <npiggin@kernel.dk>, Rik van Riel <riel@redhat.com>
In-Reply-To: <AANLkTi=dK9wQaHm=tXOCqN2BDw5jEtH5qfs9zRHbE0qT@mail.gmail.com>
References: <20101122215746.e847742d.akpm@linux-foundation.org> <AANLkTi=dK9wQaHm=tXOCqN2BDw5jEtH5qfs9zRHbE0qT@mail.gmail.com>
Message-Id: <20101124085451.7BE5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 24 Nov 2010 08:57:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > A more compelling description of why this problem needs addressing
> > would help things along.
> 
> Oh my. It's probably not too useful for desktops, where such large
> mlocks are hopefully uncommon.
> 
> At google we have many applications that serve data from memory and
> don't want to allow for disk latencies. Some of the simpler ones use
> mlock (though there are other ways - anon memory running with swap
> disabled is a surprisingly popular choice).
> 
> Kosaki is also showing interest in mlock, though I'm not sure what his
> use case is.

I don't have any solid use case. Usually server app only do mlock anonymous memory.
But, I haven't found any negative effect in your proposal, therefore I hope to help
your effort as I always do when the proposal don't have negative impact.




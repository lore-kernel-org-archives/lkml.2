Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab0JRVDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:03:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:45788 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab0JRVDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:03:25 -0400
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org, pacman@kosh.dhis.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101018123750.ef7d6d48.akpm@linux-foundation.org>
References: <20101013144044.GS30667@csn.ul.ie>
	 <20101013175205.21187.qmail@kosh.dhis.org>
	 <20101018113331.GB30667@csn.ul.ie>
	 <20101018123750.ef7d6d48.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 08:02:16 +1100
Message-ID: <1287435736.2341.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 12:37 -0700, Andrew Morton wrote:
> Well, you've spotted a bug so I'd say we fix it asap.
> 
> It's a bit of a shame that we lose the only known way of reproducing a
> different bug, but presumably that will come back and bite someone
> else
> one day, and we'll fix it then :(

Well, I can always revert that and run some experiments here, provided I
can reproduce the problem at all ...

Cheers,
Ben.



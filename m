Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab0I0FCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:02:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab0I0FCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:02:04 -0400
Date: Mon, 27 Sep 2010 01:02:00 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jens Axboe <axboe@kernel.dk>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Adrian Hunter <adrian.hunter@nokia.com>,
        linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [PATCH] block: prevent merges of discard and write requests
Message-ID: <20100927050200.GS13116@bombadil.infradead.org>
References: <1285411002-22924-1-git-send-email-adrian.hunter@nokia.com>
 <4C9DD1B0.9020902@kernel.dk>
 <20100927033030.GR13116@bombadil.infradead.org>
 <4CA024C8.3000203@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA024C8.3000203@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 01:59:52PM +0900, Jens Axboe wrote:
> > Jens, is this (the REQ_DISCARD hunk) required for stable as well? It
> > appears there's not much change relating to merging requests between
> > HEAD and v2.6.35, so I assume it is?
> 
> No, 2.6.35 and earlier is safe, it's only 2.6.36-rc that is
> affected by this bug.
> 

Groovy! Thanks for the quick reply.

--Kyle

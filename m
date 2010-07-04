Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab0GDR62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 13:58:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:41014 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab0GDR60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 13:58:26 -0400
Date: Sun, 4 Jul 2010 10:33:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/6] block: push down BKL into .open and .release
Message-ID: <20100704103310.368dee05@infradead.org>
In-Reply-To: <20100704080146.GA31828@merkur.ravnborg.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
	<1278193640-24223-3-git-send-email-arnd@arndb.de>
	<20100704080146.GA31828@merkur.ravnborg.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jul 2010 10:01:46 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:
> Lot's of other places could benefit from improved goto error handling.
> The driver maintainers should do this (if there is a maintainer).
> I stopped with the small replacement patches.

it's the floppy driver for amigas
not sure if any of those are still alive at all running linux.....

I think time can be more usefully spend on other drivers... 

this guy probably should move to staging instead


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

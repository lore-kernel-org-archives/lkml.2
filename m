Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab0HWKdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:33:31 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51877 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab0HWKd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:33:28 -0400
Message-ID: <4C724E79.2080804@kernel.dk>
Date: Mon, 23 Aug 2010 12:33:29 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] BLOCK: fix bio.bi_rw handling
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz> <1281616266-4709-3-git-send-email-jslaby@suse.cz>
In-Reply-To: <1281616266-4709-3-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-12 14:31, Jiri Slaby wrote:
> Return of the bi_rw tests is no longer bool after commit 74450be1. But
> results of such tests are stored in bools. This doesn't fit in there
> for some compilers (gcc 4.5 here), so either use !! magic to get real
> bools or use ulong where the result is assigned somewhere.

Added, sorry for the delay!

-- 
Jens Axboe


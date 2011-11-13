Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1KMS5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 13:57:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:55577 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab1KMS5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 13:57:18 -0500
Message-ID: <4EC01306.5030208@kernel.dk>
Date: Sun, 13 Nov 2011 19:57:10 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Xiaotian Feng <dfeng@redhat.com>, Dan Rosenberg <drosenberg@vsecurity.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Always check length of all iov entries in blk_rq_map_user_iov()
References: <1321210507.18929.293.camel@deadeye>
In-Reply-To: <1321210507.18929.293.camel@deadeye>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-13 19:55, Ben Hutchings wrote:
> Even after commit 5478755616ae2ef1ce144dded589b62b2a50d575
> ("block: check for proper length of iov entries earlier ...")
> we still won't check for zero-length entries after an unaligned
> entry.  Remove the break-statement, so all entries are checked.

Thanks, that is an oversight. Applied.

-- 
Jens Axboe


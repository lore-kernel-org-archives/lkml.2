Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141Ab0HLNhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 09:37:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab0HLNg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:36:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] BLOCK: fix bio.bi_rw handling
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz>
	<1281616266-4709-3-git-send-email-jslaby@suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 12 Aug 2010 09:35:53 -0400
In-Reply-To: <1281616266-4709-3-git-send-email-jslaby@suse.cz> (Jiri Slaby's
	message of "Thu, 12 Aug 2010 14:31:06 +0200")
Message-ID: <x49eie43qdi.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> Return of the bi_rw tests is no longer bool after commit 74450be1. But
> results of such tests are stored in bools. This doesn't fit in there
> for some compilers (gcc 4.5 here), so either use !! magic to get real
> bools or use ulong where the result is assigned somewhere.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Cheers,
Jeff

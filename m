Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2JAMpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:45:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab2JAMpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:45:13 -0400
Date: Mon, 1 Oct 2012 13:45:08 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: import of the device-mapper series failed
Message-ID: <20121001124508.GA5014@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20121001132246.85b1943b16ec7a671fdd1ff6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001132246.85b1943b16ec7a671fdd1ff6@canb.auug.org.au>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 01:22:46PM +1000, Stephen Rothwell wrote:
> Trying to import the device-mapper series produce this error:
> $ git am ../quilt/device-mapper/dm-thin-support-discard-with-non-power-of-two-block-size.patch
> Applying: Support discards when the pool's block size is not a power of 2.
> error: patch failed: drivers/md/dm-thin.c:2762
> error: drivers/md/dm-thin.c: patch does not apply
> and indeed the code in question is very different from what the patch
> expects.  Is there a missing patch?

NEXT_BASE is lagging behind BASE: I removed the fixes that already went
upstream - but should probably have waited until NEXT_BASE had picked them up.

Alasdair


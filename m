Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1E0NDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:03:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab1E0NC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:02:59 -0400
Date: Fri, 27 May 2011 09:02:49 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, msb@chromium.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH 2/3] block: Move non-rotational flag to queue limits
Message-ID: <20110527130248.GA17219@redhat.com>
References: <4DDEA689.2090004@fusionio.com>
 <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
 <1306464169-4291-3-git-send-email-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306464169-4291-3-git-send-email-martin.petersen@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26 2011 at 10:42pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> To avoid special-casing the non-rotational flag when stacking it is
> moved from the queue flags to be part of the queue limits. This allows
> us to handle it like the remaining I/O topology information.

blk_queue_nonrot vs blk_queue_non_rotational lends itself to a small
amount of confusion.

What about:
 s/blk_queue_nonrot/blk_queue_non_rotational/
 s/blk_queue_non_rotational/blk_queue_set_non_rotational/
?

Otherwise, looks great.

Acked-by: Mike Snitzer <snitzer@redhat.com>

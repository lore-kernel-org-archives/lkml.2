Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0IMTbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:31:00 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40222 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0IMTa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:30:59 -0400
Message-ID: <4C8E7BED.3080003@fusionio.com>
Date: Mon, 13 Sep 2010 21:30:53 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Benny Halevy <bhalevy@panasas.com>
CC: Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] block: fix blk_rq_map_kern bio direction flag
References: <1284404907-14599-1-git-send-email-bhalevy@panasas.com>
In-Reply-To: <1284404907-14599-1-git-send-email-bhalevy@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-13 21:08, Benny Halevy wrote:
> This bug was introduced in 7b6d91daee5cac6402186ff224c3af39d79f4a0e
> "block: unify flags for struct bio and struct request"

Thanks, that's pretty nasty. I'll expedite this.

-- 
Jens Axboe


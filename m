Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab0CSH54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 03:57:56 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51495 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab0CSH5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 03:57:55 -0400
Date: Fri, 19 Mar 2010 08:57:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  block: remove 16 bytes of padding from struct request
	on  64bits
Message-ID: <20100319075754.GN5768@kernel.dk>
References: <1268907592.2047.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268907592.2047.6.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18 2010, Richard Kennedy wrote:
> Remove alignment padding to shrink struct request from 336 to 320 bytes
> so needing one fewer cacheline and therefore removing 48 bytes from
> struct request_queue.

Thanks Richard, applied.

-- 
Jens Axboe


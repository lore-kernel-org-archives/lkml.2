Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0CXHTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 03:19:40 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34449 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952Ab0CXHTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 03:19:39 -0400
Date: Wed, 24 Mar 2010 08:19:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-kernel@vger.kernel.org,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] i2o: Remove the dangerous kobj_to_i2o_device macro
Message-ID: <20100324071937.GC5768@kernel.dk>
References: <87aatz0xrj.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aatz0xrj.fsf@tac.ki.iif.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23 2010, Ferenc Wagner wrote:
> This macro worked only when applied to variables named 'kobj'.
> While this could have been fixed by simply renaming the macro argument,
> a more type-safe replacement by an inline function would be preferred.
> However, nobody uses this macro, so it's simpler to just remove it.

Thanks, applied to the block tree.

-- 
Jens Axboe


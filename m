Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab0DBGkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 02:40:06 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34594 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392Ab0DBGj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 02:39:59 -0400
Date: Fri, 2 Apr 2010 08:39:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Mike Miller <mike.miller@hp.com>,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
       Andrew Morton <akpm@linux-foundation.org>, iss_storagedev@hp.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] cciss: unlock on error path
Message-ID: <20100402063958.GS23510@kernel.dk>
References: <20100401155404.GD5265@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401155404.GD5265@bicker>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01 2010, Dan Carpenter wrote:
> We take the spin_lock again in fail_all_cmds() so we need to unlock
> here.

Thanks Dan, applied.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab0DHMpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 08:45:43 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53129 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757876Ab0DHMpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 08:45:40 -0400
Date: Thu, 8 Apr 2010 14:45:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: Update mtime when writing using aops
Message-ID: <20100408124539.GM10103@kernel.dk>
References: <201004081551.37824.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004081551.37824.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08 2010, Nikanth Karthikesan wrote:
> Update mtime when writing to backing filesystem using the address space
> operations write_begin and write_end.

You forgot to include a 'why' :-)

Not that I disagree with the patch, just curious what made you make the
change.

-- 
Jens Axboe


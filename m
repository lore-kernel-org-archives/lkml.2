Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab2DZSWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:22:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513Ab2DZSWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:22:34 -0400
Date: Thu, 26 Apr 2012 14:22:30 -0400
From: Josef Bacik <josef@redhat.com>
To: Jim Meyering <jim@meyering.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: avoid buffer overrun in btrfs_printk
Message-ID: <20120426182230.GA1890@localhost.localdomain>
References: <87vckmwiwv.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vckmwiwv.fsf@rho.meyering.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 06:35:12PM +0200, Jim Meyering wrote:
> 
> The buffer read-overrun would be triggered by a printk format
> starting with <N>, where N is a single digit.  NUL-terminate
> after strncpy.  Use memcpy, not strncpy, since we know the
> string we're copying fits in the destination buffer and
> contains no NUL byte.
> 
> Signed-off-by: Jim Meyering <meyering@redhat.com>

Reviewed-by: Josef Bacik <josef@redhat.com

I just noticed this but could you send to linux-btrfs@vger.kernel.org from now
on?  Thanks,

Josef

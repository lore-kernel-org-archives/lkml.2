Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab0GUCFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 22:05:21 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37989 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762067Ab0GUCFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 22:05:18 -0400
Message-ID: <4C4655D6.30802@kernel.dk>
Date: Tue, 20 Jul 2010 20:05:10 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Subject: Re: [PATCH 00/26] cciss updates July 19, 2010
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2010 12:44 PM, Stephen M. Cameron wrote:
> The following series implements mostly cleanups to the initialization
> code in cciss along the same lines as what's already been done in hpsa.
> 
> There are also a few bug fixes.  The SCSI tape code was not setting the
> performant mode bits in commands, which caused a hang.  The code to
> reset controllers via PCI power management methods only works on old
> controllers, so an alternate method is used for newer controllers.
> 
> There are a couple of big patches to make cciss use more consistent
> variable names (always h for hba, and c for command, rather than a
> mishmash of various things names) and to generally use dev_warn, etc.
> instead of printk.
> 
> These patches apply to the 'for-2.6.36' branch of Jens Axboe's git
> tree: http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=summary
> (there are many changes to cciss in that tree on which these patches depend.)

I have applied these, but please next time don't duplicate in the
body what you already put in the subject. We end up with logs like:

    cciss: change printks to dev_warn, etc.
    
    cciss: change printks to dev_warn, etc.
    
    Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

which is not too pretty.

-- 
Jens Axboe


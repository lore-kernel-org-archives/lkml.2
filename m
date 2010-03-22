Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0CVCMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 22:12:30 -0400
Received: from thunk.org ([69.25.196.29]:51228 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab0CVCMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 22:12:20 -0400
Date: Sun, 21 Mar 2010 20:20:50 -0400
From: tytso@mit.edu
To: Steven Liu <lingjiujianke@gmail.com>
Cc: linux-ext4@vger.kernel.org, adilger@sun.com,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix coding style in fs/ext4/move_extent.c
Message-ID: <20100322002050.GA11560@thunk.org>
Mail-Followup-To: tytso@mit.edu, Steven Liu <lingjiujianke@gmail.com>,
	linux-ext4@vger.kernel.org, adilger@sun.com,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org
References: <bd0d95d71003170312s10fd8680xcbea67cc8d681296@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd0d95d71003170312s10fd8680xcbea67cc8d681296@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 06:12:14PM +0800, Steven Liu wrote:
> fix a code style in fs/ext4/move_extent.c
> 
> Signed-off-by: LiuQi <lingjiujianke@gmail.com>

I've added this to the ext4 patch queue with the following changelog
description:

ext4: Fix coding style in fs/ext4/move_extent.c

From: Steven Liu <lingjiujianke@gmail.com>

Making sure ee_block is initialized to zero to prevent gcc from
kvetching.  It's harmless (although it's not obvious that it's
harmless) from code inspection:

fs/ext4/move_extent.c:478: warning: 'start_ext.ee_block' may be used
uninitialized in this function

Thanks to Stefan Richter for first bringing this to the attention of
linux-ext4@vger.kernel.org.

Signed-off-by: LiuQi <lingjiujianke@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>

						- Ted


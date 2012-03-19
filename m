Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab2CSEQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 00:16:19 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:41408 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab2CSEQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 00:16:18 -0400
Date: Mon, 19 Mar 2012 00:16:19 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] ext4: Add no_printk argument validation, fix
 fallout
Message-ID: <20120319041619.GJ31682@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1331856299.git.joe@perches.com>
 <12b7235b4eeb7c50ac888b7f28bc1cf737bc397b.1331856300.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12b7235b4eeb7c50ac888b7f28bc1cf737bc397b.1331856300.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 05:07:32PM -0700, Joe Perches wrote:
> Add argument validation to debug functions.
> Use ##__VA_ARGS__.
> 
> Fix format and argument mismatches.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.

					- Ted

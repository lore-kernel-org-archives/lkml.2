Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab2CSENe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 00:13:34 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:41403 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab2CSENd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 00:13:33 -0400
Date: Mon, 19 Mar 2012 00:13:35 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] ext4: Remove redundant "EXT4-fs: " from uses of
 ext4_msg
Message-ID: <20120319041335.GI31682@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1331856299.git.joe@perches.com>
 <d029f3995ba3c6f50a031671c40dfbcc764da4d2.1331856300.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d029f3995ba3c6f50a031671c40dfbcc764da4d2.1331856300.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 05:07:34PM -0700, Joe Perches wrote:
> ext4_msg adds "EXT4-fs: " to the messsage output.
> Remove the redundant bits from uses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.

					- Ted

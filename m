Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2I0MDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:03:34 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:52666 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab2I0MDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:03:33 -0400
Date: Thu, 27 Sep 2012 08:03:29 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        ext4 development <linux-ext4@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: remove redundant offset check in
 move_extents.c/mext_check_arguments
Message-ID: <20120927120329.GF15707@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Wang Sheng-Hui <shhuiw@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
References: <500D0542.1020000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500D0542.1020000@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 04:03:14PM +0800, Wang Sheng-Hui wrote:
> In the check code above, if orig_start != donor_start, we would
> return -EINVAL. So here, orig_start should be equal with donor_start.
> Remove the redundant check here.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

Applied, thanks.  (And apologies for the delay in getting back to
you!)

					- Ted

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab2KHWVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 17:21:07 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:60113 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680Ab2KHWVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 17:21:04 -0500
Date: Thu, 8 Nov 2012 12:14:17 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Zhao Hongjiang <zhaohongjiang37@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: get rid of the duplicate code on ext4_fill_super
Message-ID: <20121108171417.GC19977@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Zhao Hongjiang <zhaohongjiang37@gmail.com>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <508E30F8.3090606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508E30F8.3090606@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 03:32:08PM +0800, Zhao Hongjiang wrote:
> From: Zhao Hongjiang <zhaohongjiang@huawei.com>
> 
> Clean the duplicate code on ext4_fill_super cause the bellow
> also have it.
> 
> Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>

Applied, thanks!

I used the commit description:

     ext4: get rid of redundant code in ext4_fill_super()

     	       	      		     	- Ted

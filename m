Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab0LTDWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 22:22:16 -0500
Received: from thunk.org ([69.25.196.29]:43121 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab0LTDWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 22:22:14 -0500
Date: Sun, 19 Dec 2010 22:22:09 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        Jiri Kosina <trivial@kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 37/49] fs/ext4: Use vzalloc
Message-ID: <20101220032209.GF23626@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jiri Kosina <trivial@kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
 <960a7efc569f61a50346257835ce5f457a0d4c99.1288925425.git.joe@perches.com>
 <F35C793E-7CBA-4631-8928-C34D5B39F148@dilger.ca>
 <1288941511.18440.63.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288941511.18440.63.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 12:18:31AM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> differences from V1:
> Andreas Dilger requested a block be moved so that
> sbi->s_flex_groups isn't tested for NULL twice.
> Also coalesced a ext4_msg printk format.

Thanks, applied to the ext4 tree

					- Ted

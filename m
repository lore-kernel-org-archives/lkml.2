Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0ITOV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:21:26 -0400
Received: from THUNK.ORG ([69.25.196.29]:50937 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435Ab0ITOVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:21:24 -0400
Date: Mon, 20 Sep 2010 10:21:16 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix NULL pointer dereference in
 print_daily_error_info
Message-ID: <20100920142116.GI3554@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100914125102.GA5318@swordfish.minsk.epam.com>
 <20100914194641.GB3730@thunk.org>
 <20100915063517.GA8456@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915063517.GA8456@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 09:35:18AM +0300, Sergey Senozhatsky wrote:
> Fix NULL pointer dereference in print_daily_error_info, when   
> called on unmounted fs (EXT4_SB(sb) returns NULL), by removing error 
> reporting timer in ext4_put_super.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Thanks, added to the ext4 patch tree

						- Ted

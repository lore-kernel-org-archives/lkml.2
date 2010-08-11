Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0HKNhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 09:37:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55176 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0HKNhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 09:37:53 -0400
Date: Wed, 11 Aug 2010 14:37:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix reiserfs_evict_inode end_writeback second call
Message-ID: <20100811133751.GG31363@ZenIV.linux.org.uk>
References: <20100811110701.GA5362@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100811110701.GA5362@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 02:07:01PM +0300, Sergey Senozhatsky wrote:
> reiserfs_evict_inode calls end_writeback two times hitting
> kernel BUG at fs/inode.c:298 becase inode->i_state is I_CLEAR already.

Applied, thanks.

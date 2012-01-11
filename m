Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2AKL6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:58:53 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38723
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694Ab2AKL6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:58:52 -0500
Date: Wed, 11 Jan 2012 06:58:46 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <mszeredi@suse.cz>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [git pull] vfs pile 1
Message-ID: <20120111115846.GA2646@infradead.org>
References: <20120105022318.GG23916@ZenIV.linux.org.uk>
 <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 08, 2012 at 03:04:30PM -0800, Linus Torvalds wrote:
> Hmm.
> 
> Al, Miklos, I just triggered the new inc_link() warning three times in
> very close succession by just doing a simple

Also just as expected the set_nlink warnings triggers during XFS log
recovery (not that I haven't pointed this out multiple times before):

[ 1702.280003] XFS (vdb2): Starting recovery (logdev: internal)
[ 1702.294935] set_nlink() clearing i_nlink on xfs inode 320
[ 1702.297909] set_nlink() clearing i_nlink on xfs inode 256
[ 1702.301082] set_nlink() clearing i_nlink on xfs inode 192
[ 1702.304305] set_nlink() clearing i_nlink on xfs inode 321
[ 1702.306980] set_nlink() clearing i_nlink on xfs inode 257
[ 1702.308204] set_nlink() clearing i_nlink on xfs inode 193
[ 1702.309490] set_nlink() clearing i_nlink on xfs inode 322
[ 1702.311195] set_nlink() clearing i_nlink on xfs inode 258
[ 1702.313156] set_nlink() clearing i_nlink on xfs inode 194
[ 1702.315203] set_nlink() clearing i_nlink on xfs inode 323

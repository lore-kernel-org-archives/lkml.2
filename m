Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1HCVxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 17:53:48 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39765
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755141Ab1HCVxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 17:53:41 -0400
Date: Wed, 3 Aug 2011 17:53:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        akpm@linux-foundation.org, toshi.okajima@jp.fujitsu.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 2/4] vfs: keep list of mounts for each superblock
Message-ID: <20110803215337.GA2684@infradead.org>
References: <1312368521-7911-1-git-send-email-miklos@szeredi.hu>
 <1312368521-7911-3-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312368521-7911-3-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 12:48:39PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Keep track of vfsmounts belonging to a superblock.  List is protected
> by vfsmount_lock.

Looks reasonable to me.


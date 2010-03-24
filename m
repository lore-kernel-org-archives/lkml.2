Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0CXJUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:20:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35505 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab0CXJUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:20:13 -0400
Date: Wed, 24 Mar 2010 09:20:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Two patches for fs/super.c
Message-ID: <20100324092011.GO30031@ZenIV.linux.org.uk>
References: <20100324051140.10015.32854.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324051140.10015.32854.stgit@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 04:12:23PM +1100, NeilBrown wrote:
> 
> Two patches.
> 
>  The second removes S_BIAS which is unnecessary and so potentially
>  confusing.
> 
>  The first I found the need for while preparing the second patch.  It
>  seems that get_active_super doesn't follow the pattern of all other
>  code that walks the super_blocks list.

See #untested in vfs tree...

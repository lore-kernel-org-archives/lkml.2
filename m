Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2DEPlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:41:22 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35399
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753853Ab2DEPlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 11:41:21 -0400
Date: Thu, 5 Apr 2012 11:41:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, mszeredi@suse.cz
Subject: Re: [PATCH 27/34] fuse: implement i_op->atomic_create()
Message-ID: <20120405154118.GA3360@infradead.org>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
 <1333637940-31884-28-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333637940-31884-28-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 04:58:53PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Replace fuse's ->create implementation with a ->atomic_create implementation.
> No functionality is changed.

atomic_create is atomic_open now.  Same applies for the subject and
commit log in a couple of the following patches.


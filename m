Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2DEPfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:35:03 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35377
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab2DEPfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 11:35:01 -0400
Date: Thu, 5 Apr 2012 11:34:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, mszeredi@suse.cz,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH 16/34] nfs: don't open in ->d_revalidate
Message-ID: <20120405153453.GA31847@infradead.org>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
 <1333637940-31884-17-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333637940-31884-17-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 04:58:42PM +0200, Miklos Szeredi wrote:
> dentry turned out to be invalid, drop the dentry and return ESTALE to let the
> VFS retry.

This should read EOPENSTALE.


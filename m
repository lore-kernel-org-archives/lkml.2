Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab1FFPB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:01:29 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50922
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753530Ab1FFPB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:01:27 -0400
Date: Mon, 6 Jun 2011 11:01:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix ->mknod() return value on xfs_get_acl() failure
Message-ID: <20110606150125.GA22236@infradead.org>
References: <20110605111231.GD11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605111231.GD11521@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 12:12:31PM +0100, Al Viro wrote:
> 	->mknod() should return negative on errors and PTR_ERR() gives
> already negative value...

Indeed.  Thanks for the patch.


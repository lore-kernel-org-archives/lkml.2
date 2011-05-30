Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1E3M4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:56:39 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46824
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309Ab1E3M4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:56:35 -0400
Date: Mon, 30 May 2011 04:59:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Sage Weil <sage@newdream.net>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [git pull] dentry_unhash() breakage
Message-ID: <20110530085922.GA11336@infradead.org>
References: <20110530020604.GC561@dastard>
 <20110530034741.GD561@dastard>
 <Pine.LNX.4.64.1105292057570.9134@cobra.newdream.net>
 <20110530055601.GK11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530055601.GK11521@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 06:56:01AM +0100, Al Viro wrote:
> A couple of dentry_unhash fallout fixes

Shouldn't we do the shrink_dcache_parent only after a successfull
rmdir or rename?


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1G0Tjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:39:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43804
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab1G0Tjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:39:39 -0400
Date: Wed, 27 Jul 2011 15:39:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
Message-ID: <20110727193937.GA5354@infradead.org>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
 <20110727160752.GC974@fieldses.org>
 <alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
 <20110727181111.GA23009@infradead.org>
 <alpine.DEB.2.02.1107271530340.1451@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1107271530340.1451@p34.internal.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 03:35:01PM -0400, Justin Piszcz wrote:
> Currently I do not see any dupes, however I have a script that moves
> images out of the directory once an hour:
> 0 * * * * /usr/local/bin/move_to_old2.sh > /dev/null 2>&1

Do you keep adding files to the directory while you move files out?
What's the rate of additions/removals to the directory?

If we add files to the directory while removing others we could easily
re-use the same offset for a different file.


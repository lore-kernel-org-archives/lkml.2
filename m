Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab2BCOIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:08:53 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42625
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754661Ab2BCOIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:08:51 -0500
Date: Fri, 3 Feb 2012 09:08:34 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: make do_writepages() use plugging
Message-ID: <20120203140834.GA15495@infradead.org>
References: <1328275626-5322-1-git-send-email-amit.sahrawat83@gmail.com>
 <20120203133823.GB17571@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203133823.GB17571@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 09:38:23PM +0800, Wu Fengguang wrote:
> On Fri, Feb 03, 2012 at 06:57:06PM +0530, Amit Sahrawat wrote:
> > This will cover all the invocations for writepages to be called with
> > plugging support.
>  
> Thanks.  I'll test it on the major filesystems. But would you
> name a few filesystems that are expected to benefit from it?
> It's not obvious because some FS ->writepages eventually calls
> generic_writepages() which already does plugging.

Ant that's exactly where it should stay instead of beeing sprinkled all
over the VM code.

NAK to the patch.


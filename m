Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab0JHIR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:17:26 -0400
Received: from verein.lst.de ([213.95.11.210]:49379 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892Ab0JHIRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:17:24 -0400
Date: Fri, 8 Oct 2010 10:17:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, chris.mason@oracle.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/18] fs: rework icount to be a locked variable
Message-ID: <20101008081714.GB1728@lst.de>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com> <1286515292-15882-10-git-send-email-david@fromorbit.com> <20101008072749.GB7831@lst.de> <20101008075001.GT4681@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008075001.GT4681@dastard>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 06:50:01PM +1100, Dave Chinner wrote:
> > There's no need to lock a normal 32-bit variable for readers.
> 
> Ok, but will need a memory barrier instead?

Isn't spin_unlock supposed to be one?  I'll need some of the locking
experts to shime in.


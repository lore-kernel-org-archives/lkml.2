Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1B1Itm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 03:49:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab1B1Itk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 03:49:40 -0500
Date: Mon, 28 Feb 2011 03:49:29 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Dilger <adilger@dilger.ca>
Cc: "djwong@us.ibm.com" <djwong@us.ibm.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Message-ID: <20110228084929.GA27227@infradead.org>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
 <180713DB-114C-454B-A91E-063AB0116251@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <180713DB-114C-454B-A91E-063AB0116251@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:13:49AM -0700, Andreas Dilger wrote:
> Can you please attach your reproducer? IIRC it needed mmap() to hit this problem?  Did you measure CPU usage during your testing?

Running XFSQA on a DIF target reproduces it.  Even scsi_debug in the
right mode is enough.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab0EYLMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 07:12:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab0EYLMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 07:12:10 -0400
Date: Tue, 25 May 2010 07:12:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-fsdevel@vger.kernel.org,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>, "Jayson R. King" <dev@jaysonking.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [10/24] vfs: Add no_nrwrite_index_update writeback control flag
Message-ID: <20100525111208.GA8779@infradead.org>
References: <20100524223544.GA13721@kroah.com> <20100524223016.208581966@clark.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100524223016.208581966@clark.site>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 03:28:06PM -0700, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.

NACK.  This has been shown to cause severe writeback regression for
other filesystems and is beeing reverted in mianline.

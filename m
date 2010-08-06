Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903Ab0HFMEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 08:04:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42057 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab0HFMED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 08:04:03 -0400
Date: Fri, 6 Aug 2010 08:03:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Josef Bacik <josef@redhat.com>, hch@infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: PATCH 3/6 - direct-io: do not merge logically non-contiguous
 requests
Message-ID: <20100806120358.GA31601@infradead.org>
References: <4C5BE8DB.5030503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5BE8DB.5030503@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something is deeply wrong here.  Raw block device access has a 1:1
mapping between logical and physical block numbers.  They really should
never be non-contiguous.

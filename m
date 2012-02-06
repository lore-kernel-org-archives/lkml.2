Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab2BFRbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:31:16 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56237
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754700Ab2BFRbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:31:15 -0500
Date: Mon, 6 Feb 2012 12:31:13 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH V2 1/2] hfsplus: Change finder_info to u32
Message-ID: <20120206173113.GA1135@infradead.org>
References: <1328215191-4201-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328215191-4201-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 03:39:50PM -0500, Matthew Garrett wrote:
> The finder_info block in the hfsplus volume header is currently defined as
> an array of 8 bit values, but TN1150 defines it as being an array of 32 bit
> values. Fix for convenience.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Looks good, I'll queue it up.


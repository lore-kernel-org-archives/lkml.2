Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2BGNZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:25:26 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60683
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279Ab2BGNZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:25:25 -0500
Date: Tue, 7 Feb 2012 08:25:23 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] hfsplus: Add an ioctl to bless files
Message-ID: <20120207132523.GA3131@infradead.org>
References: <20120206174943.GA14225@infradead.org>
 <1328559280-29111-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328559280-29111-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 03:14:40PM -0500, Matthew Garrett wrote:
> Making an hfsplus partition bootable requires the ability to "bless" a
> file by putting its inode number in the volume header. Doing this from
> userspace on a mounted filesystem is impractical since the kernel will
> write back the original values on unmount. Add an ioctl to allow userspace
> to update the volume header information based on the target file.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Looks good, thanks.

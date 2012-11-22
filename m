Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab2KVTrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:47:36 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33752
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492Ab2KVTre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:47:34 -0500
Date: Thu, 22 Nov 2012 14:47:31 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH v4 00/31] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20121122194731.GA12057@infradead.org>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 04:40:40PM -0600, Dave Kleikamp wrote:
> It introduces new file ops, read_iter() and write_iter(), that replace the
> aio_read() and aio_write() operations. The iov_iter structure can now contain
> either a user-space iovec or a kernel-space bio_vec. Since it would be
> overly complicated to replace every instance of aio_read() and aio_write(),
> the old operations are not removed, but file systems implementing the new
> ones need not keep the old ones.

How many instance of the old ones are left?  I'd really prefer to make
the full transition very quickly, even if not nessecarily in a single
patchset.


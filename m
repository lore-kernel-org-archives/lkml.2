Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab2GCD7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 23:59:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030Ab2GCD7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 23:59:41 -0400
Date: Mon, 2 Jul 2012 23:59:24 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, martin.petersen@oracle.com, david@fromorbit.com,
        xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de
Subject: Re: [PATCH v2 1/3] block: add sysfs entry for discard_alignment
Message-ID: <20120703035924.GA6182@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
 <1341235225-27551-2-git-send-email-pbonzini@redhat.com>
 <20120703023442.GB3586@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120703023442.GB3586@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02 2012 at 10:34pm -0400,
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, Jul 02, 2012 at 03:20:23PM +0200, Paolo Bonzini wrote:
> > The next patches will actually use the alignment, expose it in sysfs
> > for ease of debugging.
> > 
> 
> Don't we already have discard_alignment exported as device attribute.
> 
> /sys/block/<dev>/discard_alignment

Yes we do.  It is documented in Documentation/ABI/testing/sysfs-block

So this patch isn't needed.

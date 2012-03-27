Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab2C0HAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:00:50 -0400
Received: from verein.lst.de ([213.95.11.211]:48522 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab2C0HAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:00:47 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2012 03:00:47 EDT
Date: Tue, 27 Mar 2012 08:54:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] block: align start sector of a discard request
Message-ID: <20120327065400.GA23067@lst.de>
References: <1331745148-24885-1-git-send-email-pbonzini@redhat.com> <4F71617F.60103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F71617F.60103@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 08:43:11AM +0200, Paolo Bonzini wrote:
> Christoph, since you talked about this on the qemu-devel mailing list,
> do you have a few free cycles to review this?

Oh, I completely missed that you already sent patches for the issue.
I'll take a look.


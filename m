Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1ECJ53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:57:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34335 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab1ECJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:57:27 -0400
Date: Tue, 3 May 2011 05:57:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Monakhov <dmonakhov@openvz.org>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] blkdev: Submit discard bio in batches in
 blkdev_issue_discard()
Message-ID: <20110503095724.GA14603@infradead.org>
References: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
 <4DBEDA78.7020502@fusionio.com>
 <alpine.LFD.2.00.1105031128390.4250@dhcp-27-109.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1105031128390.4250@dhcp-27-109.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 11:30:43AM +0200, Lukas Czerner wrote:
> I know that you and Christoph were working on adding support for
> vectored discard, but I do not know what is the status of it ?

I've not gotten further than the prototype yet.  I plan to eventually
look into it, but I have some more urgent projects first.


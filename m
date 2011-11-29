Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1K2Eor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 23:44:47 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56526
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378Ab1K2Eop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 23:44:45 -0500
Date: Mon, 28 Nov 2011 23:44:42 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SCSI] sd: Lower printk level for drive cache information
Message-ID: <20111129044442.GA19616@infradead.org>
References: <20111128163053.GA24618@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128163053.GA24618@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 11:31:55AM -0500, Josh Boyer wrote:
> Numerous devices don't present cache data, particularly USB sticks.  The
> devices operate correctly despite this, so lower the printk severity to
> KERN_NOTICE.

Do they?  The last reports on the list were for devices that didn't
present it but actually needed cache flushes despite not having the
cache mode page.


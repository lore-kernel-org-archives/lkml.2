Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1GNOpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 10:45:20 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56746
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754603Ab1GNOpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 10:45:18 -0400
Date: Thu, 14 Jul 2011 10:45:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Barkalow <barkalow@iabervon.org>,
        Christoph Hellwig <hch@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with hfsplus on ipods in 2.6.38+
Message-ID: <20110714144514.GA6145@infradead.org>
References: <alpine.LNX.2.00.1107131942190.2056@iabervon.org>
 <20110714135302.GA28501@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714135302.GA28501@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 08:53:02AM -0500, Seth Forshee wrote:
> This has had some discussion on lkml previously [1]. I've been trying to
> work on a fix, but the current iteration has problems, and I haven't
> been able to get testers to provide the logs I've requested to help me
> see what's going wrong. If you'd like to help by providing logs from the
> most recent test build on the bug you linked to (or using the patches
> from that build) that would be great. I unfortunately don't have any
> large-sector devices to test with and cannot reproduce the problems on
> 512-byte sector devices.

I've been trying to get a large block size test device using qemu
or scsi_debug but haven't managed to get back to it.  If you can get
Daniel to test you're patches I'd really appreciate your help.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1FSOe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 10:34:27 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53116
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019Ab1FSOeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 10:34:25 -0400
Date: Sun, 19 Jun 2011 10:34:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Meelis Roos <mroos@linux.ee>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: 3.0-rc3: WARNING: at fs/fs-writeback.c:356
 writeback_single_inode+0x3e/0x18f()
Message-ID: <20110619143422.GA19875@infradead.org>
References: <alpine.SOC.1.00.1106141213570.11764@math.ut.ee>
 <1308112976.2635.27.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308112976.2635.27.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 02:42:56PM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2011-06-14 at 12:15 +0300, Meelis Roos wrote:
> > Tested 3.0-rc3 on my PC (2 PATA disks, single duron CPU). Got several of 
> > these in dmesg:
> 
> Same here on a powerpc64 machine while doing a fresh debian install
> (while the installer's installing the packages), -rc3 as well.

Does commit 50338b889dc504c69e0cb316ac92d1b9e51f3c8a fix the issue for
you?


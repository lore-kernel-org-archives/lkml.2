Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab0LTAdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 19:33:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:32140 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab0LTAdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 19:33:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,198,1291622400"; 
   d="scan'208";a="869889156"
Date: Mon, 20 Dec 2010 01:33:38 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/20] mfd: wm831x: irq_data conversion.
Message-ID: <20101220003337.GC3206@sortiz-mobl>
References: <cover.1292241952.git.buytenh@wantstofly.org>
 <20101213123121.GB15575@mail.wantstofly.org>
 <20101213123935.GB21535@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213123935.GB21535@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Dec 13, 2010 at 12:39:35PM +0000, Mark Brown wrote:
> On Mon, Dec 13, 2010 at 01:31:21PM +0100, Lennert Buytenhek wrote:
> > Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
> 
> If you're doing this sort of work you really need to work against -next
> or the individual development tree rather than Linus' tree.  The Wolfson
> drivers have been converted in -next for a while now.
> 
> I also posted patches for everything in MFD except ezx-pcap over the
> weekend - I pushed a branch up to a git tree earlier today with these
> changes in, I'll try to keep it up to date with the acks I'm getting.
> I'll add Lennart's ezx-pcap patch to that.
> 
> The following changes since commit 3ec93fcb34a97a9806a7280b136a7af20edf61f1:
> 
>   mfd: Fix twl_probe section mismatch warning in mfd/twl-core.c (2010-12-10 20:59:59 +0100)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc-2.6.git mfd-irq
I've pulled this one into my for-next branch.
Big thanks for taking care of this, I appreciate.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

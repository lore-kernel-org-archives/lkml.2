Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1IKHBa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 03:01:30 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:50038 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1IKHB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 03:01:29 -0400
Date: Sun, 11 Sep 2011 08:01:15 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: NeilBrown <neilb@suse.de>, Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@lst.de>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: md related oops triggered in bdev_inode_switch_bdi
Message-ID: <20110911070115.GA6361@sucs.org>
References: <20110831162211.2a1fe3fb@notabene.brown>
 <20110901033056.GA22050@localhost>
 <20110901154936.26e35821@notabene.brown>
 <CAF1ivSaTP27UnU3jf+ETDNV3j7FCekBRTZL8LvDSKj6UVcUJww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1ivSaTP27UnU3jf+ETDNV3j7FCekBRTZL8LvDSKj6UVcUJww@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 04:56:30PM +0800, Lin Ming wrote:
> On Thu, Sep 1, 2011 at 1:49 PM, NeilBrown <neilb@suse.de> wrote:
> > On Thu, 1 Sep 2011 11:30:56 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> >
> >> Hi Neil,
> >>
> >> > Subject: [PATCH] Avoid dereferencing a 'request_queue' after last close.
> >>
> >> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
> >
> > Thanks.
 
> Just FYI,
> this patch also fixes below bug which can be reproduced by unplug the
> usb disk before umount.

Agreed - this fixes the oops I was seeing pulling out a USB key with a
mounted FAT32 filesystem (https://lkml.org/lkml/2011/9/5/339 ). Thanks
to Yang RuiRui and akpm for point me to this patch.

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

-- 
Sitsofe | http://sucs.org/~sits/

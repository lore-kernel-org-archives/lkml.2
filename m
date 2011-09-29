Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab1I2Q5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 12:57:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab1I2Q5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 12:57:12 -0400
Date: Thu, 29 Sep 2011 22:27:06 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 00/11] virtio: Support for hibernation (S4)
Message-ID: <20110929165706.GH3708@amit-x200.redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
 <20110929154925.GG3708@amit-x200.redhat.com>
 <23581.1317314927@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23581.1317314927@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) 29 Sep 2011 [12:48:47], Valdis.Kletnieks@vt.edu wrote:
> On Thu, 29 Sep 2011 21:19:25 +0530, Amit Shah said:
> > On (Thu) 29 Sep 2011 [20:55:56], Amit Shah wrote:
> > > Hello,
> > > 
> > > These patches add support for S4 to virtio (pci) and all drivers.  The
> > > patches are based on the virtio-console patch series in Rusty's queue.
> > 
> > Some patches have checkpatch warnings, re-sending those as v2.
> 
> When doing something like this, don't say "some" - say "patches 4,5, 6, and 9".
> Otherwise we're looking at 11 patches from the first set, 4 replacements, and
> no way to tell if we've missed a 5th replacement patch.

Makes sense, will do that in the future, thanks.

I've sent out v2 of patches 4, 5, 6 and 9.

		Amit

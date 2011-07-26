Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1GZHC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:02:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:13758 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab1GZHCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:02:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,267,1309762800"; 
   d="scan'208";a="31463586"
Subject: Re: [PATCH] mmc: mmc_test: avoid stalled file in debugfs
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
In-Reply-To: <CAJ0pr19UbhitnopWFyh19ADErn9=VQ6Gxank-Ntc1_O4rGBb-g@mail.gmail.com>
References: <095a90240876c249ed33aa36f2543b54a0b68fc2.1311340371.git.andriy.shevchenko@linux.intel.com>
	 <CAJ0pr19UbhitnopWFyh19ADErn9=VQ6Gxank-Ntc1_O4rGBb-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: Intel Finland Oy
Date: Tue, 26 Jul 2011 10:01:55 +0300
Message-ID: <1311663715.3903.21.camel@smile>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 00:15 +0200, Per Forlin wrote: 
> > +               file = debugfs_create_file(name, mode, card->debugfs_root,card,
> > +                       fops);
> Move card to next line together with fops and indent.
> +               file = debugfs_create_file(name, mode, card->debugfs_root,
> +                                                    card, fops);
Hmm... Its length is exact 80 symbols which is OK for checkpatch.pl.
Anyway, thanks for review.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

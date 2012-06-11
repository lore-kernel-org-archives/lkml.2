Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2FKLVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:21:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:25121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab2FKLVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:21:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164103376"
Date: Mon, 11 Jun 2012 19:21:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: writeback: bad unlock balance detected in 3.5-rc1
Message-ID: <20120611112108.GA21554@localhost>
References: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
 <20120608150736.GF21080@quack.suse.cz>
 <20120608154535.GA887@localhost>
 <1339413676.2401.5.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339413676.2401.5.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 02:21:16PM +0300, Artem Bityutskiy wrote:
> On Sat, 2012-06-09 at 00:45 +0900, Fengguang Wu wrote:
> > I'm yet to setup and run xfstests regularly, so as to catch such kind
> > of problems earlier in future.
> 
> You definitely need to do this before merging anything upstream. I'd
> recommend to use test at least with ext4 and xfs. Probably btrfs, but I
> never tested it with xfstests.

Sure! I'll try to test all of them.

Thanks,
Fengguang

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab2KFBEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 20:04:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:32454 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab2KFBEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 20:04:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,719,1344236400"; 
   d="scan'208";a="215582483"
Date: Tue, 6 Nov 2012 08:48:00 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [floppy, blk_peek_request] BUG: scheduling while atomic:
 kworker/u:0/6/0x10000002
Message-ID: <20121106004800.GA28248@localhost>
References: <20121105070106.GA17015@localhost>
 <alpine.LNX.2.00.1211051422500.24253@pobox.suse.cz>
 <alpine.LNX.2.00.1211051433180.24253@pobox.suse.cz>
 <20121105152706.GA3200@herton-Z68MA-D2H-B3>
 <alpine.LNX.2.00.1211051632460.24253@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1211051632460.24253@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fengguang, could you please test with the patch below instead? (it should 
> be functionally equivalent in most of the cases though).

It works, thanks!

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

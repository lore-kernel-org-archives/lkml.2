Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2IYMvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:51:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57016 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2IYMvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:51:09 -0400
Message-ID: <5061A89A.4050207@kernel.dk>
Date: Tue, 25 Sep 2012 14:50:34 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] block: export trace_block_unplug
References: <20120925095755.048903e8@notabene.brown>
In-Reply-To: <20120925095755.048903e8@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 01:57 AM, NeilBrown wrote:
> 
> Hi Jens,
>  is there any chance this can be in the next merge window?  I'm
> adding block tracing to md and found I need another export.

No problem, applied.

-- 
Jens Axboe


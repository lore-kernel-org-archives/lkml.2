Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2DYCKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:10:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:51272 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab2DYCKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:10:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92773143"
Date: Wed, 25 Apr 2012 10:10:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC v2 0/1] Flexible proportions
Message-ID: <20120425021011.GA5600@localhost>
References: <1335285033-7347-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335285033-7347-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

>   So my plan, if people are happy with the new proportion code, would be to
> switch at least bdi writeout proportion to the new code. I can also check
> other users to see whether it would make sense for them to switch. So what
> do people think?

When you get ready with the full patchset, I would be very interested
in watching how it performs in the various JBOD tests :-)

Thanks,
Fengguang

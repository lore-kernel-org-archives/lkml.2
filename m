Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259Ab0JZUrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:47:00 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:28791 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760051Ab0JZUq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:46:59 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.58,242,1286150400"; 
   d="scan'208";a="276180228"
From: Roland Dreier <rdreier@cisco.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Tom Tucker <tom@opengridcomputing.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] drivers/infiniband: Remove unnecessary KERN_<level> uses
References: <cover.1288059486.git.joe@perches.com>
	<a62c334347cbfbaf5c5acb29c2ae7acda84344a0.1288059486.git.joe@perches.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 26 Oct 2010 13:46:34 -0700
In-Reply-To: <a62c334347cbfbaf5c5acb29c2ae7acda84344a0.1288059486.git.joe@perches.com>
	(Joe Perches's message of "Mon, 25 Oct 2010 19:44:22 -0700")
Message-ID: <adad3qwfzrp.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I seemed to already have the amso1100 part, but I picked up the
cxgb3/cxgb4 parts.

 - R.

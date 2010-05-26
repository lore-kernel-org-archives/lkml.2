Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042Ab0EZEVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 00:21:01 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:41611 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0EZEU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 00:20:59 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 May 2010 00:20:58 EDT
Authentication-Results: ams-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,302,1272844800"; 
   d="scan'208";a="7787370"
From: Roland Dreier <rdreier@cisco.com>
To: Julia Lawall <julia@diku.dk>
Cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 10/27] drivers/infiniband/core: Use memdup_user
References: <Pine.LNX.4.64.1005221021030.13021@ask.diku.dk>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 25 May 2010 21:11:04 -0700
In-Reply-To: <Pine.LNX.4.64.1005221021030.13021@ask.diku.dk> (Julia Lawall's
	message of "Sat, 22 May 2010 10:21:27 +0200 (CEST)")
Message-ID: <adahblvxpyf.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

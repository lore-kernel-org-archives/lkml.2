Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0FGPp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 11:45:29 -0400
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:41236 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab0FGPp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 11:45:27 -0400
Authentication-Results: rtp-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJ6wDExAZnwM/2dsb2JhbACeR3GlBpoDhRcEg0o
X-IronPort-AV: E=Sophos;i="4.53,379,1272844800"; 
   d="scan'208";a="118936325"
From: Roland Dreier <rdreier@cisco.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, davem@davemloft.net,
       linux-rdma@vger.kernel.org, sean.hefty@intel.com
Subject: Re: [Patch] infiniband: check local reserved ports
References: <20100603083106.6047.7657.sendpatchset@localhost.localdomain>
	<ada1vcoqde3.fsf@roland-alpha.cisco.com> <4C085C9A.30506@redhat.com>
	<ada1vcmpyvu.fsf@roland-alpha.cisco.com> <4C0CB610.4010305@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 07 Jun 2010 08:45:19 -0700
In-Reply-To: <4C0CB610.4010305@redhat.com> (Cong Wang's message of "Mon, 07
	Jun 2010 17:04:16 +0800")
Message-ID: <adad3w2onhs.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > So this patch looks good for you? :)

Yes, will queue it up, thanks.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

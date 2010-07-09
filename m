Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0GIDrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:47:00 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:46059 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab0GIDq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:46:58 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAs5NkyrR7Ht/2dsb2JhbACgNnGlJppVhSUEg3k
X-IronPort-AV: E=Sophos;i="4.53,562,1272844800"; 
   d="scan'208";a="156056718"
From: Roland Dreier <rdreier@cisco.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-rdma@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: linux-next: build failure after merge of the infiniband tree
References: <20100709110427.c05987cc.sfr@canb.auug.org.au>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 08 Jul 2010 20:46:14 -0700
In-Reply-To: <20100709110427.c05987cc.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Fri, 9 Jul 2010 11:04:27 +1000")
Message-ID: <ada4og9z5a1.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > After merging the infiniband tree, today's linux-next build (x86_64
 > allmodconfig) failed like this:
 > 
 > make[2]: *** No rule to make target `firmware/qlogic/sd7220.fw', needed by `__fw_modbuild'.  Stop.

Sorry, I took the version of the patch that Ralph sent me, instead of
Ben's original patch, and that version dropped the most important part,
namely the actual firmware file.

Should be fixed now.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

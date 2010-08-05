Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435Ab0HEQmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:42:01 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:61687 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab0HEQl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:41:58 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEqGWkyrRN+J/2dsb2JhbACgOXGreJszhToEhCA
X-IronPort-AV: E=Sophos;i="4.55,323,1278288000"; 
   d="scan'208";a="236226441"
From: Roland Dreier <rdreier@cisco.com>
To: Tziporet Koren <tziporet@mellanox.co.il>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma\@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.36
References: <adak4o654x9.fsf@roland-alpha.cisco.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443B50B5FD12@MTLMAIL.mtl.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 05 Aug 2010 09:41:54 -0700
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB443B50B5FD12@MTLMAIL.mtl.com>
	(Tziporet Koren's message of "Thu, 5 Aug 2010 14:19:53 +0300")
Message-ID: <ada7hk557vx.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > In general - none of our new features going to be included and I wish
 > to understand the reason behind it (I hope it's not personal :-)

It's not personal -- it was a combination of when things were ready and
when I had time to work on things, and unfortunately it all lined up so
I wasn't able to get anything big queued up this cycle.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

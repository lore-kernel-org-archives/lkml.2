Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab0FKQCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:02:49 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:53023 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab0FKQCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:02:47 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANb6EUyrR7H+/2dsb2JhbACee3GlVpoDhRgEg0w
X-IronPort-AV: E=Sophos;i="4.53,404,1272844800"; 
   d="scan'208";a="334229602"
From: Roland Dreier <rdreier@cisco.com>
To: Alexander Schmidt <alexs@linux.vnet.ibm.com>
Cc: Linux RDMA <linux-rdma@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>
Subject: Re: [PATCH] ib/ehca: bitmask handling for lock_hcalls
References: <20100610110653.17885a81@alex-laptop>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 11 Jun 2010 09:02:43 -0700
In-Reply-To: <20100610110653.17885a81@alex-laptop> (Alexander Schmidt's
	message of "Thu, 10 Jun 2010 11:06:53 +0200")
Message-ID: <adatyp9y2u4.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is the impact of this problem?  ie is this something we need to fix
for 2.6.35?  I suppose not, since the current code has been there a long time.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

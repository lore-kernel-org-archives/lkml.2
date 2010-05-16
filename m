Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab0EPDFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 23:05:49 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:56563 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab0EPDFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 23:05:47 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,239,1272844800"; 
   d="scan'208";a="530394141"
From: Roland Dreier <rdreier@cisco.com>
To: Julia Lawall <julia@diku.dk>
Cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 31/37] drivers/infiniband/core: Use kmemdup
References: <Pine.LNX.4.64.1005152322190.21345@ask.diku.dk>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 15 May 2010 20:05:43 -0700
In-Reply-To: <Pine.LNX.4.64.1005152322190.21345@ask.diku.dk> (Julia Lawall's
	message of "Sat, 15 May 2010 23:22:38 +0200 (CEST)")
Message-ID: <adazl00o8ag.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looks good, applied, thanks.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

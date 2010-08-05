Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400Ab0HEVZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:25:27 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:37499 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759247Ab0HEVZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:25:25 -0400
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
From: Roland Dreier <rdreier@cisco.com>
To: Julia Lawall <julia@diku.dk>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/9] drivers/infiniband/hw/ehca: Drop unnecessary null test
References: <Pine.LNX.4.64.1008032335190.20393@ask.diku.dk>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 05 Aug 2010 14:25:21 -0700
In-Reply-To: <Pine.LNX.4.64.1008032335190.20393@ask.diku.dk> (Julia Lawall's
	message of "Tue, 3 Aug 2010 23:35:36 +0200 (CEST)")
Message-ID: <adaaap04uri.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

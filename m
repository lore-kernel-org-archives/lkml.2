Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2HSNEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 09:04:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:1213 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538Ab2HSNEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 09:04:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,794,1336374000"; 
   d="scan'208";a="205400973"
Date: Sun, 19 Aug 2012 21:04:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: IPv4 BUG: held lock freed!
Message-ID: <20120819130441.GA22845@localhost>
References: <20120818021918.GA6499@localhost>
 <1345380682.5158.201.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345380682.5158.201.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you test following patch ?

Yes, sure. Thanks for the quick fix!  I should have reported it earlier
(so as to get it fixed earlier) once find the bisect will be time consuming..

Please be patient -- it will take 1-2 days to confirm the bug fix.

Thanks,
Fengguang

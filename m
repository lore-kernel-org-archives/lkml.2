Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929Ab0I2EA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 00:00:56 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:54529 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0I2EAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 00:00:55 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Sep 2010 00:00:55 EDT
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.57,251,1283731200"; 
   d="scan'208";a="240565550"
From: Roland Dreier <rdreier@cisco.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Tom Tucker <tom@opengridcomputing.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] drivers/infiniband: Remove pr_<level> uses of KERN_<level>
References: <cover.1284267142.git.joe@perches.com>
	<6dddde24a319352fbece72450b35eb5d2176f292.1284267142.git.joe@perches.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 28 Sep 2010 20:51:28 -0700
In-Reply-To: <6dddde24a319352fbece72450b35eb5d2176f292.1284267142.git.joe@perches.com>
	(Joe Perches's message of "Sat, 11 Sep 2010 22:10:55 -0700")
Message-ID: <adahbh9437j.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.

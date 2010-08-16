Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab0HPHGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:06:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:30276 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab0HPHGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:06:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,375,1278313200"; 
   d="scan'208";a="312874838"
Date: Mon, 16 Aug 2010 15:06:26 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: rjw@sisk.pl, Trond.Myklebust@netapp.com
Subject: nfs regression 2.6.35+
Message-ID: <20100816070626.GA10503@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NFS client runs latest git. At client side, use vim to edit a file located at
NFS server. If I save the file, vim always reports 'E667: Fsync failed'. If I
revert f7fa16506bf9b6323e862a61e14c20555152bb3, vim works. No kernel errors
reported.

Thanks,
Shaohua

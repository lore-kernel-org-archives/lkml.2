Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab1IOKDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:03:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:1092 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab1IOKDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:03:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,386,1312182000"; 
   d="scan'208";a="51703246"
Date: Thu, 15 Sep 2011 12:06:26 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Temporary MFD tree location
Message-ID: <20110915100626.GA32263@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Since kernel.org is still down, I temporarily moved my MFD kernel tree to
infradead.

The URL is:
git://git.infradead.org/users/sameo/mfd-2.6.git

And the branches are identical: master, for-next and for-linus. As with the
kernel.org setup, you'd want to take for-next for your linux-next tree.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

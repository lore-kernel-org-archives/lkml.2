Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab1LEPNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:13:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:11836 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab1LEPNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:13:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,299,1320652800"; 
   d="scan'208";a="98730226"
Subject: staging: remove intel_sst
From: Vinod Koul <vinod.koul@intel.com>
To: gregkh <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 20:42:08 +0530
Message-ID: <1323097928.30390.132.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,

I have fixed up the asoc driver code now and there shouldn't be any
issues when we remove the staging driver.

After your removal I will start adding the sst driver patches to asoc.
Would need to strip it of all ioctl code handling as it is not required
now

-- 
~Vinod


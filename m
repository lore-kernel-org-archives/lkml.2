Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0LCUDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 15:03:19 -0500
Received: from mx2.compro.net ([12.186.155.4]:11807 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab0LCUDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 15:03:18 -0500
X-Greylist: delayed 854 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Dec 2010 15:03:18 EST
X-IronPort-AV: E=Sophos;i="4.59,294,1288584000"; 
   d="scan'208";a="6081046"
Message-ID: <4CF949AF.1000502@compro.net>
Date: Fri, 03 Dec 2010 14:49:03 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel tree "diff -urN" anomaly?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I start with two clean identical 2.6.36.1 kernel trees (different names
of coarse). I build one of them. I then do a "make clean mrproper" in
the tree I built. Why then does the diff command in the subject line
find the following files changed?

drivers/gpu/drm/radeon/evergreen_reg_safe.h
drivers/gpu/drm/radeon/r100_reg_safe.h
drivers/gpu/drm/radeon/r200_reg_safe.h
drivers/gpu/drm/radeon/r300_reg_safe.h
divers/gpu/drm/radeon/r420_reg_safe.h
drivers/gpu/drm/radeon/r600_reg_safe.h
drivers/gpu/drm/radeon/rn50_reg_safe.h
drivers/gpu/drm/radeon/rs600_reg_safe.h
drivers/gpu/drm/radeon/rv515_reg_safe.h

Thanks
Mark

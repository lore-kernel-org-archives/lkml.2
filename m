Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab1DSTm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 15:42:26 -0400
Received: from gherkin.frus.com ([192.158.254.49]:59618 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab1DSTmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 15:42:25 -0400
Date: Tue, 19 Apr 2011 14:42:22 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Cc: linux-alpha@vger.kernel.org
Subject: [BUG] DMA_ERROR_CODE undefined in radeon_gart.c
Message-ID: <20110419194222.GA23953@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempted to build 2.6.39-rc4 on an Alpha and got the following error:

  CC [M]  drivers/gpu/drm/radeon/radeon_gart.o
drivers/gpu/drm/radeon/radeon_gart.c: In function 'radeon_gart_bind':
drivers/gpu/drm/radeon/radeon_gart.c:186: error: 'DMA_ERROR_CODE' undeclared (first use in this function)
drivers/gpu/drm/radeon/radeon_gart.c:186: error: (Each undeclared identifier is reported only once
drivers/gpu/drm/radeon/radeon_gart.c:186: error: for each function it appears in.)
make[4]: *** [drivers/gpu/drm/radeon/radeon_gart.o] Error 1
make[3]: *** [drivers/gpu/drm/radeon] Error 2
make[2]: *** [drivers/gpu/drm] Error 2
make[1]: *** [drivers/gpu] Error 2
make: *** [drivers] Error 2

It appears that "DMA_ERROR_CODE" is currently defined for several
architectures in "arch/*/include/asm/dma-mapping.h", but not for "alpha".

-- 
------------------------------------------------------------------------
Bob Tracy          |  "Every normal man must be tempted at times to spit
rct@frus.com       |   upon his hands, hoist the black flag, and begin
                   |   slitting throats."	-- H.L. Mencken
------------------------------------------------------------------------

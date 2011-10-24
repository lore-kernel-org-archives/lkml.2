Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1JXJBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:01:12 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:36727 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab1JXJBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:01:11 -0400
X-Greylist: delayed 1186 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Oct 2011 05:01:10 EDT
Date: Mon, 24 Oct 2011 11:41:21 +0300 (EEST)
From: Meelis Roos <mroos@ut.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>
cc: Francisco Jerez <currojerez@riseup.net>, Dave Airlie <airlied@redhat.com>
Subject: Re: nouveau KMS fails with Vanta TNT2-M64
In-Reply-To: <alpine.SOC.1.00.1110241019510.16192@math.ut.ee>
Message-ID: <alpine.SOC.1.00.1110241124520.16192@math.ut.ee>
References: <alpine.SOC.1.00.1110241019510.16192@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> got an old Nvidia card, Vanta/TNT2-M64. Without KMS, text console and X 
> work fine. With modeset=1, KMS logs a lot of errors and X screen is 
> garbled (mostly understabdable but vertical bands of compressed double 
> image and some horizontal distortions - sorry, no camera here with me 
> today). Some other nvidia and radeon cards work fine in this computer.

Sorry for bad report - it actually produces no image at all on screen 
after KMS has been initialized. Otherwise the machine remains usable.

The garbled screen was another card with radeon driver - will 
investigate some before reporting that one.

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/

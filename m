Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab2BMKWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 05:22:06 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:46424 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab2BMKWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 05:22:05 -0500
X-Greylist: delayed 1806 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Feb 2012 05:22:05 EST
Date: Mon, 13 Feb 2012 11:51:56 +0200 (EET)
From: Meelis Roos <mroos@ut.ee>
To: Grant Likely <grant.likely@secretlab.ca>
cc: Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <alpine.SOC.1.00.1202131145590.1488@math.ut.ee>
Message-ID: <alpine.SOC.1.00.1202131151330.1488@math.ut.ee>
References: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee> <20120213080618.GA11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202131145590.1488@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another variation of the crash, without the patch, but backtrace is 
> slightly different (strlen) - maybe fixed by the patch, maybe not.

This variation means it's from a different machine - sorry to be 
confusing.

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/

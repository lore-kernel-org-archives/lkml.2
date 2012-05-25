Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab2EYHz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 03:55:29 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:36897 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab2EYHz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 03:55:27 -0400
Date: Fri, 25 May 2012 10:55:24 +0300 (EEST)
From: mroos@linux.ee
To: Dan Williams <dan.j.williams@intel.com>
cc: James Bottomley <jejbbe@hansenpartnership.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, stern@rowland.harvard.edu
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not
 recognized
In-Reply-To: <1337826142.6877.7.camel@dwillia2-mobl>
Message-ID: <alpine.SOC.1.00.1205251053390.17096@math.ut.ee>
References: <alpine.SOC.1.00.1205221200050.9585@math.ut.ee>  <20120522.151217.278388169416093561.davem@davemloft.net>  <alpine.SOC.1.00.1205231945480.12326@math.ut.ee>  <20120523.140451.386112705611304887.davem@davemloft.net> 
 <1337813770.3013.37.camel@dabdike.int.hansenpartnership.com> <1337826142.6877.7.camel@dwillia2-mobl>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ...so it seems scsi_complete_async_scans() should take care to flush sd
> probe actions as well... here is a test patch:

Just finished testing it against 3.4.0-05722-gf936991. Without the 
patch, this version fails to boot and with it, it boots fine. Now going 
to test your 4-patch series.

-- 
Meelis Roos (mroos@linux.ee)

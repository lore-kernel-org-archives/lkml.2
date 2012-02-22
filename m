Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2BVSZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:25:36 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:49084 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab2BVSZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:25:35 -0500
Date: Wed, 22 Feb 2012 20:25:32 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Tejun Heo <tj@kernel.org>
cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>, sam@ravnborg.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <20120222174825.GA32694@google.com>
Message-ID: <alpine.SOC.1.00.1202222025120.20496@math.ut.ee>
References: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee> <20120213080618.GA11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202131119040.1488@math.ut.ee> <20120213214623.GJ11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202162151030.16208@math.ut.ee>
 <alpine.SOC.1.00.1202201109260.467@math.ut.ee> <20120220170603.GC7836@mtj.dyndns.org> <alpine.SOC.1.00.1202210030530.11350@math.ut.ee> <20120221010537.GA15898@dhcp-172-17-108-109.mtv.corp.google.com> <alpine.SOC.1.00.1202220213180.4171@math.ut.ee>
 <20120222174825.GA32694@google.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you please try the following patch?  If it still fails to boot,
> please attach the failing log.  Thank you.

It works on E3500! Will try other machines tomorrow.

-- 
Meelis Roos (mroos@linux.ee)

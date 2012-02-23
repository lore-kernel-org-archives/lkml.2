Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2BWSzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:55:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38903 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2BWSzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:55:13 -0500
Date: Thu, 23 Feb 2012 10:55:03 -0800
From: Tejun Heo <tj@kernel.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>, sam@ravnborg.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
Message-ID: <20120223185503.GI22536@google.com>
References: <alpine.SOC.1.00.1202131119040.1488@math.ut.ee>
 <20120213214623.GJ11077@ponder.secretlab.ca>
 <alpine.SOC.1.00.1202162151030.16208@math.ut.ee>
 <alpine.SOC.1.00.1202201109260.467@math.ut.ee>
 <20120220170603.GC7836@mtj.dyndns.org>
 <alpine.SOC.1.00.1202210030530.11350@math.ut.ee>
 <20120221010537.GA15898@dhcp-172-17-108-109.mtv.corp.google.com>
 <alpine.SOC.1.00.1202220213180.4171@math.ut.ee>
 <20120222174825.GA32694@google.com>
 <alpine.SOC.1.00.1202222025120.20496@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1202222025120.20496@math.ut.ee>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 22, 2012 at 08:25:32PM +0200, Meelis Roos wrote:
> > Can you please try the following patch?  If it still fails to boot,
> > please attach the failing log.  Thank you.
> 
> It works on E3500! Will try other machines tomorrow.

Once confirmed, I'll push the patch through tip.  It just hides the
underlying problem but we should be in no worse shape than before,
it's two line change so reproduing the problem again for proper
diagnosing isn't difficult, and we're getting a bit late in release
cycle already.

Thanks.

-- 
tejun

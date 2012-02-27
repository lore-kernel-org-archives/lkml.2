Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab2B0VZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:25:18 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:48052 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318Ab2B0VZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:25:13 -0500
Date: Mon, 27 Feb 2012 23:25:11 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Tejun Heo <tj@kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <20120227194341.GA1448@merkur.ravnborg.org>
Message-ID: <alpine.SOC.1.00.1202272316280.15067@math.ut.ee>
References: <alpine.SOC.1.00.1202201109260.467@math.ut.ee> <20120220170603.GC7836@mtj.dyndns.org> <alpine.SOC.1.00.1202210030530.11350@math.ut.ee> <20120221010537.GA15898@dhcp-172-17-108-109.mtv.corp.google.com> <alpine.SOC.1.00.1202220213180.4171@math.ut.ee>
 <20120222174825.GA32694@google.com> <alpine.SOC.1.00.1202222025120.20496@math.ut.ee> <20120223185503.GI22536@google.com> <alpine.SOC.1.00.1202241120300.1227@math.ut.ee> <alpine.SOC.1.00.1202271914310.15067@math.ut.ee>
 <20120227194341.GA1448@merkur.ravnborg.org>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you try to give this a quick spin and see if something
> turns up. I you have time it would be good to try on a box
> that worked before and one that was fixed by the patch from Tejun.

Neither of the machines - already working one and "fixed with the 
rounding patch" one emit any prot: messages.

-- 
Meelis Roos (mroos@linux.ee)

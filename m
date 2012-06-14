Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2FNOre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:47:34 -0400
Received: from gw3a.telemetry-investments.com ([38.76.0.51]:32858 "EHLO
	sv3.telemetry-investments.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753835Ab2FNOrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:47:33 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2012 10:47:33 EDT
Date: Thu, 14 Jun 2012 10:41:27 -0400
From: "Andrew J. Schorr" <aschorr@telemetry-investments.com>
To: ShuoX Liu <shuox.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpuidle: move field disable from per-driver to per-cpu
Message-ID: <20120614144127.GA2612@ti119.telemetry-investments.com>
References: <4FD95200.1090701@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD95200.1090701@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 14, 2012 at 10:52:48AM +0800, ShuoX Liu wrote:
> Andrew J.Schorr raises a question. When he changes the disable setting
> on a single CPU, it affects all the other CPUs. Basically, currently,
> the disable field is per-driver instead of per-cpu. All the C states of
> the same driver are shared by all CPU in the same machine.
> 
> Below patch changes field disable to per-cpu, so we could set this
> separately for each cpu.

Thanks.  I have not tested this, but it looks very useful to have the
flexibility to disable certain C states on a subset of the cores.  The current
implementation affecting all cores is much less powerful.

Thanks,
Andrew

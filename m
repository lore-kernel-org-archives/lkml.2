Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154Ab0EKGu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:50:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44826 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab0EKGuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=egTU5y494Nss1U862TNS3RqbmaCwGsYFQomaZ6oxhHpnpFm8isN0mjJmCZ3f33J4sl
         x9ZgDHJH68iOW9tQwdJ9JrmCigCTd2Ci5exERVMpeWfJpaXsN42nEMLAn7YTl4zXr7lW
         CYTIQb3sLjM61Yz4GSv3poqevniKc6yfoXHU8=
Date: Tue, 11 May 2010 08:50:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/9] perf: core, remove hw_perf_event_init
Message-ID: <20100511065019.GB5468@nowhere>
References: <1273483595.15998.56.camel@minggr.sh.intel.com> <1273484430.5605.3334.camel@twins> <1273486670.15998.80.camel@minggr.sh.intel.com> <1273486769.5605.3343.camel@twins> <20100510122728.GB5563@nowhere> <1273496054.5605.3400.camel@twins> <20100510230911.GB5895@nowhere> <1273559935.5605.3418.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273559935.5605.3418.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 08:38:55AM +0200, Peter Zijlstra wrote:
> On Tue, 2010-05-11 at 01:09 +0200, Frederic Weisbecker wrote:
> 
> > Which module do you have in mind that could register a pmu?
> > And I don't understand the problem with pci-hotplug.
> 
> Well, the DRM drivers for one, but basically the trend is for every
> aspect of the machine to include PMUs of some form, this includes bus
> bridges and fancy devices.
> 
> The point about PCI-hotplug is that GPUs live on the PCI bus and once
> they start adding their PMU drivers we need to be able to unplug them.
> 
> Same for when the PCI bridge devices start featuring PMU
> implementations.


Ah ok.

Thanks.


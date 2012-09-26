Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab2IZH4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:56:32 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47703 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab2IZH4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:56:16 -0400
Date: Wed, 26 Sep 2012 09:56:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Subject: Re: [PATCH V2 1/1] perf, Add support for Xeon-Phi PMU
Message-ID: <20120926075610.GB2013@gmail.com>
References: <alpine.DEB.2.02.1209251215340.8741@vincent-weaver-1.um.maine.edu>
 <20120925201831.GB31526@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925201831.GB31526@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> On Tue, Sep 25, 2012 at 12:23:23PM -0400, Vince Weaver wrote:
> > Hello
> > 
> > This is an updated version of the patch.  It uses
> > ARCH_PERFMON_EVENTSEL_INT for the DATA_READ event, with the assumption
> > that x86_pmu_hw_config() is going to set that bit anyway.  This lets
> > the code get through the test for an event being 0 without
> > triggering -ENOENT.
> 
> FWIW, looks good to me, thanks Vince!

Ok, great - I'd suggest a v3 repost with the rename suggested by 
Lawrence applied as well, plus with Cyrill's and Lawrence's 
Acked-by's included. Then this new hw support patch can go into 
the perf tree and if all goes well into the v3.7 kernel.

Thanks,

	Ingo

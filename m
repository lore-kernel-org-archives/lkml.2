Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab2IYUSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 16:18:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58471 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab2IYUSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 16:18:35 -0400
Date: Wed, 26 Sep 2012 00:18:31 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Subject: Re: [PATCH V2 1/1] perf, Add support for Xeon-Phi PMU
Message-ID: <20120925201831.GB31526@moon>
References: <alpine.DEB.2.02.1209251215340.8741@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209251215340.8741@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 12:23:23PM -0400, Vince Weaver wrote:
> Hello
> 
> This is an updated version of the patch.  It uses
> ARCH_PERFMON_EVENTSEL_INT for the DATA_READ event, with the assumption
> that x86_pmu_hw_config() is going to set that bit anyway.  This lets
> the code get through the test for an event being 0 without
> triggering -ENOENT.

FWIW, looks good to me, thanks Vince!

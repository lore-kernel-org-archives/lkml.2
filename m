Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2IYMWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:22:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54029 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2IYMWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:22:34 -0400
Date: Tue, 25 Sep 2012 16:22:29 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: stephane eranian <eranian@googlemail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Subject: Re: [PATCH 1/1] perf, Add support for Xeon-Phi PMU
Message-ID: <20120925122229.GI14490@moon>
References: <alpine.DEB.2.02.1209201253060.27540@vincent-weaver-1.um.maine.edu>
 <1348572758.3881.24.camel@twins>
 <20120925114225.GF14490@moon>
 <1348574486.3881.43.camel@twins>
 <CAMsRxfLUpJu9t1_+N_BLTCdLKNOsbtDfXu8ZmoH1RY5DvonZJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMsRxfLUpJu9t1_+N_BLTCdLKNOsbtDfXu8ZmoH1RY5DvonZJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 02:05:58PM +0200, stephane eranian wrote:
> On Tue, Sep 25, 2012 at 2:01 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2012-09-25 at 15:42 +0400, Cyrill Gorcunov wrote:
> >
> >> Guys, letme re-read this whole mail thread first since I have no clue
> >> what this remapping about ;)
> >
> > x86_setup_perfctr() / set_ext_hw_attr() have special purposed 0 and -1
> > config values to mean -ENOENT and -EINVAL resp.
> >
> > This means neither config value can be a 'real' event. Now it turns out
> > Xeon-Phi has an actual event 0, which is masked by these special case
> > thingies.
> 
> Then how about using -1 or -2 for ENOENT and EINVAL?

-2 can't be a valid p4 config as far as i can tell.

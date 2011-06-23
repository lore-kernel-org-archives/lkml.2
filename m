Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab1FWMHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:07:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41447 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab1FWMHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MSwK63XAXqHg/s6NNiVFU9DtvcZiuP5fVMbVPzaotx8Vko8oj4nrpZnmeknTQNUy5J
         XmQPGVXfe0KV2gSiolvVnTpE4zNli5f6MZoH3SIErJu3BpqQzV5LKYd8BZojWxsVB0G1
         fO7o8q/5YxOtgQeknJ/QKJweqecbHfiBcawUw=
Date: Thu, 23 Jun 2011 16:07:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
Message-ID: <20110623120732.GH10238@sun>
References: <20110622082756.GK21641@sun>
 <20110622092134.GO21641@sun>
 <20110623064835.GB10238@sun>
 <BANLkTikVaOz5DYjKSU-jxVBw_Lw9ihV7BQ@mail.gmail.com>
 <20110623095439.GC10238@sun>
 <20110623110706.GE10238@sun>
 <20110623114055.GV3765@redhat.com>
 <BANLkTikR7j0iZ7SLsfkz=2bpTm2uaO_=5g@mail.gmail.com>
 <20110623115327.GG10238@sun>
 <BANLkTin5sN2FZaQYsnsEkH10OF-GES9MGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin5sN2FZaQYsnsEkH10OF-GES9MGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 02:03:50PM +0200, Stephane Eranian wrote:
...
> >
> No, first level in watchdog.c, the other callback has to be implemented
> from x86_pmu as you had it.
> 
ok, will do

	Cyrill

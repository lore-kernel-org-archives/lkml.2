Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab1INPo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:44:26 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44182 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab1INPoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:44:24 -0400
Date: Wed, 14 Sep 2011 11:44:02 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, a.p.zijlstra@chello.nl,
        mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [PATCH] perf tools: Fix tracing info recording
Message-ID: <20110914154402.GC3866@hmsreliant.think-freely.org>
References: <1314022997-9217-1-git-send-email-jolsa@redhat.com>
 <1314023913.2307.63.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110822145210.GA8694@jolsa.brq.redhat.com>
 <1314028266.2307.93.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110822160713.GA10134@jolsa.brq.redhat.com>
 <20110829132037.GB27261@ghostprotocols.net>
 <20110829134147.GD1918@jolsa.redhat.com>
 <20110829142547.GC27261@ghostprotocols.net>
 <20110914135840.GC2719@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110914135840.GC2719@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -1.9 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 03:58:40PM +0200, Jiri Olsa wrote:
> On Mon, Aug 29, 2011 at 11:25:47AM -0300, Arnaldo Carvalho de Melo wrote:
> 
> SNIP
> 
> > > > 
> > > > Hi Jiri, any news here?
> > > > 
> > > > I just stumbled in this bug while testing Neil's net_dropmonitor script
> > > > :-\
> > > 
> > > well, I was thinking about taking files snapshot, so we dont read them
> > > twice and omit the reading for size.. but it'll be probably bigger
> > > change, I'll try to send out something by the end of the week
> 
> sry, I did not make it and then I was out for vacation..  sending now ;)
> 
> jirka
> 
Thanks Jiri!


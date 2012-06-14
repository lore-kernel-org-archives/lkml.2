Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab2FNKv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:51:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:50539 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab2FNKv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:51:26 -0400
Message-ID: <1339671058.2559.27.camel@twins>
Subject: Re: [PATCH 02/19] perf: Add ability to attach user level registers
 dump to sample
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Date: Thu, 14 Jun 2012 12:50:58 +0200
In-Reply-To: <CABPqkBT54L=CuC_gJF3dnOOn6Tr1adVtedLOgzZQbmpZ5B-szA@mail.gmail.com>
References: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
	 <1339420814-7379-3-git-send-email-jolsa@redhat.com>
	 <CABPqkBRsBegm6gv6agHcGb0Hh1EWCV5gjVnbbwPHh-eOfROCuw@mail.gmail.com>
	 <20120613131240.GB2538@m.brq.redhat.com>
	 <CABPqkBRdVMzocJu_SJbU81wg6Ef=KgbXw-18tb+bZEon79fVDA@mail.gmail.com>
	 <1339594802.8980.44.camel@twins>
	 <CABPqkBRnMW=Zmi+DycUPMcYS9cgs8doKZqSR37e1gU6wQnT+nw@mail.gmail.com>
	 <1339663013.2559.10.camel@twins>
	 <CABPqkBT54L=CuC_gJF3dnOOn6Tr1adVtedLOgzZQbmpZ5B-szA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 12:45 +0200, Stephane Eranian wrote:
> > It would be a tedious endeavour since you'd need to have both output
> > paths available for a good while, but it might be worth it in the long
> > run depending on how painful the current format becomes.
> 
> True. What we don't know however, it how many other tools are out
> there using the kernel API directly. 

Right.. but if you leave the old stuff in for say 2 years and start
emitting a warning on using the old stuff after 1 year.. give or take a
few years we should be able to get the old stuff deprecated and removed.

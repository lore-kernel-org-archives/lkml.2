Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab1GVVBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:01:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38135 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab1GVVBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:01:15 -0400
Date: Fri, 22 Jul 2011 23:01:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf: memory load/store events generalization
Message-ID: <20110722210114.GT8006@one.firstfloor.org>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com> <CABPqkBTznHwX_i=sraOkAkyAdX48fi3zVMa_M+Wdp09WMkQeoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTznHwX_i=sraOkAkyAdX48fi3zVMa_M+Wdp09WMkQeoQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That looks okay as a first approach tool. But what people are most
> often interested in is to see where the misses occur, i.e., you need
> to display load/store addresses somehow, especially for the more

But that's what it already does?  (for loads, stores
are not in there yet) Did you try it?

Or did you mean resolving the addresses? While I agree that would
be useful that's a quite big task and I don't think it should 
be blocked on that.


-Andi

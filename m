Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab1GVVnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:43:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45682 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab1GVVnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:43:06 -0400
Date: Fri, 22 Jul 2011 23:43:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf: memory load/store events generalization
Message-ID: <20110722214305.GU8006@one.firstfloor.org>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com> <CABPqkBTznHwX_i=sraOkAkyAdX48fi3zVMa_M+Wdp09WMkQeoQ@mail.gmail.com> <20110722210114.GT8006@one.firstfloor.org> <CABPqkBQP7VNZBFj2h_TA67rr_QL7oxj1p8CjzG+faBd2m0dQig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBQP7VNZBFj2h_TA67rr_QL7oxj1p8CjzG+faBd2m0dQig@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 02:14:26PM -0700, Stephane Eranian wrote:
> On Fri, Jul 22, 2011 at 2:01 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >> That looks okay as a first approach tool. But what people are most
> >> often interested in is to see where the misses occur, i.e., you need
> >> to display load/store addresses somehow, especially for the more
> >
> > But that's what it already does?  (for loads, stores
> > are not in there yet) Did you try it?
> >
> I meant displaying the load + data addresses.

That's what it does already.

Or did you mean the instructions that caused them?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

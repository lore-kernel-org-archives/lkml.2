Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab2JWNpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:45:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59873 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2JWNpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:45:06 -0400
Date: Tue, 23 Oct 2012 15:45:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 05/34] perf, x86: Report PEBS event in a raw format
Message-ID: <20121023134505.GD16230@one.firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org> <1350602382-12771-6-git-send-email-andi@firstfloor.org> <1350995474.13456.12.camel@twins> <CABPqkBQ4WkVb8cUdrACG8sFH7PDe96devv5_FiRSfDrxFMB8Zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ4WkVb8cUdrACG8sFH7PDe96devv5_FiRSfDrxFMB8Zg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe we can use a similar approach to PERF_SAMPLE_REGS to expose
> the PEBS machine state. We need to add PERF_SAMPLE_IREGS and then
> return interrupt machine registers with regular sampling and the PEBS machine
> registers in precise mode. A while back I wrote a patch to do just this. Once my
> PEBS-LL patch is out, I will get back to it.

But why not just use raw? That's far simpler and works fine and is
already supported by perf script.

-andi

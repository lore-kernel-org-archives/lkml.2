Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab1F3OMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 10:12:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:33955 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1F3OM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:12:28 -0400
Subject: Re: [PATCH 0/4] perf: Intel uncore pmu counting support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CABPqkBRs1nd7KptkVCg5QeG0AJJck=VHAgCpSOJKpOgdDuN-6A@mail.gmail.com>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
	 <CABPqkBRs1nd7KptkVCg5QeG0AJJck=VHAgCpSOJKpOgdDuN-6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Jun 2011 16:10:54 +0200
Message-ID: <1309443054.12449.56.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 14:10 +0200, Stephane Eranian wrote:
> > This series are cut to support uncore pmu counting only.
> > So uncore interrupt handling is not needed.
> >
> You're making the assumption that when counting, you can never construct
> a measurement that will cause a counter to overflow the 39 bits. If not, then
> you need interrupt handling even when counting.
> 

Also, I'm missing the stuff that maps everything to one active cpu in
the uncore mask. IIRC your previous postings had stuff like that.

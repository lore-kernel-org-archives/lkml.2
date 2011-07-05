Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1GEIn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 04:43:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41338 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1GEIn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 04:43:56 -0400
Subject: Re: [PATCH 1/4] perf: Add memory load/store events generic code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110704220123.GJ15637@one.firstfloor.org>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-2-git-send-email-ming.m.lin@intel.com>
	 <1309768420.3282.8.camel@twins> <20110704220123.GJ15637@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Jul 2011 10:43:33 +0200
Message-ID: <1309855413.3282.35.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 00:01 +0200, Andi Kleen wrote:
> > Did anybody check with the other PMUs that have similar features like
> > PowerPC and possibly IA64?
> 
> IA64 has a similar feature I believe, but I'm not aware of anyone
> working on that.

Working on it isn't the important part, the important part is that we
don't make it impossible to implement would someone be willing to work
on it.

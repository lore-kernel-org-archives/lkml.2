Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2F2MtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 08:49:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40220 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab2F2MtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 08:49:13 -0400
Date: Fri, 29 Jun 2012 14:49:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw
 format
Message-ID: <20120629124908.GB32637@gmail.com>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
 <1340899974.28750.66.camel@twins>
 <20120628182030.GR4152@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628182030.GR4152@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> > Not without a useful userspace part. 
> 
> http://permalink.gmane.org/gmane.linux.kernel/1319962
> 
> > Preferably not a script.
> 
> You don't need to prefer it.

Kernel development 101, Chapter 1.:

  " If you want your patches to be applied by the maintainer 
    then you'll have to address the maintainer's review 
    requests. "

Thanks,

	Ingo

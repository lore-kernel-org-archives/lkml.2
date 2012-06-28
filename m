Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab2F1S0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 14:26:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:24432 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2F1S0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 14:26:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161896355"
Date: Thu, 28 Jun 2012 11:26:49 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw
 format
Message-ID: <20120628182649.GS4152@tassilo.jf.intel.com>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
 <1340899974.28750.66.camel@twins>
 <CABPqkBSKQ1r_XvKZX5d59Jx3CJ8WoXsO1JJ4KfSiMng4EbH3tA@mail.gmail.com>
 <1340900356.28750.72.camel@twins>
 <CABPqkBQ6Ot8fQLtMCbAiPFWPhajaGB-HEsYmLYRY8_Xee8sBNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ6Ot8fQLtMCbAiPFWPhajaGB-HEsYmLYRY8_Xee8sBNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My problem with the script approach is that you may end up
> re-inventing a lot of the infrastructure
> already in perf in terms of histograming and sorting. I think scripts

All built into modern scripting languages. Only in C you have to reinvent
it.

> are good for dumping
> the raw data or very simply analysis. Now I recognize that they are
> handy to implement
> mahcine specific decoding of the samples.

The main use case is really custom analysis, so that people can do
whatever custom data mining they want.

But I expect once you get users engaged with a simple interface
you'll get much more. 

But even the existing script is quite useful and gives you
a lot of information. It's also very easy to extend to everyone
knowing SQLite.

Can you do all these things the simple script does?

-Andi

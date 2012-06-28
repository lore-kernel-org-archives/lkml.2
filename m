Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab2F1Q3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:29:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:48407 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab2F1Q3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:29:14 -0400
Message-ID: <1340900942.28750.74.camel@twins>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw
 format
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Date: Thu, 28 Jun 2012 18:29:02 +0200
In-Reply-To: <CABPqkBQ6Ot8fQLtMCbAiPFWPhajaGB-HEsYmLYRY8_Xee8sBNg@mail.gmail.com>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
	 <1340899974.28750.66.camel@twins>
	 <CABPqkBSKQ1r_XvKZX5d59Jx3CJ8WoXsO1JJ4KfSiMng4EbH3tA@mail.gmail.com>
	 <1340900356.28750.72.camel@twins>
	 <CABPqkBQ6Ot8fQLtMCbAiPFWPhajaGB-HEsYmLYRY8_Xee8sBNg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 18:27 +0200, Stephane Eranian wrote:
> 
> My problem with the script approach is that you may end up
> re-inventing a lot of the infrastructure
> already in perf in terms of histograming and sorting. I think scripts
> are good for dumping
> the raw data or very simply analysis. Now I recognize that they are
> handy to implement
> mahcine specific decoding of the samples. 

Yeah, I'm no fan of all that script nonsense either. If its worth doing
its worth doing properly.

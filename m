Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2F2BhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 21:37:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:21367 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929Ab2F2BhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 21:37:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117189195"
Date: Fri, 29 Jun 2012 09:32:53 +0800
From: Feng Tang <feng.tang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw
 format
Message-ID: <20120629093253.3e99ca0e@feng-i7>
In-Reply-To: <1340916697.28750.91.camel@twins>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
	<1340899974.28750.66.camel@twins>
	<20120628182030.GR4152@tassilo.jf.intel.com>
	<1340916697.28750.91.camel@twins>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 22:51:37 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2012-06-28 at 11:20 -0700, Andi Kleen wrote:
> > > Not without a useful userspace part. 
> > 
> > http://permalink.gmane.org/gmane.linux.kernel/1319962
> > 
> > > Preferably not a script.
> > 
> > You don't need to prefer it.
> 
> +# will be very time consuming (about 10+ minutes for 10000 samples) if the
> 
> Muhahaha... I'll wait for something useful.

Yeah, that number scared me too when I first saw it, as the time will make
the script totally useless. Then after migrating to the RAM based database
file, the database handling time could be cut down to 1 second.

I guess the sqlite itself realize the shortcoming too, it also provide a
native way to use in-memory database by specifying ":memory":
	con = sqlite3.connect(":memory:")

Thanks,
Feng

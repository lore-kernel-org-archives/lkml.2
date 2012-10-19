Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab2JSPqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:46:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:17394 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab2JSPqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:46:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,613,1344236400"; 
   d="scan'208";a="237554386"
Date: Fri, 19 Oct 2012 08:46:10 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/2] perf tools: add event modifier to request exclusive
 PMU access
Message-ID: <20121019154610.GX2095@tassilo.jf.intel.com>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
 <1350658326-14715-2-git-send-email-eranian@google.com>
 <1350659619.2768.30.camel@twins>
 <CABPqkBSzwNYHS22xaw2zP0e3QAROSRL0v-K29qxjW1By1iK6pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSzwNYHS22xaw2zP0e3QAROSRL0v-K29qxjW1By1iK6pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's what I thought too, but then I don't understand why it was at
> eight before and not
> seven: One instance of each letter, + a second for pp (precise=2). Or
> am I missing
> something here?

The number is pretty useless imho (it's unlikely to catch any real user error) 
and most likely generates a much longer automata in flex than just a +
So I would drop it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

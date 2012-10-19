Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361Ab2JSQHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:07:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757966Ab2JSQHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:07:40 -0400
Date: Fri, 19 Oct 2012 18:07:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] perf tools: add event modifier to request exclusive
 PMU access
Message-ID: <20121019160724.GE980@krava.brq.redhat.com>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
 <1350658326-14715-2-git-send-email-eranian@google.com>
 <1350659619.2768.30.camel@twins>
 <CABPqkBSzwNYHS22xaw2zP0e3QAROSRL0v-K29qxjW1By1iK6pw@mail.gmail.com>
 <20121019154610.GX2095@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019154610.GX2095@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 08:46:10AM -0700, Andi Kleen wrote:
> > That's what I thought too, but then I don't understand why it was at
> > eight before and not
> > seven: One instance of each letter, + a second for pp (precise=2). Or
> > am I missing
> > something here?
> 
> The number is pretty useless imho (it's unlikely to catch any real user error) 
> and most likely generates a much longer automata in flex than just a +
> So I would drop it.

yep, probably we could do better job with checking the modifier
after parsing (with just + in flex) ... added in my todo ;)

jirka

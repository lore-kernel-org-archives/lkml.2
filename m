Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1KNOMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 09:12:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:35897 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab1KNOMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 09:12:41 -0500
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Date: Mon, 14 Nov 2011 15:12:17 +0100
In-Reply-To: <CABPqkBSyYjM7V8cy--WRBHJ8o9TU9WUD9mGE1E5HntYdm2BHyw@mail.gmail.com>
References: <20111107110149.GA5177@quad>
	 <20111110180308.GD15738@erda.amd.com>
	 <CABPqkBSyYjM7V8cy--WRBHJ8o9TU9WUD9mGE1E5HntYdm2BHyw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321279937.1421.18.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 13:55 +0100, Stephane Eranian wrote:
> I have been talking with co-workers experts in operational research
> about our problem. They all pointed to me to the max flow algorithm from
> Ford-Fulkerson (search for it on Wikipedia). I think it solves the complexity
> and recursion problems. My understanding is that the complexity is also
> more under control. 

How would you apply this algorithm to the problem at hand? I'm probably
missing the obvious thing here, but if we want the flow to be the number
of assigned counter then we end up with nodes being the various
permutations of assignments or so, which isn't helpful since that'd be
n! nodes.



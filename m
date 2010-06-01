Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab0FAV0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:26:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:52724 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab0FAV0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ttaMHwFggvgUYE/F2yG6YU0LunfL/6BAHrlfZblunZbglQuBerpxN2+zlRfQTnodD2
         ZzWsz56kVpnbbaV3QmoBlinGk6GDaGhVuwyW+7r+hOQmppw0+jQFdIldsakHNRESsOh/
         Wly/Bnp9kkNmos0mCAb2iU/2+96/J8Y05u9Tk=
Date: Wed, 2 Jun 2010 01:25:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@google.com>
Subject: Re: [RFC] perf, x86: Segregate PMU workaraunds into
	x86_pmu_quirk_ops structure
Message-ID: <20100601212556.GD14072@lenovo>
References: <20100529182409.GJ5322@lenovo> <1275157990.1645.519.camel@laptop> <20100531164553.GD5489@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531164553.GD5489@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 08:45:53PM +0400, Cyrill Gorcunov wrote:
...
> 
> So I guess plain test may be more-less fine here, hmm?
> 
> 	-- Cyrill
> ---
> perf, x86: Make a second write to performance counter when needed
> 
> On Netburst cpu we need a second write to performance counter to
> be sure it's updated properly.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/cpu/perf_event.c    |   10 ++++++++++
>  arch/x86/kernel/cpu/perf_event_p4.c |    9 +++++++++
>  2 files changed, 19 insertions(+)
> 
...

Ping? Any objections/ideas on this approach?

	-- Cyrill

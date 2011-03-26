Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1CZRHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 13:07:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:58701 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab1CZRHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 13:07:30 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1301157483.2250.366.camel@laptop>
References: <20110324164436.GC1930@jolsa.brq.redhat.com>
	 <1301153868.2250.359.camel@laptop>  <20110326161346.GA18272@redhat.com>
	 <1301157483.2250.366.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 18:09:37 +0100
Message-ID: <1301159377.2250.367.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-26 at 17:38 +0100, Peter Zijlstra wrote:
> let me try and get that test-case running someplace.
> 
OK, so I kicked the thing into shape and have it running for several
minutes now but no fireworks yet.. will let it run longer, but it
doesn't look to readily reproduce on that machine.


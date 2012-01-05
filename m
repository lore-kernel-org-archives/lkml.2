Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab2AEMQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:16:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55347 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026Ab2AEMQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:34 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=QcgJSxWpgi8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=AiASCQQQssdXkmXwB5IA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325765791.12696.41.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 05 Jan 2012 07:16:31 -0500
In-Reply-To: <1325764011.12696.38.camel@gandalf.stny.rr.com>
References: <20111221123624.193898256@goodmis.org>
	 <20120101180949.GA25066@elte.hu> <20120102105856.GA6661@elte.hu>
	 <20120102134856.GA32673@elte.hu>
	 <1325635373.12696.4.camel@gandalf.stny.rr.com>
	 <1325635922.12696.8.camel@gandalf.stny.rr.com>
	 <1325653301.12696.20.camel@gandalf.stny.rr.com>
	 <20120104141107.GA24770@elte.hu>
	 <1325696759.12696.24.camel@gandalf.stny.rr.com>
	 <20120105091916.GA22598@elte.hu>
	 <1325764011.12696.38.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 06:46 -0500, Steven Rostedt wrote:

> When I reverted this, my machine booted. I'm now trying that machine
> again with your allyesconfig.

After reverting that patch, your allyesconfig boots up fine on this
machine. I'll reboot it several more times to see if I can reproduce any
of the lockups you see. If I'm not getting anywhere on this, I'll go and
test the NMI side.

-- Steve



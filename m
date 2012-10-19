Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab2JSRFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:05:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54316 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2JSRFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:05:11 -0400
Date: Fri, 19 Oct 2012 10:05:39 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>, mpjohn@us.ibm.com,
        Ingo Molnar <mingo@kernel.org>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC][PATCH] perf: Add a few generic stalled-cycles events
Message-ID: <20121019170538.GB28183@us.ibm.com>
References: <20121012012839.GA15348@us.ibm.com>
 <20121015155534.GR8285@erda.amd.com>
 <20121016100809.GS8285@erda.amd.com>
 <CABPqkBRd2wfjd1ObCkM+TSSwt7C9WP65dEE9POSyDK1ccvNL8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRd2wfjd1ObCkM+TSSwt7C9WP65dEE9POSyDK1ccvNL8A@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101917-2876-0000-0000-0000012F92C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian [eranian@google.com] wrote:
| So all in all, I think this is not a very good idea. You have to put
| this into the tool or a library that auto-detects the
| host CPU and programs the right set of events.
| 
| We've had that discussion many times. Just reiterating my personal
| opinion on this.

Yes that would work too. One drawback is that the hardware events
will be in the tool, while the software/tracepoint events in the
kernel sysfs representation.

Or is that the reason we want all events in one place (sysfs) ?

Sukadev


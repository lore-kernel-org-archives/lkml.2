Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab0J2Gf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:35:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48748 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab0J2GfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:35:21 -0400
Date: Fri, 29 Oct 2010 08:34:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: David Daney <ddaney@caviumnetworks.com>, rth@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>, rostedt@goodmis.org,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
Message-ID: <20101029063450.GE29463@elte.hu>
References: <cover.1288212485.git.jbaron@redhat.com>
 <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com>
 <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com>
 <20101028141757.GA2875@redhat.com>
 <4CC9C724.3020004@caviumnetworks.com>
 <20101028201112.GA4792@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101028201112.GA4792@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Baron <jbaron@redhat.com> wrote:

> Thus, I'm going to propose a patch, which makes jump label conditional on x86_64 
> for now [...]

No, we dont do 64-bit only features really.

> [...] (adding -maccumulate-outgoing-args to x86 increases the text size, so I'm 
> not proposing adding the flag there).

Please make jump labels configurable instead. (dependent on EMBEDDED)

Also, could you please send the fix to me ASAP? We dont need confirmation and 
re-confirmation and testing, as this thing is crashing on me several times every 
single day ...

I also know that 64-bit never crashed this way, nor did the 32-bit kernel with 
function tracer enabled - so -maccumulate-outgoing-args will likely fix it.

Lets get the ball rolling so we can get it to Linus today ...

Thanks,

	Ingo

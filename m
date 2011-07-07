Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab1GGACl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:02:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54834 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab1GGACk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:02:40 -0400
Message-ID: <4E14F797.8070501@zytor.com>
Date: Wed, 06 Jul 2011 17:02:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v2] trace: Add x86 irq vector entry/exit tracepoints
References: <1304107962-18576-1-git-send-email-vnagarnaik@google.com> <1306877298-31713-1-git-send-email-vnagarnaik@google.com> <20110531235957.GB5256@somewhere.redhat.com> <BANLkTi=YYCXHi5k82Q+sE6+134i97pjjAA@mail.gmail.com> <BANLkTinT6ULRWwHAGYFpQSw-ptQiuzrkPtZuKVZHD8b5mh9hpA@mail.gmail.com> <20110616030200.GC18579@somewhere.redhat.com> <4E14F31B.4080102@zytor.com> <20110706235613.GA21115@somewhere>
In-Reply-To: <20110706235613.GA21115@somewhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2011 04:56 PM, Frederic Weisbecker wrote:
> And even if tracepoints are not supposed to be stable ABI (I actually believe there
> is no absolute answer to that, it depends on the tracepoint and on the context),
> tools are much happier with a common tracepoint interface amongst archs.

What you're suggesting here is an ad hoc ABI.  This is insanely
irresponsible -- ABIs need to be designed, not randomly appeared.

	-hpa

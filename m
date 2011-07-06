Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1GFXnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:43:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45107 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab1GFXnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:43:41 -0400
Message-ID: <4E14F31B.4080102@zytor.com>
Date: Wed, 06 Jul 2011 16:43:23 -0700
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
References: <1304107962-18576-1-git-send-email-vnagarnaik@google.com> <1306877298-31713-1-git-send-email-vnagarnaik@google.com> <20110531235957.GB5256@somewhere.redhat.com> <BANLkTi=YYCXHi5k82Q+sE6+134i97pjjAA@mail.gmail.com> <BANLkTinT6ULRWwHAGYFpQSw-ptQiuzrkPtZuKVZHD8b5mh9hpA@mail.gmail.com> <20110616030200.GC18579@somewhere.redhat.com>
In-Reply-To: <20110616030200.GC18579@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2011 08:02 PM, Frederic Weisbecker wrote:
> 
> If a generic tracepoint can replace one per arch, we all want that instead.
> This is 24 times (24 archs) less maintainance burden.
> 

Are you in effect saying that tracepoints are now a stable ABI?  They
sure as hell haven't been architected, reviewed, or accepted for any
such purpose.

	-hpa

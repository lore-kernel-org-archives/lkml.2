Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab2GaQhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:37:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53505 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab2GaQhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:37:53 -0400
Message-ID: <50180980.90209@linaro.org>
Date: Tue, 31 Jul 2012 09:36:16 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>
Subject: Re: [PATCH 0/2][RFC] Better handling of insane CMOS values
References: <1343716548-38742-1-git-send-email-john.stultz@linaro.org> <CA+5PVA47uHmxYh9V5A8ZTLW5yEpCYpYYe0Q=TRoj4A-9jGH0zA@mail.gmail.com>
In-Reply-To: <CA+5PVA47uHmxYh9V5A8ZTLW5yEpCYpYYe0Q=TRoj4A-9jGH0zA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073116-5112-0000-0000-00000A95B4A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 04:31 AM, Josh Boyer wrote:
>
> These should be CC'd to stable, right?  CAI hit this with a 3.5-rcX
> kernel, and the hrtimer stuff was backported to 3.4 and before I
> thought.
Yes.  But I'm just looking for feedback on the approach for now, this 
isn't for submission yet.

thanks
-john


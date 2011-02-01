Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1BAVbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:31:22 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53988 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab1BAVbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:31:21 -0500
Subject: Re: [patch 24/28] posix-clocks: Splitout compat timex accessors
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134419.772343089@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134419.772343089@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:31:15 -0800
Message-ID: <1296595875.3336.69.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:52 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix-clocks-splitout-compat-timex-accessors.patch)
> From: Richard Cochran <richardcochran@gmail.com>
> 
> Split out the compat timex accessors into separate
> functions. Preparatory patch for a new syscall.
> 
> [ tglx: Split that patch from Richards "posix clocks: Introduce a
>   	syscall for clock tuning.". Keeps the changes strictly
>   	separate ]
> 
> Originally-from: Richard Cochran <richardcochran@gmail.com>
> Cc: John Stultz <john.stultz@linaro.org>
> LKML-Reference: <2d5e2f3e6f388aa1848d40406646aab2e26a906f.1296124770.git.richard.cochran@omicron.at>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: John Stultz <johnstul@us.ibm.com>



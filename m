Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1BAVgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:36:41 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58688 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1BAVgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:36:40 -0500
Subject: Re: [patch 26/28] posix_clocks: Add clock_adjtime for x86
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134419.968905083@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134419.968905083@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:36:35 -0800
Message-ID: <1296596195.3336.74.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:52 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix_clocks-add-clock_adjtime-for-x86.patch)
> This patch adds the clock_adjtime system call to the x86 architecture.
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
> Cc: John Stultz <john.stultz@linaro.org>
> LKML-Reference: <4501cddb99d555624baade4609030ca458dfa3a0.1296124770.git.richard.cochran@omicron.at>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: John Stultz <johnstul@us.ibm.com>



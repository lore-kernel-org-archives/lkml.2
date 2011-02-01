Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1BAVa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:30:26 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:57781 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab1BAVaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:30:25 -0500
Subject: Re: [patch 23/28] ntp: Add ADJ_SETOFFSET mode bit
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134419.679485268@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134419.679485268@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:30:18 -0800
Message-ID: <1296595818.3336.68.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:52 +0000, Thomas Gleixner wrote:
> plain text document attachment (ntp-add-adj_setoffset-mode-bit.patch)
> From: Richard Cochran <richardcochran@gmail.com>
> 
> This patch adds a new mode bit into the timex structure. When set, the bit
> instructs the kernel to add the given time value to the current time.
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
> Cc: John Stultz <john.stultz@linaro.org>
> LKML-Reference: <2f7ed6bce83c23e4b7e4530794f0aa175df31a39.1296124770.git.richard.cochran@omicron.at>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: John Stultz <johnstul@us.ibm.com>



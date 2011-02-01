Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab1BAUcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:32:17 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52599 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1BAUcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:32:16 -0500
Subject: Re: [patch 01/28] time: Correct the *settime* parameters
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134417.545698637@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134417.545698637@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 12:32:02 -0800
Message-ID: <1296592322.3336.18.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:50 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (time-correct-the-settime-parameters.patch)
> Both settimeofday() and clock_settime() promise with a 'const'
> attribute not to alter the arguments passed in. This patch adds the
> missing 'const' attribute into the various kernel functions
> implementing these calls.
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
> Cc: John Stultz <john.stultz@linaro.org>
> LKML-Reference: <681d9f8ba43fea01bae9f6a17a4674194a90353b.1296124770.git.richard.cochran@omicron.at>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


Acked-by: John Stultz <johnstul@us.ibm.com>



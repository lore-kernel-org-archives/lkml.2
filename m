Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab1BAUl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:41:26 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:39888 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1BAUlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:41:25 -0500
Subject: Re: [patch 06/28] posix-timers: Convert clock_nanosleep to
 clockid_to_kclock()
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134418.034175556@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134418.034175556@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 12:41:18 -0800
Message-ID: <1296592878.3336.23.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:51 +0000, Thomas Gleixner wrote:
> plain text document attachment (posix-timers-convert-nanosleep.patch)
> Use the new kclock decoding function in clock_nanosleep and cleanup all
> kclocks which use the default functions.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>

Acked-by: John Stultz <johnstul@us.ibm.com>



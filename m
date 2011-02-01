Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab1BAUcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:32:47 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:37819 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1BAUcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:32:46 -0500
Subject: Re: [patch 02/28] posix-timers: Define nanosleep not supported
 error separate
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134417.643486574@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134417.643486574@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 12:32:38 -0800
Message-ID: <1296592358.3336.19.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:51 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix-clocks-splitout-nanosleep-notsup-error.patch)
> Define the conditional nanosleep not supported error value outside of
> do_posix_clock_nonanosleep(). Preparatory patch for further cleanups. 
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>

Acked-by: John Stultz <johnstul@us.ibm.com>



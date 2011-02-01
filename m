Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1BAVMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:12:00 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45462 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab1BAVL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:11:59 -0500
Subject: Re: [patch 09/28] thread_info: Remove legacy arg0-3 from
 restart_block
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134418.326209775@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134418.326209775@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:11:50 -0800
Message-ID: <1296594710.3336.52.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:51 +0000, Thomas Gleixner wrote:
> plain text document attachment (thread-info-remove-arg0-3.patch)
> posix timers were the last users of the legacy arg0-3 members of
> restart_block. Remove the cruft.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>
> ---

Acked-by: John Stultz <johnstul@us.ibm.com>




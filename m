Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1JYSY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:24:56 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47133 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab1JYSYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:24:55 -0400
Message-ID: <1319566888.17505.18.camel@work-vm>
Subject: Re: [PATCH 1/8] clocksource: Convert tcb_clksrc to use
 clocksource_register_hz/khz
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Nikolaus Voss <n.voss@weinmann.de>, Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 25 Oct 2011 11:21:28 -0700
In-Reply-To: <4ea6fb1d.0b14970a.23e2.ffff8274SMTPIN_ADDED@mx.google.com>
References: <4ea6fb1d.0b14970a.23e2.ffff8274SMTPIN_ADDED@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11102518-5112-0000-0000-00000145B353
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 11:08 -0700, y@kernel.beaverton.ibm.com wrote:
> From: John Stultz <john.stultz@linaro.org>
> 
> Convert tcb_clksrc to use clocksource_register_hz.

Ugh. Apparently I hit "y" at the "Who should the emails appear to be
from?". I blame too many apps recently asking for y/n prompts. :)

The patche's From: is still right, so they should still apply ok, but
I'll resend them later if they don't get merged for 3.2.

thanks
-john




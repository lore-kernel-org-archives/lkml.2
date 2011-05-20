Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934640Ab1ETBLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:11:00 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39042 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379Ab1ETBK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:10:59 -0400
Subject: Re: [patch 2/7] clocksource: Get rid of the hardcoded 5 seconds
 sleep time limit
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1305766655.2915.187.camel@work-vm>
References: <20110518205713.947614271@linutronix.de>
	 <20110518210136.109811585@linutronix.de>
	 <1305766655.2915.187.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 18:10:53 -0700
Message-ID: <1305853853.2915.214.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 17:57 -0700, John Stultz wrote:
> Overall it looks good. I'm doing some NTP testing with the TSC shift
> change to make sure we don't get any odd side effects. I'll let you know
> how those go.

So from overnight testing all looks well.

thanks
-john



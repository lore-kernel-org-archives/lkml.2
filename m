Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab1BJXS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:18:28 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:59905 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297Ab1BJXSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:18:22 -0500
Subject: Re: [PATCH 0/4] RTC: Updates for RTC.
From: John Stultz <john.stultz@linaro.org>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, a.zummo@towertech.it
In-Reply-To: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
References: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 10 Feb 2011 15:18:16 -0800
Message-ID: <1297379896.1865.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-07 at 19:16 -0200, Marcelo Roberto Jimenez wrote:
> The following set of patches are updates to the RTC code to take into account
> the new emulated periodic interrupts using hrtimers.
> 
> [PATCH 1/4] RTC: Include information about UIE and PIE in RTC driver proc.
> [PATCH 2/4] RTC: Remove UIE and PIE information from the sa1100 driver proc.
> [PATCH 3/4] RTC: Fix the cross interrupt issue on rtc-test.
> [PATCH 4/4] RTC: sa1100: Update the sa1100 RTC driver.

The first one worries me a little bit (see earlier reply), but the
others look ok to me. The last one collided with my RTC tree, but I
think I've fixed it up. You can find the tree here:

git://git.linaro.org/people/jstultz/linux.git dev/rtc-cleanups

Would you mind testing that branch and letting me know if anything
breaks for you?

thanks
-john


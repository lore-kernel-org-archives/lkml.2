Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab1EWT6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:58:53 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51477 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab1EWT6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:58:52 -0400
Subject: Re: [PATCH V15 0/4] ptp: IEEE 1588 hardware clock support
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110520045822.GA2970@riccoc20.at.omicron.at>
References: <cover.1303466102.git.richard.cochran@omicron.at>
	 <20110520045822.GA2970@riccoc20.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 12:58:25 -0700
Message-ID: <1306180705.2968.13.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 06:58 +0200, Richard Cochran wrote:
> John and Thomas,
> 
> It would be great to have this included in 2.6.40. Is there anything I
> can do to help make it happen?

Hey Richard,
	Sorry for the confusion here. I thought Thomas had already queued
these, but I think I'm mixing up your previous patch set.

I'll queue the v15 (is that still current?) and get them reviewed and
see if Thomas might pull them in. We're cutting it awfully close (short
merge window this time), so no promises if it will make it.

As an FYI: Its usually good to make sure patches are queued into the
maintainer tree at the latest by -rc6/7 is released in order to make the
merge window. I see your mails from 4/22, but since then its been
somewhat quiet. Frequent nagings are sometimes required. :)

thanks
-john





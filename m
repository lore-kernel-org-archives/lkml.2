Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1BBIRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 03:17:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61384 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1BBIRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 03:17:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=okZ8KwcMM4dTDajE3Dm0eJlIFmGsAnAQkDO2GXLUY1b4BiWCWr0UD1fbcvyppEhsO9
         Xu2l4Uor1F07AqN6vihzhGjXth1lPh9LtmIRkHv7PNY4iOntzNLVhxj8wcxhLGBWZq7x
         ktISSkfdCfT7tWbdIijBWnKgTZScTJ3t/n9N0=
Date: Wed, 2 Feb 2011 09:17:06 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 00/28]  Rework of the PTP support series core code
Message-ID: <20110202081706.GB2747@riccoc20.at.omicron.at>
References: <20110201134320.688829863@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201134320.688829863@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 01:50:55PM -0000, Thomas Gleixner wrote:
> The reason for this rework is that I got scared when reviewing:
>  [PATCH V10 09/15] posix clocks: cleanup the CLOCK_DISPTACH macro

I am glad that you are taking the blame/credit ;)

> The patch is really too large and the risk of wreckage too high. So
> instead of whipping Richard through another round I reworked the
> series in the following way:
> 
> 1) Split the CLOCK_DISPATCH cleanup in fine grained steps.

I didn't test or compile each of the little steps, but I have looked
the differences between where I landed with my V10 and this series.

>    That allowed further cleanups and got rid of 200 lines of code and
>    made a lot of functions static.

Yes, it looks even nicer than before, but I'll comment on a few small
points.

> Richard, can you please run that through your testing ? The PTP
> drivers apply on top of that.

I'll run my PTP tests today.

Thanks,
Richard

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab1EXGdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:33:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60366 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1EXGdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:33:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i1ws7AJNoXwT5+v/Tba+Nrrv2QnxyiCEr0izwwOtSqG1r/+2gSCktXIYtOVZDuiiuP
         Rdd4lzWUlzLZI8dpSUcWLwAJ28St0RK2hyYa2qPAAF27FL0GtJSyY0sXArbmtqu6K43V
         f2ny3s9FopNhE/9cFMet0R3qwJ9dcOutiNc+U=
Date: Tue, 24 May 2011 08:33:32 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V15 0/4] ptp: IEEE 1588 hardware clock support
Message-ID: <20110524063332.GB3822@riccoc20.at.omicron.at>
References: <cover.1303466102.git.richard.cochran@omicron.at>
 <20110520045822.GA2970@riccoc20.at.omicron.at>
 <1306180705.2968.13.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306180705.2968.13.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 12:58:25PM -0700, John Stultz wrote:
> I'll queue the v15 (is that still current?) and get them reviewed and
> see if Thomas might pull them in. We're cutting it awfully close (short
> merge window this time), so no promises if it will make it.

Yes, V15 is still current.
 
> As an FYI: Its usually good to make sure patches are queued into the
> maintainer tree at the latest by -rc6/7 is released in order to make the
> merge window. I see your mails from 4/22, but since then its been
> somewhat quiet. Frequent nagings are sometimes required. :)

Okay, I'm good at that.

Thanks,

Richard

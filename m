Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab1ADIhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:37:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54183 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1ADIhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:37:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E4r0rc1zD6B+GmzjoKXAcqabyynHfSJp1LWHy5rSxFiUyTLyzx92+CoAl1cIRdA0/C
         HWEjFi4Z5QFmUy3v6pD0rHx9rY+iU7mC3x4cdLXp/+2C45mkoG6ud8tfSHKfuymFk62X
         eDYFhkowvz236LnGTwcQDj9+KT1Lju9ivc0+Y=
Date: Tue, 4 Jan 2011 09:37:33 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richard.cochran@omicron.at>
Subject: Re: [PATCH 2/3] ntp: add ADJ_SETOFFSET mode bit
Message-ID: <20110104083733.GA4563@riccoc20.at.omicron.at>
References: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
 <1293493244-17583-3-git-send-email-john.stultz@linaro.org>
 <AANLkTi=LqkC-tKzbb6y=iL0UvFYcfcHSuX=jVVFCk1uR@mail.gmail.com>
 <1294087466.2571.89.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294087466.2571.89.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 12:44:26PM -0800, John Stultz wrote:
> On Wed, 2010-12-29 at 05:47 +0900, Kuwahara,T. wrote:
> > I came up with this simple solution: "Just use ADJ_OFFSET as usual,
> > but don't forget to disable the kernel PLL."
> 
> Again, this seems to be trying to add new functionality into a corner
> case of a existing mode.
> 
> I don't like this because it makes testing and validating that the code
> is correct for its uses difficult. Especially given that a number of
> combinations of modes might be set at once. What happens to freq
> adjustments done at the same time as an ADJ_OFFSET - STA_PLL?

Where are the mode bits and their combinations documented, anyhow?

There are lot of papers on NTP, and I have not read them all, but I
don't recall having seen a precise and succinct decription of the
ntp_adjtime interface anywhere.

Thanks,
Richard

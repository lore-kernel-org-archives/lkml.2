Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab0GNRhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 13:37:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58197 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab0GNRhg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 13:37:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kdn3qwDCZISmo/LQzwofnHAEjuliAEz2AV8vmzmdVR8SJe30ZHv8lV+EC3hOg1Xr/I
         qq34xP/7io1JDHVbWgc41AuEiLEFGx99e/UjxiD8Mp7UgeQ1gv7hBxtSLdYILwmQ+pAV
         zYGKD6T38Pt5B6iph/Qj0fKafGjjTQfYbxa+I=
MIME-Version: 1.0
In-Reply-To: <20100714132046.GA18343@pengutronix.de>
References: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<201007121605.32462.davidb@codeaurora.org>
	<AANLkTimho3rcoCZZ2PlC3B3KIZZhsEiTnTk-__n1q_Dy@mail.gmail.com>
	<201007121634.04427.davidb@codeaurora.org>
	<20100714132046.GA18343@pengutronix.de>
Date: Wed, 14 Jul 2010 10:37:07 -0700
Message-ID: <AANLkTinMZw7ZuUpNPePwIRgkYCwFuxbk-xiuDm7HHBwF@mail.gmail.com>
Subject: Re: ARM defconfig files
From: Tony Luck <tony.luck@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: David Brown <davidb@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/14 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Note that no kernel is built at all, only the config is regenerated once
> for each line.

You could special case blank lines and comments (other than ones
like "# CONFIG_FOO is not set" which do matter).  They account for
~15% of the lines in my .config files.  But it probably doesn't matter
all that much. I just ran reduce_defconfig in parallel on all the ia64
defconfig files (in separate build trees) and they were all done when
I looked back an hour or so later.  Nice tool!

-Tony

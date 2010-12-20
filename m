Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab0LTPjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:39:31 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:43095 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757180Ab0LTPja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:39:30 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 20 Dec 2010 16:37:44 +0100
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jean Delvare <khali@linux-fr.org>,
        Mikael =?iso-8859-1?Q?Str=F6m?= <mikael@sesamiq.com>,
        Julien BLACHE <jb@jblache.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH 1/2 V3] applesmc: Use PnP rather than
 hardcoding resources and devices
Message-ID: <20101220153744.GA20068@polaris.bitmath.org>
References: <20101218110954.7a2ca190@endymion.delvare>
 <20101218103139.GA1668@polaris.bitmath.org>
 <878vzngvyn.fsf@sonic.technologeek.org>
 <20101218115742.GA2063@polaris.bitmath.org>
 <1292852674.2118.10.camel@mike-laptop>
 <20101220145721.4c58ff3e@endymion.delvare>
 <20101220142344.GA19566@polaris.bitmath.org>
 <20101220142815.GA23998@srcf.ucam.org>
 <20101220150648.GA19922@polaris.bitmath.org>
 <20101220151258.GA25008@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220151258.GA25008@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PUho4-0005MF-C4.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PUho4-0005MF-C4 daaabdc4d01ab0c397df2f39c401208d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 03:12:58PM +0000, Matthew Garrett wrote:
> On Mon, Dec 20, 2010 at 04:06:48PM +0100, Henrik Rydberg wrote:
> > On Mon, Dec 20, 2010 at 02:28:15PM +0000, Matthew Garrett wrote:
> > > 
> > > There is one, you just need to hook into the thermal device interface.
> > 
> > Right. The fans and the right sensors need to be plugged in, which
> > seems like it should happen at the same time the platform device is
> > removed. Thanks to macfanctld, there might even be enough information
> > regarding what sensors to use. Just about.
> 
> I've been looking into this. The thermal control code under MacOS seems 
> to tie into the GPU and CPU power management as well, and I suspect that 
> this has more to do with the thermal issues we're seeing than the fan 
> control alone.

Yes, I think you are right. To conclude so far, I think it is great
that there is an effort to elevate apple hardware support in general.
I just do not see it happening overnight. If we tread lightly, we
should be able to start off by removing dmi matching and properly
support efi booting, and take it from there.

Thanks,
Henrik

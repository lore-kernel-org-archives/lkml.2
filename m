Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab0LTPNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:13:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41117 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708Ab0LTPNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:13:11 -0500
Date: Mon, 20 Dec 2010 15:12:58 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jean Delvare <khali@linux-fr.org>,
        Mikael =?iso-8859-1?Q?Str=F6m?= <mikael@sesamiq.com>,
        Julien BLACHE <jb@jblache.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH 1/2 V3] applesmc: Use PnP rather than
	hardcoding resources and devices
Message-ID: <20101220151258.GA25008@srcf.ucam.org>
References: <20101218093719.GA1493@polaris.bitmath.org> <20101218110954.7a2ca190@endymion.delvare> <20101218103139.GA1668@polaris.bitmath.org> <878vzngvyn.fsf@sonic.technologeek.org> <20101218115742.GA2063@polaris.bitmath.org> <1292852674.2118.10.camel@mike-laptop> <20101220145721.4c58ff3e@endymion.delvare> <20101220142344.GA19566@polaris.bitmath.org> <20101220142815.GA23998@srcf.ucam.org> <20101220150648.GA19922@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220150648.GA19922@polaris.bitmath.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:06:48PM +0100, Henrik Rydberg wrote:
> On Mon, Dec 20, 2010 at 02:28:15PM +0000, Matthew Garrett wrote:
> > 
> > There is one, you just need to hook into the thermal device interface.
> 
> Right. The fans and the right sensors need to be plugged in, which
> seems like it should happen at the same time the platform device is
> removed. Thanks to macfanctld, there might even be enough information
> regarding what sensors to use. Just about.

I've been looking into this. The thermal control code under MacOS seems 
to tie into the GPU and CPU power management as well, and I suspect that 
this has more to do with the thermal issues we're seeing than the fan 
control alone.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

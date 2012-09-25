Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab2IYLcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:32:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39894 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab2IYLcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:32:31 -0400
Date: Tue, 25 Sep 2012 12:32:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: "Poddar, Sourav" <sourav.poddar@ti.com>, gregkh@linuxfoundation.org,
        khilman@ti.com, paul@pwsan.com, tony@atomide.com,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
	suspended.
Message-ID: <20120925113215.GP31374@n2100.arm.linux.org.uk>
References: <20120925083029.GG31374@n2100.arm.linux.org.uk> <20120925083118.GI9137@arwen.pp.htv.fi> <20120925091228.GI31374@n2100.arm.linux.org.uk> <20120925091112.GK9137@arwen.pp.htv.fi> <20120925092118.GJ31374@n2100.arm.linux.org.uk> <20120925094815.GL9137@arwen.pp.htv.fi> <20120925102958.GL31374@n2100.arm.linux.org.uk> <20120925103652.GN9137@arwen.pp.htv.fi> <20120925110703.GN31374@n2100.arm.linux.org.uk> <20120925111243.GR9137@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925111243.GR9137@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 02:12:43PM +0300, Felipe Balbi wrote:
> I don't see any aggressive attitude towards what you suggested,
> actually. Mailing list archives are available to check, but the one
> cursing around was always yourself and THAT deserves an apology.

Total rubbish.  No apology, because I wasn't cursing you.  Whatever,
I'm not going to re-explain the email thread.

What I said was that your raising of beagleboard breakage (twice) was
idiotic to a request for investigation.  That's a statement I _still_
fully agree with, and I'll say it again if I have to.

Trying to shut down investigation because investigation may break
something _is_ idiotic - especially if the investigation reveals
potential reasons why that breakage would occur.  Further investigation
is precisely how we arrive at better solutions.

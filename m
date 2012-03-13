Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab2CMMro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:47:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58451 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2CMMrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:47:43 -0400
Date: Tue, 13 Mar 2012 12:47:38 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
Cc: rpurdie@rpsys.net, FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added backlight driver for Acer Aspire 4736
Message-ID: <20120313124738.GB10822@srcf.ucam.org>
References: <1331608337.2267.67.camel@debian.Gayathri>
 <20120312175130.GA18002@srcf.ucam.org>
 <1331640592.3485.50.camel@debian.Gayathri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331640592.3485.50.camel@debian.Gayathri>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 08:09:52AM -0400, Pradeep Subrahmanion wrote:
> Before taking this approach , I had a look at the WMI interface.But I found from acer-acpi site that , the 4730 series 
> is using new WMI interface which needs to be reverse engineered.
> As far as  acpi interface is concerned , by default it is not at all causing any change in brightness.
> When 'acpi_osi=Linux' was added to the boot grub config , the brightness control with hot key started to work .
> But it was not changing to correct values. Increasing brightness after maximum level gives blank screen.

That page was last updated in 2009. Have you tried the current acer-wmi 
code? You'd probably need to pass backlight=vendor if there's a 
non-working ACPI interface.

When you say the ACPI interface doesn't work, what do you mean? Have you 
tried using the /sys/class/backlight interface directly?

-- 
Matthew Garrett | mjg59@srcf.ucam.org

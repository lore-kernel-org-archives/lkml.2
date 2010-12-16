Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0LPRAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:00:48 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:55847 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab0LPRAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:00:47 -0500
Date: Thu, 16 Dec 2010 17:00:41 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH 1/2] applesmc: Use PnP rather than hardcoding resources
	and devices
Message-ID: <20101216170041.GA11346@srcf.ucam.org>
References: <1292513589-14651-1-git-send-email-mjg@redhat.com> <4D0A42CE.7030000@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0A42CE.7030000@euromail.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 05:48:14PM +0100, Henrik Rydberg wrote:
> > The AppleSMC device is described in ACPI, including a list of its resources.
> 
> > We should use those rather than hardcoding the ports. A side-effect is that
> > we can then remove the DMI matching, since there's a unique identifier to
> > indicate that the machine has one of these devices.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> 
> Thank you very much for these patches. Unfortunately, they do not quite apply in
> this end. If you could please rebase to linux-next [1], that would be great.

Ah, sorry, I thought I'd pulled the same set of patches. I'll rebase.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

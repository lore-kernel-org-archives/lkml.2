Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2F2C5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 22:57:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52577 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab2F2C5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 22:57:31 -0400
Date: Fri, 29 Jun 2012 03:57:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: joeyli <jlee@suse.com>
Cc: seth.forshee@canonical.com, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>
Subject: Re: [PATCH] backlight: add support for disabling backlights via
 sysfs
Message-ID: <20120629025724.GB18605@srcf.ucam.org>
References: <1340910426-13269-1-git-send-email-seth.forshee@canonical.com>
 <20120628191043.GA9777@srcf.ucam.org>
 <20120628193017.GA29456@thinkpad-t410>
 <20120628193652.GB10945@srcf.ucam.org>
 <20120628211600.GB29456@thinkpad-t410>
 <20120628211936.GA14286@srcf.ucam.org>
 <1340937839.6196.212.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340937839.6196.212.camel@linux-s257.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 10:43:59AM +0800, joeyli wrote:

> 	http://msdn.microsoft.com/en-us/windows/hardware/gg487382.aspx
>
> In WDDM architecture, in spec p.5, there have a "Monitor" driver to
> check the WDDM driver support brightness DDI, if not, then it will use
> standard acpi method to control brightness.

What's the interaction between GPU drivers and platform drivers? For 
instance, on acer systems that have backlight control via WMI, does 
Windows use WMI, the GPU driver or ACPI?
 
-- 
Matthew Garrett | mjg59@srcf.ucam.org

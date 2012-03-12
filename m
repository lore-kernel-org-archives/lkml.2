Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2CLRvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:51:48 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39627 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2CLRvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:51:39 -0400
Date: Mon, 12 Mar 2012 17:51:30 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
Cc: rpurdie@rpsys.net, FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added backlight driver for Acer Aspire 4736
Message-ID: <20120312175130.GA18002@srcf.ucam.org>
References: <1331608337.2267.67.camel@debian.Gayathri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331608337.2267.67.camel@debian.Gayathri>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 11:12:17PM -0400, Pradeep Subrahmanion wrote:
> Hi ,
> 
>   Brightness control was not  working on Acer Aspire 4736 using default ACPI interface.  acer-acpi also do not support 4730 series since it uses new WMI interface.
> This driver adds brightness control by accessing the LBB PCI configuration register. This approach may also work on other laptops in 4730 series .But currently ,  it is only tested  for 
> Aspire 4736. 

1) If there's a WMI interface to brightness control, why not use that?
2) You're hitting a hardware resource that belongs to the i915 driver, 
which may well cause problems.
3) Why does the ACPI interface not work? Can you attach the acpidump 
output?

-- 
Matthew Garrett | mjg59@srcf.ucam.org

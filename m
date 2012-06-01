Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827Ab2FAPBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:01:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59837 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104Ab2FAPBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:01:49 -0400
Date: Fri, 1 Jun 2012 16:01:46 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: linux-next: build rebase of the drivers-x86 tree
Message-ID: <20120601150145.GA8079@srcf.ucam.org>
References: <20120601080404.64da2644d5b26c7101e1e274@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601080404.64da2644d5b26c7101e1e274@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 08:04:04AM +1000, Stephen Rothwell wrote:
> Hi Matthew,
> 
> Looking through the drivers-x86 tree rebase today, I noticed in commit
> 62cce7526629 ("toshiba_acpi: Only register backlight device when
> interface is read/write") that a memset has been added in the wrong place
> - about line 1100 in function toshiba_acpi_setup_backlight().

That was me mis-merging - three commits all touched the backlight code 
and I screwed it up. My fault.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

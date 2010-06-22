Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab0FVSrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 14:47:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34023 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0FVSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 14:47:17 -0400
Date: Tue, 22 Jun 2010 19:47:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Disable ASPM if the platform won't provide _OSC
	control for PCIe
Message-ID: <20100622184707.GA24797@srcf.ucam.org>
References: <1277220343-25168-1-git-send-email-mjg@redhat.com> <201006222017.30023.rjw@sisk.pl> <20100622112908.4122ceb2@virtuousgeek.org> <201006222042.14774.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006222042.14774.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 08:42:14PM +0200, Rafael J. Wysocki wrote:
> I think it's 2.6.35 (and probably -stable) material, these problems aleady
> happen in the field.
> 
> Matthew, what do you think?

I'd lean that way, but it's not a regression and it'll probably only 
trigger if the policy is changed to "powersave" rather than "default".

-- 
Matthew Garrett | mjg59@srcf.ucam.org

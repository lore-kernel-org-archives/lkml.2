Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1I2Bk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 21:40:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43371 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab1I2BkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 21:40:25 -0400
Date: Thu, 29 Sep 2011 02:40:19 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: PME via interrupt or SCI mechanism?
Message-ID: <20110929014019.GA6144@srcf.ucam.org>
References: <20110912171003.GA7939@xanatos>
 <201109272254.47232.rjw@sisk.pl>
 <20110927235216.GA5765@xanatos>
 <201109290021.28407.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109290021.28407.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 12:21:28AM +0200, Rafael J. Wysocki wrote:

> Moreover, evidently, the event is signaled and it causes pci_acpi_wake_dev()
> to be called for multiple devices, _except_ for the xhci_hcd.  Perhaps
> the notifier is not installed for that device for some reason.

I suspect that we're just going to end up accepting defeat and having to 
poll *all* pci devices (including pcie) once a second.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

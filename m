Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1I2JD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:03:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36220 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab1I2JD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:03:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: PME via interrupt or SCI mechanism?
Date: Thu, 29 Sep 2011 11:05:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20110912171003.GA7939@xanatos> <201109290021.28407.rjw@sisk.pl> <20110929014019.GA6144@srcf.ucam.org>
In-Reply-To: <20110929014019.GA6144@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109291105.38342.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 29, 2011, Matthew Garrett wrote:
> On Thu, Sep 29, 2011 at 12:21:28AM +0200, Rafael J. Wysocki wrote:
> 
> > Moreover, evidently, the event is signaled and it causes pci_acpi_wake_dev()
> > to be called for multiple devices, _except_ for the xhci_hcd.  Perhaps
> > the notifier is not installed for that device for some reason.
> 
> I suspect that we're just going to end up accepting defeat and having to 
> poll *all* pci devices (including pcie) once a second.

Well, this case actually looks like a subtle bug in ACPICA.  I think we
need to debug it further before deciding anything.

Thanks,
Rafael

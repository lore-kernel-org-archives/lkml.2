Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1AGG0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 01:26:47 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:33887 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab1AGG0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 01:26:46 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jan 2011 01:26:45 EST
From: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Resend][PATCH] PCI / ACPI: Request _OSC control once for each root bridge (v3)
Date: Fri, 7 Jan 2011 08:14:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31.13-131-pae; KDE/4.4.5; i686; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <201101070055.10065.rjw@sisk.pl>
In-Reply-To: <201101070055.10065.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101070814.15886.ozan@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cuma 07 Ocak 2011 günü (saat 01:55:09) Rafael J. Wysocki şunları yazmıştı:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Move the evaluation of acpi_pci_osc_control_set() (to request control
> of PCI Express native features) into acpi_pci_root_add() to avoid
> calling it many times for the same root complex with the same
> arguments.  Additionally, check if all of the requisite _OSC
> support bits are set before calling acpi_pci_osc_control_set() for
> a given root complex.
> 
> References: https://bugzilla.kernel.org/show_bug.cgi?id=20232
> Reported-by: Ozan Caglayan <ozan@pardus.org.tr>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 
> Hi,
> 
> This fixes a post-2.6.35 regression for Ozan, possibly -stable material.

Tested-by: Ozan Caglayan <ozan@pardus.org.tr>

---
Ozan Çağlayan
TUBITAK/UEKAE - Pardus Linux
http://www.pardus.org.tr/eng

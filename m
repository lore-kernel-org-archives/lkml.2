Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1CRB0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 21:26:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50810 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab1CRB0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 21:26:08 -0400
Date: Fri, 18 Mar 2011 01:25:56 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI/ACPI: Report ASPM support to BIOS if not disabled
	from command line
Message-ID: <20110318012556.GA13851@srcf.ucam.org>
References: <201103051321.51856.rjw@sisk.pl> <4D82B0FC.1060303@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D82B0FC.1060303@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 10:10:20AM +0900, Kenji Kaneshige wrote:
> Jesse,
>
> This patch fixes the problem that PCIe hotplug no longer work in 2.6.38
> on my platform (ASPM is disabled　through ACPI FADT in my platform).
> I think this need to be applied soon.
>
> Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Yes, I think we need to look at -stable for this one.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

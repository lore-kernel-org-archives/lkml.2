Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1CUWey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 18:34:54 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41441 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab1CUWeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:34:50 -0400
Date: Mon, 21 Mar 2011 22:34:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
Subject: Re: Hot plug issue on 2.6.38
Message-ID: <20110321223408.GA17412@srcf.ucam.org>
References: <201103052254.48515.rjw@sisk.pl> <201103170119.17647.rjw@sisk.pl> <AANLkTim39fjrAp4OW_MfpbZkz-YYW5E2NOHuo1j=svmW@mail.gmail.com> <201103172222.33336.rjw@sisk.pl> <20110317215609.GA5917@xanatos> <20110321222705.GA4139@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321222705.GA4139@xanatos>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try setting CONFIG_HOTPLUG_PCI_ACPI to y as well, just to rule that out?

-- 
Matthew Garrett | mjg59@srcf.ucam.org

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2HBQiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:38:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39268 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2HBQh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:37:58 -0400
Date: Thu, 2 Aug 2012 17:37:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 2 (drivers/platform/x86/apple-gmux.c)
Message-ID: <20120802163752.GA29701@srcf.ucam.org>
References: <20120802141505.d30da7f7113e955679383acb@canb.auug.org.au>
 <501AA5A8.1070607@xenotime.net>
 <20120802161504.GG32395@thinkpad-t410>
 <501AA892.70207@xenotime.net>
 <20120802163154.GH32395@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120802163154.GH32395@thinkpad-t410>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 11:31:54AM -0500, Seth Forshee wrote:

> The functions in question are built or not based off of ACPI_VIDEO,
> which in turn depends on ACPI. So if ACPI=n, then ACPI_VIDEO=n and you
> can't configure APPLE_GMUX=(m|y). Is that right, or am I missing
> something?

https://lkml.org/lkml/2012/7/2/257 has 

depends on ACPI_VIDEO=n || ACPI_VIDEO

which means apple_gmux can be built if ACPI_VIDEO is n.
-- 
Matthew Garrett | mjg59@srcf.ucam.org

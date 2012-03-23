Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab2CWPvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 11:51:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872Ab2CWPvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 11:51:10 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: eric.piel@tremplin-utc.net
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via initrd
Date: Fri, 23 Mar 2012 16:51:07 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, hpa@zytor.com
References: <1332512984-79664-1-git-send-email-trenn@suse.de>
In-Reply-To: <1332512984-79664-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201203231651.08143.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, March 23, 2012 03:29:44 PM Thomas Renninger wrote:
> Details can be found in:
> Documentation/acpi/initrd_table_override.txt
...

I should have mentioned that this work depends on ACPICA changes
which have been applied in Len's ACPI next tree only/recently.
For example:
commit f7b004a17c9183f023796dea0d70284684ec000d
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Feb 14 18:31:56 2012 +0800

    ACPICA: Add acpi_os_physical_table_override interface

Thus this patch is intended to get merged through the ACPI
tree.

The patch is (in similar form, before some additional ACPICA
enhancements by Lin and Bob) in productive 12.1 openSUSE kernel.

Thanks,

   Thomas

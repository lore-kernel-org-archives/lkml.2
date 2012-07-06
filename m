Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab2GFLKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:10:06 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55361 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab2GFLKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:10:03 -0400
Date: Fri, 6 Jul 2012 13:09:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 2/8] ACPI, x86: fix Dell M6600 ACPI reboot regression via
 DMI
Message-ID: <20120706110958.GF19552@gmail.com>
References: <9f132652d94c96476b0b0a8caf0c10e96ab10fa8.1341032550.git.len.brown@intel.com>
 <76eb9a30db4bc8fd172f9155247264b5f2686d7b.1341032550.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76eb9a30db4bc8fd172f9155247264b5f2686d7b.1341032550.git.len.brown@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> From: Zhang Rui <rui.zhang@intel.com>
> 
> Dell Precision M6600 is known to require PCI reboot, so add it to
> the reboot blacklist in pci_reboot_dmi_table[].
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=42749
> 
> cc: x86@kernel.org
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  arch/x86/kernel/reboot.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo

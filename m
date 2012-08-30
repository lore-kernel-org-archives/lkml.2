Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179Ab2H3JeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 05:34:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab2H3JeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 05:34:15 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: hpa@zytor.com, initramfs@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI: Override arbitrary ACPI tables via initrd for debugging
Date: Thu, 30 Aug 2012 11:34:11 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.20-desktop; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, robert.moore@intel.com,
        bigeasy@linutronix.de, vojcek@tlen.pl, eric.piel@tremplin-utc.net,
        linux-acpi@vger.kernel.org, yinghai@kernel.org
References: <1346318957-5831-1-git-send-email-trenn@suse.de> <1346318957-5831-3-git-send-email-trenn@suse.de>
In-Reply-To: <1346318957-5831-3-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201208301134.12717.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 30, 2012 11:29:17 AM Thomas Renninger wrote:
> Details can be found in:
> Documentation/acpi/initrd_table_override.txt
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: eric.piel@tremplin-utc.net
> CC: vojcek@tlen.pl
> CC: Lin Ming <ming.m.lin@intel.com>
Lin Ming's address is not valid anymore?:
<ming.m.lin@intel.com>: host mga01.intel.com[192.55.52.88] said: 550 #5.1.0
    Address rejected. (in reply to RCPT TO command)

Please remove it from CC list if you reply on one of these.

Would be great if it can get removed from CC list in the patch
without the need of resending (if the patches are fine).

Thanks,

   Thomas

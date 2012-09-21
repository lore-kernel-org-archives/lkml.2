Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2IUN2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:28:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296Ab2IUN2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:28:19 -0400
From: Thomas Renninger <trenn@suse.de>
To: hpa@zytor.com
Cc: trenn@suse.de, initramfs@vger.kernel.org, robert.moore@intel.com,
        lenb@kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, yinghai@kernel.org,
        eric.piel@tremplin-utc.net
Subject: Early cpio decoder and ACPI table override via initrd making use of it
Date: Fri, 21 Sep 2012 15:28:03 +0200
Message-Id: <1348234085-39220-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should still apply on latest Linux tree, I can resubmit if not.
Would be great if hpa can push this into a x86 branch to get
this into linux-next and into Linus' tree with the next merge
window.

Thanks,

    Thomas

Dmesg output of a quick test:
 FACP ACPI table found in initrd [kernel/firmware/acpi/facp.aml][0xf4]
 DSDT ACPI table found in initrd [kernel/firmware/acpi/dsdt.aml][0x333c]
 e820: modified physical RAM map:
...
   modified: [mem 0x00000000f7fec000-0x00000000f7fef42f] ACPI data
...
 Disabling lock debugging due to kernel taint
 ACPI: Override [FACP-OEMFACP ], this is unsafe: tainting kernel
 ACPI: FACP 00000000f7ff0281 Physical table override, new table: ffffffffff4b7000
 ACPI: FACP 00000000f7fec000 000F4 (v03 A M I  OEMFACP  08000713 INTL 20120518)
 ACPI: Override [DSDT-0AAAA001], this is unsafe: tainting kernel
 ACPI: DSDT 00000000f7ff0410 Physical table override, new table: ffffffffff4b70f4
 ACPI: DSDT 00000000f7fec0f4 0333C (v01  0AAAA 0AAAA001 00000001 INTL 20120518)



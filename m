Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab1KGRh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:37:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50210 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab1KGRhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:37:24 -0500
MIME-Version: 1.0
In-Reply-To: <4EB79E66.9090508@huawei.com>
References: <4EB79E66.9090508@huawei.com>
Date: Mon, 7 Nov 2011 12:37:23 -0500
X-Google-Sender-Auth: B_d5wORfTjv84sUvM2r3oK7lkXI
Message-ID: <CAJvTdKm2y0WaPub9wvpB2NObk26Q57Vxh5sdN+HtYqN66Y4VSQ@mail.gmail.com>
Subject: Re: [PATCH v5] acpi: Fix CPU hot removal problem
From: Len Brown <lenb@kernel.org>
To: "canquan.shen" <shencanquan@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        james.chenjiabo@huawei.com, wuchangyi@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't apply for me, and it looks white-space damaged.
Does it pass checkpatch.pl for you and apply for you?
Possibly an issue with my new gmail setup,
but it looks more like this was damaged at the source.


ERROR: code indent should use tabs where possible
#103: FILE: drivers/acpi/processor_driver.c:668:
+        acpi_bus_hot_remove_device(handle);$

WARNING: please, no spaces at the start of a line
#103: FILE: drivers/acpi/processor_driver.c:668:
+        acpi_bus_hot_remove_device(handle);$

WARNING: please, no spaces at the start of a line
#125: FILE: drivers/acpi/scan.c:132:
+    if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND))$

WARNING: suspect code indent for conditional statements (4, 9)
#125: FILE: drivers/acpi/scan.c:132:
+    if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND))
          printk(KERN_WARNING PREFIX

-- 
Len Brown, Intel Open Source Technology Center

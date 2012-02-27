Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2B0Si6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:38:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:33929 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab2B0Si5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:38:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of william.douglas@intel.com designates 10.52.179.10 as permitted sender) smtp.mail=william.douglas@intel.com
MIME-Version: 1.0
Date: Mon, 27 Feb 2012 10:38:55 -0800
Message-ID: <CABhPDt8M7Tt7Pp3OcEFpg-4OiBq1DS8YNNRjNa-BjtT02mj3Sw@mail.gmail.com>
Subject: [RESUBMIT][PATCH] Don't show error if Acer WMI is not found
From: "Douglas, William" <william.douglas@intel.com>
To: mjg@redhat.com, linux-kernel@vger.kernel.org
Cc: Auke-jan H Kok <auke-jan.h.kok@intel.com>, jlee@novell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 486df5137ae34a4057d604e2b645d7b3848a562f
Author: William Douglas <william.douglas@intel.com>
Date:   Mon Nov 28 11:30:26 2011 -0800

   Don't show error if Acer WMI is not found.

   This patch initiated by Pascal seemed to get left out when switching
   to pr_<level>. I've updated the patch and am resubmitting it as the
   error prints out with the quiet option.

   Signed-off-by: William Douglas <william.douglas@intel.com>
   Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
   Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index b848277..607af16 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1946,7 +1946,7 @@ static int __init acer_wmi_init(void)
               AMW0_find_mailled();

       if (!interface) {
-               pr_err("No or unsupported WMI interface, unable to load\n");
+               pr_info("No or unsupported WMI interface, unable to load\n");
               return -ENODEV;
       }

--
William Douglas, Intel Open Source Technology Center

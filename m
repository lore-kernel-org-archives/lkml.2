Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3ACSgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 13:36:01 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:38478 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab3ACSf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 13:35:58 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 3 Jan 2013 19:35:57 +0100
Message-ID: <CA+icZUWcAuwp4dPStfdgcnZdjhBkEgK54ogGzptfsoL_O5rRxw@mail.gmail.com>
Subject: Re: [RFC,1/2] efi: Make 'efi_enabled' a function to query EFI facilities
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ include/linux/efi.h ]
...
+ * We play games with efi_enabled so that the compiler will, if
+ * possible, remove EFI-related code altogether.
  */
+#define EFI_BOOT		0x00000001 /* Were we booted from EFI? */
+#define EFI_SYSTEM_TABLES	0x00000002 /* Can we use EFI system tables? */
+#define EFI_CONFIG_TABLES	0x00000004 /* Can we use EFI config tables? */
+#define EFI_RUNTIME_SERVICES	0x00000004 /* Can we use runtime services? */
+#define EFI_MEMMAP		0x00000008 /* Can we use EFI memory map? */
+#define EFI_64BIT		0x00000010 /* Is the firmware 64-bit? */
+
...

2x 0x00000004? Typo or intended?

- Sedat -

[1] https://patchwork.kernel.org/patch/1927781/

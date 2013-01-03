Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3ACNAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:00:02 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34410 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3ACM76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:59:58 -0500
MIME-Version: 1.0
Date: Thu, 3 Jan 2013 13:59:58 +0100
Message-ID: <CAHTX3d+bwTNEhzB78mqoz6prk0nw0U_-1YFR3Tje_-uQLyTMBQ@mail.gmail.com>
Subject: uapi __NR_syscalls for microblaze
From: Michal Simek <monstr@monstr.eu>
To: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

just want to check with you if __NR_syscalls is necessary for user
space. I see that powerpc and arm
have this macro in asm not in uapi like Microblaze.
If is not needed by user space, I should move it to asm/unistd.h

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian

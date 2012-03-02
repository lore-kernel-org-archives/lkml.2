Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab2CBNan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 08:30:43 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36255 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab2CBNam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 08:30:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mengsanshui@gmail.com designates 10.229.78.134 as permitted sender) smtp.mail=mengsanshui@gmail.com; dkim=pass header.i=mengsanshui@gmail.com
MIME-Version: 1.0
Date: Fri, 2 Mar 2012 21:30:41 +0800
Message-ID: <CADvmyBfCVh5HA_kTgZ_RdH=HN7oDou70GMj0K0_E2BPcBawa+g@mail.gmail.com>
Subject: Is it possible that implement the SDIO with 1-bit and 4-bit mode
 based on GPIO within kernel ?
From: "peter.meng" <mengsanshui@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I just fond that the kernel implemented the SDIO with SPI mode based
on GPIO , but can't support 1-bit and 4-bit mode .
Is it possible that implement the SDIO with 1-bit and 4-bit mode based
on GPIO within kernel ?
If it yes please give me suggestion how to do it ?


Thank a lot .
Best Regards .
Peter Meng

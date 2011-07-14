Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab1GNQno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:43:44 -0400
Received: from host1743200242118.direcway.com ([174.32.118.242]:37792 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab1GNQnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:43:43 -0400
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: large initramfs causes h/w reset after decompressing
Date: Thu, 14 Jul 2011 09:37:20 -0700
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107140937.20694.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a large initramfs cpio file, about 890 MB, which expands to 2.7 
GB, and am running on linux-2.6.36.1, in 64-bit mode with 8 GB of 
physical RAM.

Upon loading the initramfs, I see the message "Decompressing..." for a 
few seconds, and then comes a reset.

This question has come up before...is there some sort of max size. that 
I am exceeding?  With 8 GB of physical memory and 64-bit arch. 
(AMD-II), certainly seems that there should be enough memory, no?

Thanks...

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0CZWJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:09:55 -0400
Received: from daleenterprise.com ([67.78.11.229]:61532 "EHLO
	daleenterprise.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab0CZWJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:09:54 -0400
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Transfer-Encoding: 7bit
Message-Id: <1EB1D398-8263-47A8-8403-69570DD0E075@macftphttp.serverbox.org>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: websrvr <websrvr@macftphttp.serverbox.org>
Subject: pciregions_read_proc() function results. [corrected]
Date: Fri, 26 Mar 2010 18:09:50 -0400
X-Mailer: Apple Mail (2.752.2)
MTA-Interface: amavisd-new-2.3.3 (2005-08-22) + Maia Mailguard 1.0.1 at daleenterprise.com
X-Spam-Scanned: using SpamAssassin 3.1.7 (2006-10-05) at daleenterprise.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've implemented the pciregions_read_proc code as a debugging tool  
for video cards and I'm not sure if the output is correct I've listed  
the results below, are the results valid (typical of expected values)???

card1: BFG 7300 GS
region 0: mask 0xFF000000, now at 0xA4000000
region 0: type mem, size 16777216 (16mb)
region 1: mask 0xF0000000, now at  0x80000000
region 1: type mem, size 268435456 (256MB)
region 3: mask 0xFF000000, now at 0xA3000000
region 3: type mem, size 16777216 (16MB)

card2: BFG 9400 GT
region 0: mask 0xFF000000, now at 0xA2000000
region 0: type mem, size 16777216 (16MB)
region 1: mask 0xF0000000, now at  0x90000000
region 1: type mem, size 588908 (256MB)
region 3: mask 0xFE000000, now at 0xA0000000
region 3: type mem, size 33554432 (32MB)
region 5: mask 0xFFFFFF80, now at 0x00002000
region 5: type I/O, size 128 (128B)


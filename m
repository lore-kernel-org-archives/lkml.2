Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab2CSCjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 22:39:31 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55095 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab2CSCja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 22:39:30 -0400
MIME-Version: 1.0
Date: Mon, 19 Mar 2012 10:39:29 +0800
Message-ID: <CADvmyBeNXHgknSUJazJY5EVueZHMcqJ7FpVEZT8kkv-bzb+F0w@mail.gmail.com>
Subject: How about the MMC/SDIO host controller standard under Linux ?
From: "peter.meng" <mengsanshui@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI

I see the drivers/mmc/host/sdhci.h define the common register as
describe within
Part_A2_SD_Host_Controller_Simplified_Specification_Ver3.00_Final_110225.pdf
In this case all command related access register is common .(sdhci-xxx.c)
Does this mean all sdhci-xxx.c that will support SD host controller  standard ?


I see most code  such as s3cmci.c ,msm_sdcc.c that has their only
private register that access by such as mmc_host_ops->request function
.
I want to know whether this mean these host controller doesn't support
 SD host controller standard ?



Best Regards .
Peter Meng
mengsanshui@gmail.com

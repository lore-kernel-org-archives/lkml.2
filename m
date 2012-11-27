Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2K0PQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:16:04 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52988 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab2K0PQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:16:01 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>
Subject: 3.6.8: dmar: DRHD: handling fault status reg 602
Date: Tue, 27 Nov 2012 10:16:00 -0500
Message-ID: <00e001cdccb2$1c4dfb10$54e9f130$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac3MshfHaoPAynYAR0CKzZPfsh+VrA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Any idea why this is happening (e.g. why is PTE Read Access not set?)

[   13.204560] dmar: DRHD: handling fault status reg 602
[   13.208078] dmar: DMAR:[DMA Read] Request device [04:00.0] fault addr 0
[   13.208078] DMAR:[fault reason 06] PTE Read access is not set
[   15.777874] dmar: DRHD: handling fault status reg 702
[   15.777879] dmar: DMAR:[DMA Read] Request device [04:00.0] fault addr 0
[   15.777879] DMAR:[fault reason 06] PTE Read access is not set
[   16.100453] dmar: DRHD: handling fault status reg 2
[   16.100458] dmar: DMAR:[DMA Read] Request device [04:00.0] fault addr 0
[   16.100458] DMAR:[fault reason 06] PTE Read access is not set
[   16.141058] dmar: DRHD: handling fault status reg 102
[   16.141062] dmar: DMAR:[DMA Read] Request device [04:00.0] fault addr 0
[   16.141062] DMAR:[fault reason 06] PTE Read access is not set
[   16.210102] dmar: DRHD: handling fault status reg 202
[   16.210111] dmar: DMAR:[DMA Read] Request device [04:00.0] fault addr 0
[   16.210111] DMAR:[fault reason 06] PTE Read access is not set
[   16.918149] ixgbe 0000:86:00.0: eth2: NIC Link is Up 10 Gbps, Flow
Control: RX/TX

This is from:
http://lkml.org/lkml/2012/11/27/263

Justin.


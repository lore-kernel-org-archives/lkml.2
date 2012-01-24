Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2AXLgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:36:13 -0500
Received: from bar.sig21.net ([80.81.252.164]:38764 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab2AXLgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:36:12 -0500
Date: Tue, 24 Jan 2012 12:36:08 +0100
From: Johannes Stezenbach <js@sig21.net>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-3.2.1 + KVM: TSC unstable on Core i5-2400S / H67
Message-ID: <20120124113608.GA16876@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just got the following in dmesg with linux-3.2.1:

[23379.612251] usb 2-1.2: new high-speed USB device number 6 using ehci_hcd
[    0.006666] Marking TSC unstable due to KVM discovered backwards TSC
[23421.511167] Switching to clocksource hpet

The mainboard is an Asus P8H67-V, BIOS 0806 10/26/2011 with Core i5-2400S.
The kvm instance was running for a day already, and there was an overnight
suspend-to-disk cycle in between, but the above happened ~1 hour after resume.
(I don't think the usb message has anything to do with it, it's just
the last message before the TSC message.)

Hm, checking /var/log/kern.* it seems this also happened with
linux-3.1.* without me noticing.

Should I be worried?  I thought Core-i5 processors have a stable TSC?


Johannes

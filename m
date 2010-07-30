Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0G3U7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 16:59:12 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:46207 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0G3U7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 16:59:11 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Feng Tang <feng.tang@intel.com>
Subject: EFI runtime-services on x86_64
Date: Fri, 30 Jul 2010 14:58:48 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007301458.50263.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Feng,

Can you educate me about your commit 772be899bc, "86: Make EFI RTC
function depend on 32bit again"?

It adds "#ifdef CONFIG_X86_32" to avoid using efi_get_time() and
efi_set_rtc_mmss(), but there's no explanation of *why* those services
only work on 32-bit.

Is this an EFI spec limitation?  Do the other EFI runtime services
work on 64-bit, since you didn't touch them?  Or do we just not use
any of the others?

Is this something that can be fixed, so we *could* use efi_get_time()
on 64-bit if we did some work?  What would need to be done?

Bjorn

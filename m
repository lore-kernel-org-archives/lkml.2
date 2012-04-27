Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666Ab2D0IcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:32:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52380 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab2D0IcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:32:05 -0400
MIME-Version: 1.0
Date: Fri, 27 Apr 2012 16:32:05 +0800
Message-ID: <CANuKeP=zodr8kUzqurjrtWQ2EBAw7cL5Xw=MZVdjsN6KKyfb+Q@mail.gmail.com>
Subject: What does Linux need to do for supporting LER(intel's live error
 recovery) ?
From: Lin-Bao Zhang <2004.zhang@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lin-Bao Zhang <2004.zhang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we know Intel has release IV-bridge CPU which has LER feature .
1, I want to know what linux needs to do for supporting LER feature .

2, what's the difference between AER and LER ?

another point: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=a654e5ee4f2213844d23361eda4955fe9efaf35f
aer_recover_queue() is called when recoverable PCIe AER errors are
notified by firmware to do the recovery work.
Signed-off-by: Huang Ying <ying.huang@intel.com

this patch claimed that Linux kernel has supported firmware first
feature and can call correctly original devices' recovery functions .
my question is that :
3, if CPU supports LER feature ,we linux kernel will enhance this patch ?

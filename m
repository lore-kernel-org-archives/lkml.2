Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0IQWyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:54:37 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:8227 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab0IQWyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:54:36 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: linux-kernel@vger.kernel.org
Subject: Testing request: Gigabyte GA-MA69VM-S2 690V regression
Date: Fri, 17 Sep 2010 16:53:52 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009171653.53848.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott reported that 2.6.35.4 hangs on his GA-MA69VM-S2 690V:

   http://lkml.org/lkml/2010/9/9/92

This is a regression, and I'd like to fix it as soon as possible.

I have a patch to fix this, but haven't been able to find someone
who can reproduce the failure and test the patch.

If you have this motherboard, please consider testing a current
upstream kernel on it.  If it fails, please try the test patch from

    https://bugzilla.kernel.org/show_bug.cgi?id=18482

and report your BIOS version and your results.  If it fails even
with the test patch, please boot with "pci=nocrs" and attach the
dmesg log to the bugzilla.

Thanks,
  Bjorn

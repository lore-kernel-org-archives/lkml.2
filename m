Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2HWQhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:37:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab2HWQhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:37:20 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, linux-efi@vger.kernel.org, mfleming@intel.com,
        dwmw2@infradead.org, bhelgaas@google.com
Subject: Use PCI ROMs from EFI boot services 
Date: Thu, 23 Aug 2012 12:36:39 -0400
Message-Id: <1345739803-21017-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V3 just fixes all the casting issues and incorporates David's change in
search ordering.


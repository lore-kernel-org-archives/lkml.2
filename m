Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2GZWDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 18:03:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab2GZWDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 18:03:11 -0400
From: Matthew Garrett <mjg@redhat.com>
To: matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: efi, x86, pci: Improve graphics support on some Apple hardware 
Date: Thu, 26 Jul 2012 18:02:45 -0400
Message-Id: <1343340169-7772-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Apple machines only provide their video ROM via an EFI-specific mechanism
and don't permit it to be retrieved from the BAR. Add infrastructure to stash
it and provide access to drivers.


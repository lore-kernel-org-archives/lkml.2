Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761391Ab2CNSCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:02:30 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:33974 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761133Ab2CNSC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:02:28 -0400
To: linux-scsi@vger.kernel.org, JBottomley@parallels.com,
        akpm@linux-foundation.org
Subject: [PATCH 0/3 v2] SCSI: use pci_dev->revision
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
Date: Wed, 14 Mar 2012 22:01:39 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203142201.39728.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This patchset converts the remaining cases of reading the PCI revision register
directly to using the value already cached by PCI subsystem in the 'revision'
field of 'struct pci_dev'.

The patchset wasn't merged in either 2.6.39, 3.0, 3.1, 3.2, or 3.3 time --
hopefully it can be merged to 3.4 at least...

James B., you seem to consistently ignore this patchset without telling me what
is wrong with it; in all my attempts at submitting it I got no feedback what
so ever (except ACK on patch 3 from Vikas Chaudhary).
Andrew M., as James seem to ignore this patchset, maybe you could queue it?

All the analogous patches to other sybsystems (except these three to the SCSI
subsystem and to the Fusion MPT driver) have been merged long ago, without much
hassle...

MBR, Sergei

PS: I'm beginning to lose hope/temper... :-/

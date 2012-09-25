Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2IYO4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:56:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589Ab2IYO42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:56:28 -0400
From: Thomas Renninger <trenn@suse.de>
To: hpa@zytor.com
Cc: lenb@kernel.org, initramfs@vger.kernel.org, robert.moore@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        yinghai@kernel.org
Subject: [RESEND] Early cpio decoder and ACPI table override via initrd making use of it
Date: Tue, 25 Sep 2012 16:55:55 +0200
Message-Id: <1348584961-1476-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the updated version with following changes as suggested
by Len and Yinghai:
  - spelling corrections
  - macro hiding in header files
  - splitting up patches

There shouldn't be any functional changes since the last version.

I guess the only part missing is a more explicit ack from Len than
"this is not a nak"?
Then this can go into linux-next through a X86 branch pushed by
hpa (as there are quite some x86 specific parts)?

The patches are on top of latest Linus tree.

Thanks,

    Thomas



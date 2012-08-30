Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab2H3J33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 05:29:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab2H3J30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 05:29:26 -0400
From: Thomas Renninger <trenn@suse.de>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, robert.moore@intel.com,
        ming.m.lin@intel.com, initramfs@vger.kernel.org, bigeasy@linutronix.de,
        vojcek@tlen.pl, eric.piel@tremplin-utc.net, linux-acpi@vger.kernel.org,
        yinghai@kernel.org
Subject: Early cpio decoder and ACPI table override via initrd making use of it
Date: Thu, 30 Aug 2012 11:29:15 +0200
Message-Id: <1346318957-5831-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on the early cpio decoder from hpa.
The first patch is exactly the patch (41750d31fc9599fd81763e685) from git repo:
kernel/git/hpa/linux-earlyinitramfs. Ony the Makefile was slightly
adjusted to latest Linus kernel (3.6.0-rc3).

Because of the special requirements hpa mentioned, I gave up the cleaner
callback approach. It may make sense to revive it if there are potential
more users and let the very early code call the cpio decoder directly and
let others use the callback interface I had made up.

Anyway, it would be great to see these two patches showing up in a
mainline branch and linux-next asap, so that they can slip in with the next
(3.7) merge window.

Working on ACPI features or debugging ACPI problems is a nightmare on Linux
currently. ACPI table overrding via initrd makes working on such problems
a lot easier.

   Thomas


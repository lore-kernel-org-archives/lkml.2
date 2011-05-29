Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1E2Qhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 12:37:52 -0400
Received: from vt.electrainfo.com ([207.136.236.70]:55154 "EHLO
	black.electrainfo.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754080Ab1E2Qhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 12:37:51 -0400
X-Greylist: delayed 617 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 May 2011 12:37:50 EDT
Date: Sun, 29 May 2011 12:27:38 -0400
From: Whit Blauvelt <whit@transpect.com>
To: linux-kernel@vger.kernel.org
Subject: recursive fault in 2.6.35.5
Message-ID: <20110529162738.GA7832@black.transpect.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This isn't a most-recent kernel, so we should upgrade the systems with it,
but it could also be useful to know why the fault occurred. If someone here
can easily decode the final messages when the system froze....

This is vanilla 2.6.35.5, built from source, running with Ubuntu Server
10.04.2. Two similar systems have been running stably for months, then
yesterday and today both froze up - one twice. On the one where I was able
to get a remote console before rebooting the final messages are in a screen
capture at

http://www.transpect.com/jpg/sb2crash.jpg

The final lines are

[3521437.065988] RIP  [<ffffffff81054ddc>] set_next_entity+0xc/0xa0
[3521437.065993]  RSP <ffff8801b60b1748>
[3521437.065994] CR2: 0000000000000038
[3521437.065997] ---[ end trace 5a40c5f226029029 ]---
[3521437.065999] Fixing recursive fault but reboot is needed!

These are basically file servers running NFS, samba, and some Python. I know
there are recent improvements to the kernel's NFS functions. Does this point
in that direction as the cause of the recursive fault?

TIA,
Whit

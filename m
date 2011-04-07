Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1DGGkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 02:40:12 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:54527 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1DGGkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 02:40:10 -0400
Date: Thu, 7 Apr 2011 02:40:10 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: linux-kernel@vger.kernel.org
Message-ID: <638226361.789131.1302158410535.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: hibernate/resume regression
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest Linus tree had a regression that prevent hibernate/resume from working.

It is now failing to resume every time tried after hibernate.

PM: Starting manual resume from disk
Freezing user space processes ... 
EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
EXT4-fs (dm-0): write access will be enabled during recovery
EXT4-fs (dm-0): recovery complete
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
(elapsed 0.18 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Loading and decompressing image data (301765 pages) ... done
PM: Read 1207060 kbytes in 6.47 seconds (186.56 MB/s)
serial 00:08: disabled

I have not had a chance to track down the offensive patch(es) yet.

CAI Qian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0IVA7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 20:59:17 -0400
Received: from tomasu.net ([64.85.170.234]:40336 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab0IVA7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 20:59:16 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: linux-kernel@vger.kernel.org
Subject: rsync causing high loads on 2.6.36-rc4
Date: Tue, 21 Sep 2010 18:59:05 -0600
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4; KDE/4.5.1; x86_64; svn-1174823; 2010-09-12)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009211859.05770.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't something I remember happening with older kernels, but I just 
started an rsync from an nfs share over GbE, to a external SATA drive over usb 
2, and I'm seeing both of my laptop's cores hitting 80-100% cpu use, two rsync 
processes are using 20-40% each, some kworker's are using tiny bits (2-10%), 
and kswapd0 is hovering around 5%. Quite a lot of the time seems to be io-
wait. load average is almost at 6.

This is a dual core T9400 core2duo laptop, with 4GB ram, running full amd64 
(64bit 2.6.36-rc4 kernel and userspace).

Its impacting desktop interactivity quite a lot.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca

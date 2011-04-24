Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab1DXCXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 22:23:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35981 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757392Ab1DXCXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 22:23:08 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19XQFJBcb5XmPsxyK2lz0hXdtoFm2BcV0S1JX7R1M
	NKf1GXn2MRkRz0
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: viafb OLPC patches
Date: Sun, 24 Apr 2011 02:39:21 +0000
Message-Id: <1303612763-8852-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains OLPC specific patches. One fixes the 
devices connected as seen by the driver and the other is a further 
refresh rate reduction.
Both are required to prevent regressions of the other patch series 
as we increasingly require the information of the driver to be 
correct which (hopefully only on OLPC) is not the case now.

As usual all patches are also available at
	git://github.com/schandinat/linux-2.6.git viafb-olpc

and will soon show up in linux-next.


Thanks,

Florian Tobias Schandinat


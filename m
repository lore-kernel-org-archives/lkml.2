Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2KEJwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:52:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60190 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab2KEJwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:52:04 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Subject: dmaengine: PL08x: Allow using PL08x with sound drivers
Date: Mon,  5 Nov 2012 10:51:41 +0100
Message-Id: <1352109104-2969-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.7.0.4
X-Provags-ID: V02:K0:qj5BpZqSzixwB2wqTSiafYJo4XKou8zrSmwRKs1JmTW
 kLUYEHR9J1K+h4ba28JBcn3Qm9nK6Kxe/5YHVOEQN9wt03zHUH
 ZwyeUjNxZ80nhKOgA5vkXiFEfcfHGd7pQVO4zxSMZNN9qk70IT
 PQn9SIhmTExkEvynQRq6S+ZJ7xaARhAsfmcv6ZAx0j5OpcIZJN
 vf1QDSIRQzUG5yQX0k3emYc87nb0bmue/uxiMRsqLNKUOc0LLs
 CelMlrKh8T0l6+fjgTAJakpz/XZ37iDhIYqe2cMSQRijTBjxO5
 /MMCQiFQ4zoQF6DIP7ziUnSJ9D4bhH8VwNM3DsFspBcXtqtvRy
 /btMdc4g7Mlk1N8yez193b0Af8kpa+t8DYWF0PZCYvv8G2f2iN
 GtkHC6J16dQP/09zZhrUdDAU9QtgdpGCbWW6vz8uwLxbDYC7ox
 /iuEh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch serie extend the PL08x driver to allow using it with
sound drivers. Sound drivers require the cyclic transfer mode and
that tx_status give reliable results.

* Patch 1 is a trivial fix
* Patch 2 implement the cyclic mode needed by sound drivers
* Patch 3 fix the tx_status implementation to get reliable results


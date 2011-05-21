Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab1EUMMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 08:12:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab1EUMMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 08:12:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Frank Hofmann <frank.hofmann@tomtom.com>
Subject: [PATCH 0/3] Hibernate cleanups
Date: Sat, 21 May 2011 14:08:28 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105211408.28671.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following are three hibernate patches I didn't have the time to
work on before.

[1/3] - Update comments in kernel/power/hibernate.c
[2/3] - Remove arch_prepare_suspend()
[3/3] - Update kerneldoc comments in kernel/power/hibernate.c

Since they don't make any functional changes, I don't think it makes sense
to wait with them for the next merge window, so I'd like to push them
for 2.6.40 if no one objects.

Thanks,
Rafael


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab1AKLz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:55:27 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:60725 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab1AKLzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:55:25 -0500
From: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [2.6.37] Debugging shutdown issues
Date: Tue, 11 Jan 2011 13:50:08 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31.13-131-pae; KDE/4.4.5; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101111350.08448.ozan@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have many reports regarding shutdown hangs and reboots-instead-of-shutdown for 2.6.37 but I
don't really know how to help them in debugging. All they see and say is that the computer
is not powered off instead stays at terminal.

The reboots-instead-of-shutdown bug seems to hit some Sony Vaio and Dell notebooks. There are
similar bug reports and forum entries mentioning about the same problem but none of them contains
valuable information.

Any hint/help/clue will be appreciated
Thanks,

---
Ozan Çağlayan
TUBITAK/UEKAE - Pardus Linux
http://www.pardus.org.tr/eng

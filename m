Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2HNMfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:35:54 -0400
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:60584 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab2HNMfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:35:48 -0400
Message-Id: <502A623C020000A10000BACA@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Tue, 14 Aug 2012 14:35:40 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Q: Seeing the microcode revision in /proc/cpuinfo
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

After several reboots due to memory errors after excellent power-saving of Linux on a HP DL380G7 with Intel Xeon 5650 processors (all in on memory bank), I found out the errate "BD104" and "BD123". The former should be fixed in a microcode revision "15H".

Now I wonder what microcode revision my CPUs currently have. /proc/cpuinfo doesn't show that, and the microcode update is a bit cryptic:

kernel: [   44.422912] microcode: CPU23 sig=0x206c2, pf=0x1, revision=0x14

Does that mean the revision is 0x14 BEFORE or AFTER the microcode update?

Wouldn't you agree that seeing the microcode revision in /proc/cpuinfo would be nice?

For those CPUs lacking the feature one could hard-wire the value "none" (which would be also "kind of true")...

Regards,
Ulrich
(not subscribed, so please CC: you replies to me)



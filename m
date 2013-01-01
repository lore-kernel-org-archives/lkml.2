Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3AAURl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 15:17:41 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:64894 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3AAURk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 15:17:40 -0500
MIME-Version: 1.0
Date: Tue, 1 Jan 2013 18:17:39 -0200
Message-ID: <CA+MoWDp7xr9LMguKYmAVcMm_nnco8Lh5KLhWD9eeZ2tc43iNSQ@mail.gmail.com>
Subject: i7-2620M: Clock always high when on battery
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: rob@landley.net, andre.przywara@amd.com, rjw@sisk.pl,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure if I'm emailing the right people. My problem is with
dynamic clock and or power management.

I'm using 3.6.10-2.fc17.x86_64 but the exact same problem happen with
non Fedora Kernels like 3.7.1 and 3.6.11.

I'm using Toshiba R830-10P notebook with i7-2620M cpu.

The problem is that when I power on the notebook without the AC
adapter the clock of all cores is always very close to 2,7GHz. It was
expected that without load the clock would be around 800 Mhz. This
issue is causing the notebook to get hot and reduces battery life. The
same problem also happens when on AC power but it is uncommon.

What can I do to diagnose the problem and collect more precise details?

Peter

--
Peter

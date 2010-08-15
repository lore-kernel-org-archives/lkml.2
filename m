Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab0HOHV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 03:21:59 -0400
Received: from mail-zbox20.bo3.lycos.com ([209.202.250.20]:36636 "EHLO
	mailbox20.lycos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab0HOHV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 03:21:58 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Aug 2010 03:21:58 EDT
Date: Sun, 15 Aug 2010 03:14:52 -0400 (EDT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Message-ID: <32093497.199921281856492123.JavaMail.root@mail-zbox20.bo3.lycos.com>
In-Reply-To: <26525454.199901281856480444.JavaMail.root@mail-zbox20.bo3.lycos.com>
Subject: Panic on boot or immediate reboot after upgrading from 2.6.35 to
 2.6.35.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [94.51.207.128]
X-Mailer: Zimbra 5.0 (ZimbraWebClient - FF3.0 (Linux)/5.0.18_GA_3028.CentOS5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After I upgraded from 2.6.35 to 2.6.35.2 I can no longer boot into Linux, it immediately crashes or reboots when starting udev (so, one of the modules being loaded triggers this behaviour).

I'm not able to write down the kernel panic messages because they span several screens, so I shot the entire boot sequence on video: http://www.mediafire.com/?lqs56e0dpku9sb4

Mind that I'm running this patch: 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d1d6ca73ef548748e141747e7260798327d6a2c1 because otherwise i915 doesn't work at all.

I reverted all i915 related patches, but then again 2.6.35.2 crashes or reboots, so i915 changes alone aren't responsible for this bug.

Please, CC me when answering, because I'm not subscribed to LKML.

Best wishes,

Artem


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab2IGA1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 20:27:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45954 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab2IGA1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 20:27:45 -0400
From: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: 3.4.10 i915 [GM45] regression
Date: Fri, 07 Sep 2012 02:27:12 +0200
Message-ID: <2372445.fuIXicT4H0@tux200s>
Organization: Andreas Sturmlechner
User-Agent: KMail/4.9.1 (Linux/3.4.10; KDE/4.9.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

please revert commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 - for some 
reason it breaks boot-up (screen stays blank) on my GM45 hardware despite >= 
3.5 being fine.

See bug 54575 on freedesktop.org for a full description: 
https://bugs.freedesktop.org/show_bug.cgi?id=54575

No idea how far-spread or not this might be since I couldn't find any other 
reports of that kind.

Best regards,
Andreas

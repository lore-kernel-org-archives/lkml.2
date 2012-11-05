Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2KEGC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:02:58 -0500
Received: from shadow.lunarbreeze.com ([216.97.239.120]:41691 "EHLO
	shadow.lunarbreeze.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2KEGC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:02:57 -0500
X-Greylist: delayed 1615 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2012 01:02:57 EST
Message-ID: <278dd4935298bb692f9fdac649c8eaad.squirrel@www.simantinee.com>
Date: Sun, 4 Nov 2012 21:35:59 -0800
Subject: kernels from 3.3.x series onwards fail to boot on ARM-based ZEUS
 (XScale PXA270) Single Board Computer
From: sanjeevn@simantinee.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - shadow.lunarbreeze.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - simantinee.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Although the ARM-based Zeus (XScale PXA270) Single board computer works
well for 3.2.x series kernels, it fails to boot from series 3.3.x. It
attempts to boot but stops at:

"Uncompressing Linux... done, booting the kernel".

This problem is also exhibited in kernel series 3.4.x, 3.5.x, 3.6.x.
The kernels are configured with zeus_defconfig and built with
arm-iwmmxt-linux-gnueabi toolchain.

Please CC answers/comments posted.


Thanks & Regards,
Sanjeev N.


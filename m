Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0CQRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 13:25:27 -0400
Received: from tau.jukie.net ([216.239.93.128]:60906 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab0CQRZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 13:25:26 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2010 13:25:26 EDT
Date: Wed, 17 Mar 2010 13:17:35 -0400
From: Bart Trojanowski <bart@jukie.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: v2.6.33.1 staging/rt2870 on arm
Message-ID: <20100317171735.GT12538@jukie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cześć Bartłomiej,

I recently acquired a DLink DWA-125, and found out that the RT2870
driver was only available on x86.  I was curious none the less, and
force compiled it by changing rt2870/Kconfig...

-       depends on USB && X86 && WLAN
+       depends on USB && (X86 || ARM) && WLAN

... and (so far) it works fine on my SheevaPlug (armv5tel).

I don't know anything about rt2870.  Are there good reasons for me not
doing this?

-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/

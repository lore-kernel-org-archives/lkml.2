Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1DFTnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:43:22 -0400
Received: from mail.wdtv.com ([66.118.69.84]:37649 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab1DFTnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:43:21 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.38.2-New, apparently undfined var in include/linux/Kbuild breaks make headers_install
Date: Wed, 6 Apr 2011 15:43:13 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.37; KDE/4.6.1; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104061543.14218.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is, in line 25 is $(INSTALL_HDR_PATH)

What do I export as that $VAR that will satisfy this?

--  
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
<http://tinyurl.com/ddg5bz>
<http://www.cantrip.org/gatto.html>
I feel better about world problems now!

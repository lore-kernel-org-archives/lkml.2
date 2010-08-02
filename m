Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab0HBTuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:50:12 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:41664 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753495Ab0HBTuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:50:10 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: brgerst@gmail.com
Subject: 6175ddf06b6172046a329e3abfd9c901a43efd2e breaks matroxfb console
Date: Mon, 2 Aug 2010 21:49:58 +0200
User-Agent: KMail/1.9.10
Cc: hpa@zytor.com, Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008022150.01037.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
matroxfb (at least with Mystique and Mystique 220) stopped working in 2.6.34 - 
the screen is completely corrupted. Bisection shows that 
6175ddf06b6172046a329e3abfd9c901a43efd2e is first bad commit.

Reverting 6175ddf06b6172046a329e3abfd9c901a43efd2e in 2.6.34 fixes the problem 
(1c5b9069e12e20d2fe883076ae0bf73966492108 must be reverted first).

-- 
Ondrej Zary

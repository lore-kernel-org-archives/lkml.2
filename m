Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1HLR7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:59:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51600 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab1HLR7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:59:38 -0400
MIME-Version: 1.0
Date: Fri, 12 Aug 2011 23:29:36 +0530
Message-ID: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
Subject: x86 memcpy performance
From: melwyn lobo <linux.melwyn@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
Our Video recorder application uses memcpy for every frame. About 2KB
data every frame on Intel® Atom™ Z5xx processor.
With default 2.6.35 kernel we got 19.6 fps. But it seems kernel
implemented memcpy is suboptimal, because when we replaced
with an optmized one (using ssse3, exact patches are currently being
finalized) ew obtained 22fps a gain of 12.2 %.
C0 residency also reduced from 75% to 67%. This means power benefits too.
My questions:
1. Is kernel memcpy profiled for optimal performance.
2. Does the default kernel configuration for i386 include the best
memcpy implementation (AMD 3DNOW, __builtin_memcpy .... etc)

Any suggestions, prior experience on this is welcome.

Thanks,
M.

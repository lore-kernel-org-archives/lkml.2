Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2BVHRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 02:17:38 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:61540 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716Ab2BVHRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 02:17:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of h.mitake@gmail.com designates 10.60.30.99 as permitted sender) smtp.mail=h.mitake@gmail.com; dkim=pass header.i=h.mitake@gmail.com
MIME-Version: 1.0
Date: Wed, 22 Feb 2012 16:17:36 +0900
Message-ID: <CAMO-S2gHb1fTvELVuBJ6ew+6WRRuUs8qWRX1HkvcCk1eB-Tpfg@mail.gmail.com>
Subject: segmentation fault of modpost
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried to build tip-tree with allmodconfig and ARCH=i386 on x86_64 machine.
And modpost caused segmentation fault like this:
modpost[23652]: segfault at 2b53bece3000 ip 00000000004030bb sp
00007ffffad8d260 error 4 in modpost[400000+d000]
# from dmesg

The commit of -tip tree is 64256eb8e9f8cd53100ee6142968df336c54eb32.

Is this problem already reported or solved?
If not, I'd like to solve this because I need to build all{mod,yes}config
kernel for testing readq/writeq of x86.

Thanks,

-- 
Hitoshi Mitake
h.mitake@gmail.com

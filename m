Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1EPNkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:40:39 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58879 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab1EPNki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:40:38 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Frank Arnold <farnold@amd64.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/3] x86, AMD, cacheinfo: L3 CID fixes
Date: Mon, 16 May 2011 15:39:45 +0200
Message-Id: <1305553188-21061-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

here are three fixes for the AMD L3 cache code that sprang up lately
after testing different enterprise backports. Ingo, hpa, it would be
cool if they went to urgent and to Linus before .39 is out, if possible.

For that, 3/3 needs ACKs from Greg/Randy before, though.

Patchset is also at

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git l3-fixes

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab0HDQpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:45:08 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:32969 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab0HDQpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:45:06 -0400
From: Borislav Petkov <bp@amd64.org>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>
Cc: <andreas.herrmann3@amd.com>, conny.seidel@amd.com, <joerg.roedel@amd.com>,
        Bhavna.Sarathy@amd.com, <greg@kroah.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Fix 32-bit CPU hotplug issue on AMD
Date: Wed,  4 Aug 2010 18:45:14 +0200
Message-Id: <1280940316-7966-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

the following two patches fix an issue which one of our tests triggers
here on a 32-bit kernel while exercising the CPU hotplug path. More
details are to be found in the respective commit messages.

Now, considering the seriousness of the issue, I'd very much like
to backport the fixes to .32 and .34. And while the fixes are not
oneliners, they're straightforward enough to not cause any problems
IMHO. But I may be biased from staring at them for a while now so what
do you guys, think, any objections to backporting those?

Thanks.

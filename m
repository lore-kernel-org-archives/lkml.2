Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0I3LAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:00:50 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41645 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab0I3LAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:00:46 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/8] EDAC patch queue for 37
Date: Thu, 30 Sep 2010 13:01:41 +0200
Message-Id: <1285844509-27120-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

since the merge window will be there soon, I think its time to unload
some of the stuff in the pending EDAC queue. Besides cleanups and fixes,
this series adds an error injection module which is selected by default
when MCE decoding is enabled. The idea behind it is to be able to inject
MCE signatures over /sysfs so that the MCE decoding code and amd64_edac
can be tested on production kernels without the need to recompile them.

So have a look, rant while there's time and so on...

Thanks,
Boris.

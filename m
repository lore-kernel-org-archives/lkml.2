Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2JVTUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:20:25 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:58272 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2JVTUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:20:23 -0400
Message-Id: <20121022191452.785366817@openvz.org>
User-Agent: quilt/0.48-1
Date: Mon, 22 Oct 2012 23:14:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [rfc 0/2] Introducing VmFlags field into smaps output
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys, during c/r sessions we've found that there is no way at
the moment to fetch some VMA associated flags, such as mlock()
and madvise(), thus the patches in this series intorduce new field
into "smaps" output called VmFlags where all flags associated with
the particular VMA is shown in two letter mnemonic.

Strictly speaking for c/r we only need mlock/madvise bits but it
has been said that providing just a few flags looks somehow inconsistent.
So all flags are here now.

Please review. Comments and complains are quite welcome!

Thanks,
	Cyrill

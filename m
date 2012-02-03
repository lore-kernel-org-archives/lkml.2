Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2BCP05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:26:57 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60453 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2BCP04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:26:56 -0500
Message-Id: <20120203151928.474036973@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 03 Feb 2012 19:19:28 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 0/4] [patch 0/4] A pile in c/r sake v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, hope this time I've addressed more or less all concerns,
still please say me if something is not yet good enough.

 - sys_kcmp now depends on CONFIG_CHECKPOINT_RESTORE
   (Ingo, I suppose arch_initcall for kcmp_cookies_init
    should be better than late_initcall, but I'm not
    sure)

 - the extension of /proc/pid/stat now done against
   linux-next/master

Please review, thanks,

	Cyrill

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab2BMQvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:51:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35983 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab2BMQvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:51:42 -0500
Message-Id: <20120213164822.227219834@openvz.org>
User-Agent: quilt/0.48-1
Date: Mon, 13 Feb 2012 20:48:22 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 0/4] Resending, c/r series v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this series hopefully in a good shape

 - sys_kcmp now depends on CONFIG_CHECKPOINT_RESTORE

 - the extension of /proc/pid/stat now done against
   linux-next/master

Please letme know if I've missed something.

Thanks,
	Cyrill

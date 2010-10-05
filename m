Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab0JEInV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:43:21 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40874 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab0JEInT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:43:19 -0400
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: menage@google.com, lizf@cn.fujitsu.com
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        bblum@andrew.cmu.edu, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, ext-eugeny.kuznetsov@nokia.com
Subject: [PATCH 0/1] cgroups: strcpy destination string overflow
Date: Tue,  5 Oct 2010 12:38:04 +0400
Message-Id: <cover.1286193571.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 05 Oct 2010 08:41:38.0344 (UTC) FILETIME=[201F0A80:01CB6469]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is patch which fixes minor bug in /kernel/cgroup.c file.
Function "strcpy" is used without check for maximum allowed source
string length and could cause destination string overflow.

Thanks,
Best Regards,
Evgeny

Evgeny Kuznetsov (1):
  cgroups: strcpy destination string overflow

 kernel/cgroup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


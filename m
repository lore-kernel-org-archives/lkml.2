Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab2LNJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:29:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:45453 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2LNJ2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:28:45 -0500
X-IronPort-AV: E=Sophos;i="4.84,280,1355068800"; 
   d="scan'208";a="6399192"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, tangchen@cn.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, mingo@elte.hu,
        penberg@kernel.org
Cc: torvalds@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Add help info for CONFIG_MOVABLE_NODE and disable is by default
Date: Fri, 14 Dec 2012 17:27:48 +0800
Message-Id: <1355477270-19922-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/14 17:27:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/14 17:27:50,
	Serialize complete at 2012/12/14 17:27:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch adds help info for CONFIG_MOVABLE_NODE option.
The second patch disable this option by default.

Tang Chen (2):
  memory-hotplug: Add help info for CONFIG_MOVABLE_NODE option
  memory-hotplug: Disable CONFIG_MOVABLE_NODE option by default.

 mm/Kconfig |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

-- 
1.7.10.1


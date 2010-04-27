Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab0D0Hqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 03:46:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63735 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab0D0Hqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 03:46:40 -0400
Message-ID: <4BD696CD.4090306@cn.fujitsu.com>
Date: Tue, 27 Apr 2010 15:48:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/6] kconfig: print symbol type in help text
References: <4BD696C0.8050500@cn.fujitsu.com>
In-Reply-To: <4BD696C0.8050500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/6] menuconfig: improive help text a bit

Suggested-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/mconf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 33f31eb..7ca6e8e 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -74,7 +74,7 @@ static const char mconf_readme[] = N_(
 "\n"
 "   Shortcut: Press <H> or <?>.\n"
 "\n"
-"o  To show hidden options, press <Z>.\n"
+"o  To toggle the display of hidden options, press <Z>.\n"
 "\n"
 "\n"
 "Radiolists  (Choice lists)\n"
-- 
1.6.3

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab0EFUNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 16:13:51 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:11841 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758377Ab0EFUNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 16:13:50 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACPA4kurR7Ht/2dsb2JhbACdfnGkAJlnhRMEgz8
X-IronPort-AV: E=Sophos;i="4.52,343,1270425600"; 
   d="scan'208";a="526077164"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Changli Gao <xiaosuo@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: indiscriminate get_maintainer.pl usage
References: <1273111054-10141-1-git-send-email-xiaosuo@gmail.com>
	<4BE25AE8.1060607@s5r6.in-berlin.de>
	<s2t412e6f7f1005052319sdbf3fdfbg256d11b983c4f304@mail.gmail.com>
	<4BE26472.6040805@s5r6.in-berlin.de>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 06 May 2010 13:13:46 -0700
In-Reply-To: <4BE26472.6040805@s5r6.in-berlin.de> (Stefan Richter's message of
	"Thu, 06 May 2010 08:40:50 +0200")
Message-ID: <ada4oikaiv9.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > $ scripts/get_maintainer.pl --rolestats -f fs/eventpoll.c
 > Alexander Viro <viro@zeniv.linux.org.uk> (maintainer:FILESYSTEMS (VFS...)
 > Andrew Morton <akpm@linux-foundation.org> (commit_signer:2/6=33%)
 > "Eric W. Biederman" <ebiederm@xmission.com> (commit_signer:2/6=33%)
 > Davide Libenzi <davidel@xmailserver.org> (commit_signer:2/6=33%)
 > Roland Dreier <rolandd@cisco.com> (commit_signer:1/6=17%)
 > Stefan Richter <stefanr@s5r6.in-berlin.de> (commit_signer:1/6=17%)
 > linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS...)
 > linux-kernel@vger.kernel.org (open list)

And my appearing here is a bit silly as well, since I have made one
commit to fs/eventpoll.c that changed one line.  A bit different in
scope from Davide who designed and wrote the whole thing...

OTOH it's not clear how smart we want get_maintainer.pl to try to be.

 - R.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab0DROiM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 10:38:12 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:52014 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab0DROiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 10:38:10 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.52,231,1270425600"; 
   d="scan'208";a="516952173"
From: Roland Dreier <rdreier@cisco.com>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
       rolandd@cisco.com, peterz@infradead.org, pavel@ucw.cz, mingo@elte.hu
Subject: Re: [PATCH] ummunotify: fix umn-test build
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
	<20100414094341.ba69842d.randy.dunlap@oracle.com>
	<20100417174404.GB3579@us.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 18 Apr 2010 07:38:06 -0700
In-Reply-To: <20100417174404.GB3579@us.ibm.com> (Eric B. Munson's message of
	"Sat, 17 Apr 2010 21:44:05 +0400")
Message-ID: <ada633oltbl.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric, sorry for not seeing this earlier, but it looks like the last
patch I emailed out did not include all the tiny changes I made prior to
asking Linus to pull this (which he ended up not doing).  For example
this fix to the include Kbuild file was there.

You could look at:
http://git.kernel.org/?p=linux/kernel/git/roland/infiniband.git;a=commit;h=cfe60a43c3434907a47323fb82d2960e915a9538

to see what was actually in my pull request.  There may be other trivial
tweaks worth including.

Thanks for resurrecting this work BTW.

 - R.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html

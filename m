Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab1JMXiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:38:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58105 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1JMXiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:38:22 -0400
Date: Fri, 14 Oct 2011 01:38:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Please include const-sections into linux-next
Message-ID: <20111013233818.GB26654@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

Please include 
git://github.com/andikleen/linux-misc.git const-sections
in linux-next. This has a tree sweep to fix all kind of constant 
section issues.

I intend to send Linus a pull request next cycle and would like 
to get some testing in next first.

I got various acks last time it was posted and added them all.
In general it falls more in the "trivial" category, but it's 
rather large and all over so I may have made a mistake.

Thanks,

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0G1XKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:10:22 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:10737 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0G1XKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:10:17 -0400
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAONVUEyrRN+K/2dsb2JhbACZS4Y9cahemnyFNgSEDg
X-IronPort-AV: E=Sophos;i="4.55,276,1278288000"; 
   d="scan'208";a="231970715"
Date: Wed, 28 Jul 2010 16:10:17 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Kernel GPLv question-"Prominent Notice"
Message-ID: <20100728231017.GA23605@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not looking to be flamed, but I gotta ask. The GPLv2 has the sentence:

	You must cause the modified files to carry prominent notices
	stating that you changed the files and the date of any change.

My understanding of kernel community protocol is that you only put change
info in the source file if you made a major change, not if you corrected
something minor. IIRC, I even saw a patch bounced, in part, because it had
a line of change info added for a minor fix. (Again, IIRC, it was accepted
when it was resubmitted as modified)

We've been sued a time or two, making our legal folk a bit sensitive and
they want developers to follow the GPL to the letter. Now, they're not
likely to post anything here, but I thought I might personally get some
sense of what the future might hold. And I'm confident I can look
forward to some clearly stated viewpoints.
-- 
David VL

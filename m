Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331Ab2CGQIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:08:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:8287 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab2CGQIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:08:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="115546398"
Message-ID: <1331136589.3463.3.camel@sauron.fi.intel.com>
Subject: Re: [RFC][PATCH 1/7] MTD: UBI: Add checkpoint on-chip layout
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <rw@linutronix.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tim.bird@am.sony.com
Date: Wed, 07 Mar 2012 18:09:49 +0200
In-Reply-To: <1329250006-22944-2-git-send-email-rw@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
	 <1329250006-22944-2-git-send-email-rw@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 21:06 +0100, Richard Weinberger wrote:
> Specify the on-chip checkpoint layout.
> The checkpoint consists of two major parts.
> A super block (identified via UBI_CP_SB_VOLUME_ID) and
> zero or more data blocks (identified via UBI_CP_DATA_VOLUME_ID).
> Data blocks are only used if whole checkpoint information does not fit
> into the super block.

And superblock is also a more or less standard name used by file-system.
I easily imagine difficulties and confusion when discussing UBIFS and
UBI and mixing UBI and UBIFS supersblocks up. IMHO, anything unique is
much better, even if it does not make much sense. E.g., "boss block" or
"pomo block" (pomo = boss in Finnish).

Would you consider picking a different name as well please?

-- 
Best Regards,
Artem Bityutskiy


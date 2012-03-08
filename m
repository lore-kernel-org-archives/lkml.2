Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2CHLUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:20:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:61978 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab2CHLUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:20:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="116323164"
Message-ID: <1331205761.7257.5.camel@sauron.fi.intel.com>
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <rw@linutronix.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tim.bird@am.sony.com
Date: Thu, 08 Mar 2012 13:22:41 +0200
In-Reply-To: <4F57CCB9.9090001@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
	 <1331136246.32316.39.camel@sauron.fi.intel.com>
	 <4F57CCB9.9090001@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 22:01 +0100, Richard Weinberger wrote:
> > Please, consider an option of picking a different name. In JFFS2 a
> > "similar" thing was called "summaries", and even this is better than
> > "checkpoint", I think.
> 
> What about "Erase block indexing"?
> Basically a checkpoint is an index...

Index is also very loaded word already, and UBIFS has index, would be
nice to use a word UBIFS does not use. Thomas's suggestions like fastmap
or roadmap/milestone are fine with me. UBIUBI is clever, but probably
confusing a bit as well :-)

-- 
Best Regards,
Artem Bityutskiy


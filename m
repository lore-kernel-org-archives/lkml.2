Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0I2Dx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 23:53:29 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:56226 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab0I2Dx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 23:53:28 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.57,251,1283731200"; 
   d="scan'208";a="193348143"
From: Roland Dreier <rdreier@cisco.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <rolandd@cisco.com>
Subject: Re: [patch 23/30] infiniband: Make user_mad semaphore a real one
References: <20100907124636.880953480@linutronix.de>
	<20100907125056.892309973@linutronix.de>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 28 Sep 2010 20:53:18 -0700
In-Reply-To: <20100907125056.892309973@linutronix.de> (Thomas Gleixner's
	message of "Tue, 07 Sep 2010 14:33:31 -0000")
Message-ID: <adad3rx434h.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.

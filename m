Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0HSMf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:35:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0HSMfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:35:23 -0400
Subject: Re: [PATCH/RFC 2/5] [PATCH] sched: pass sched_domain_level to
 sched_power_savings_store
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20100819114102.GE4659@loge.amd.com>
References: <20100812172544.655648128@de.ibm.com>
	 <20100812172622.349333778@de.ibm.com> <1281947397.1926.1012.camel@laptop>
	 <20100819114102.GE4659@loge.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 Aug 2010 14:35:11 +0200
Message-ID: <1282221311.2605.81.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 13:41 +0200, Andreas Herrmann wrote:
> It just allows to use the same store functions for three instead of
> two different knobs. 

Creating more knobs for powersave scheduling is a fail.

We already have 2^3 powersave scheduling states, it should be decreased
to 2 (namely on/off), not increased to 3^3.



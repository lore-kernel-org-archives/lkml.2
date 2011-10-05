Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934721Ab1JETQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:16:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:60759 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934227Ab1JETQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:16:51 -0400
Subject: Re: [PATCH 0/8] Online/offline BSP on x86
From: Peter Zijlstra <peterz@infradead.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 05 Oct 2011 21:16:34 +0200
In-Reply-To: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317842195.6766.40.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 09:39 -0700, Fenghua Yu wrote:
> 
> BSP or CPU0 has been the last obstacle to CPU hotplug on x86. This patch set
> implements BSP online and offline and removes this obstacle to CPU hotplug.

Are you talking about physical cpu hotplug on x86? And you need to
offline the BSP so you can replace socket0 ?

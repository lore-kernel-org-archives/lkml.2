Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab1CCKN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:13:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52261 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab1CCKN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:13:26 -0500
Subject: Re: [PATCH v3 0/4] perf: offcore event monitoring patches
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1299119690-13991-1-git-send-email-ming.m.lin@intel.com>
References: <1299119690-13991-1-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 11:14:57 +0100
Message-ID: <1299147297.1310.50.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 10:34 +0800, Lin Ming wrote:

> Peter,
> The event scheduling issue was fixed, could you please consider merging
> this series?

I'll have a look today.

BTW, you managed to wreck git-send-email, you have git 1.7 which does
the right thing by default (--no-chain-reply-to), please do use that. I
normally ignore emails send like this.


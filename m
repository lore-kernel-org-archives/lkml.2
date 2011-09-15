Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935352Ab1IOXQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:16:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:47510 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab1IOXQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:16:31 -0400
Date: Fri, 16 Sep 2011 01:16:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] perf_events: Pass the event to
 perf_instruction_pointer
In-Reply-To: <1316127412-1912-2-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1109160113500.2723@ionos>
References: <1316127412-1912-1-git-send-email-andi@firstfloor.org> <1316127412-1912-2-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Used in next patch.

What for?

Just get it: We want to have reasonable changelogs and not a puzzle
game!

Is it really that hard ?

Thanks,

	tglx

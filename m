Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab2GTQs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:48:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:35008 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2GTQs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:48:27 -0400
Message-ID: <1342802895.2583.16.camel@twins>
Subject: Re: [PATCH] perf/x86: Fix LLC-* and node-* events on Intel
 SandyBridge
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@gmail.com>
Date: Fri, 20 Jul 2012 18:48:15 +0200
In-Reply-To: <1342517275-2875-1-git-send-email-zheng.z.yan@intel.com>
References: <1342517275-2875-1-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 17:27 +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> LLC-* and node-* events require using the OFFCORE_RESPONSE events
> on SandyBridge, but the hw_cache_extra_regs is left uninitialized.
> This patch adds the missing extra register configure table for
> SandyBridge. 

Last time I tried this I couldn't get sane numbers out of it..

Does these encodings work, if so, do explain them.

Also:

> +#define SNB_REMOTE             (0xffULL << 23)

I guess I can take this as an 'official' publication of this fact?

(I knew those bits meant this, but I never got a response if I could
publish that information.)

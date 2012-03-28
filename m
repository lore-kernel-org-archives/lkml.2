Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab2C1Gte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:49:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60671 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2C1Gtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:49:33 -0400
Date: Wed, 28 Mar 2012 08:49:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: Re: [RFC PATCH 0/5] perf: Intel uncore pmu counting support
Message-ID: <20120328064928.GA21725@gmail.com>
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yan, Zheng <zheng.z.yan@intel.com> wrote:

> Hi, all
> 
> Here is the RFC patches to add uncore counting support for Nehalem,
> Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
> The code is based on Lin Ming's old patches.
> 
> You can use 'perf stat' to access to the uncore pmu. For example:
> perf stat -a -C 0 -e 'uncore_nhm/config=0xffff/' sleep 1

My main complaint is that that's not user friendly *AT ALL*.

You need to make this useful to mere mortals: go through the 
SDM, categorize interesting looking events, look at how it can 
be expressed via tooling, add a generic event where appropriate, 
provide examples, actually *USE* it to improve the kernel or an 
app and see the workflow as it happens and improve the tooling, 
etc.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab2ECVtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:49:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60769 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab2ECVtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:49:31 -0400
Message-ID: <1336081756.6509.33.camel@twins>
Subject: Re: [PATCH 4/9] perf: Generic intel uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com, jolsa@redhat.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 23:49:16 +0200
In-Reply-To: <1335924440-11242-5-git-send-email-zheng.z.yan@intel.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
	 <1335924440-11242-5-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 10:07 +0800, Yan, Zheng wrote:
> +               sprintf(pmu->name, "uncore_%s%d", pmu->type->name,
> +                       pmu->pmu_idx); 

That probably wants to be: "uncore_%s_%d" or somesuch.

"uncore_C-Box3 vs "uncore_C-Box_3"

Looking at it like that, it might do to call it "Uncore*", dunno..

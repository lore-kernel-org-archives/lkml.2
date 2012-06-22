Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab2FVIFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 04:05:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50752 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab2FVIFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 04:05:20 -0400
Message-ID: <1340352305.18025.45.camel@twins>
Subject: Re: [tip:perf/core] perf/x86: Add generic Intel uncore PMU support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, zheng.z.yan@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Date: Fri, 22 Jun 2012 10:05:05 +0200
In-Reply-To: <20120621154334.05a74517.akpm@linux-foundation.org>
References: <1339741902-8449-6-git-send-email-zheng.z.yan@intel.com>
	 <tip-087bfbb032691262f2f7d52b910652450c5554b8@git.kernel.org>
	 <20120621154334.05a74517.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 15:43 -0700, Andrew Morton wrote:
> Should we even be compiling this code in an i386 build?

Some people still run i386 kernels on their brand spanking new Intel
hardware.. So yeah probably.

But yeah, we could make it x86_64 only.. not really a strong case
though.

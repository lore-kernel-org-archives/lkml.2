Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137Ab1CDUFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 15:05:36 -0500
Received: from mail.perches.com ([173.55.12.10]:4120 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab1CDUFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 15:05:36 -0500
Subject: Re: [RFC -tip] perf, x86: P4 PMU -- Address erratum 15 and 17
From: Joe Perches <joe@perches.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4D7141FC.8000504@gmail.com>
References: <4D7141FC.8000504@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 12:05:34 -0800
Message-ID: <1299269134.1929.60.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 22:48 +0300, Cyrill Gorcunov wrote:
> Errata N15 and 17 of 249199-071 should be taken
> into account. They are mostly hard to hit at moment
> i believe but still better to be fixed.

Trivia:

> +			printk_once("P4 PMU: Recover lost carry bit\n");

			pr_info_once(etc...)



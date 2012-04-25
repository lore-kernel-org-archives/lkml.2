Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab2DYMUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:20:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52774 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758779Ab2DYMUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:20:47 -0400
Message-ID: <1335356427.28150.264.camel@twins>
Subject: Re: [PATCH] sched: fix OOPS when build_sched_domains percpu
 allocation fails
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "he, bo" <bo.he@intel.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, rusty@rustcorp.com.au,
        william.douglas@intel.com, linux-kernel@vger.kernel.org,
        yanmin_zhang@linux.intel.com, yanmin.zhang@intel.com
Date: Wed, 25 Apr 2012 14:20:27 +0200
In-Reply-To: <1335355161.5892.17.camel@hebo>
References: <1335355161.5892.17.camel@hebo>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 19:59 +0800, he, bo wrote:
> From: "he, bo" <bo.he@intel.com>
> 
> Under extreme memory used up situation, percpu allocation
> might fails. We hit it when system go to suspend-to-ram.

Thanks!


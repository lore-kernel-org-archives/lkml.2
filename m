Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab2EJKEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:04:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44573 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883Ab2EJKEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:04:21 -0400
Message-ID: <1336644104.2527.93.camel@twins>
Subject: Re: [PATCH] sched: set TAINT_UNSAFE_SMP after sleep-in-atomic bug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 10 May 2012 12:01:44 +0200
In-Reply-To: <20120510075403.21849.5109.stgit@zurg>
References: <20120510075403.21849.5109.stgit@zurg>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 11:54 +0400, Konstantin Khlebnikov wrote:
> Usually sleep-in-atomic bugs are followed by dozens other warnings.
> This patch should help to figure out original source of problem.
> This taint flag also turns off lockdep, because it can go mad after that.

There's already TAINT_WARN any output with that set should be ignored.

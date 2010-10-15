Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab0JOUog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:44:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:59175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab0JOUof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:44:35 -0400
Subject: Re: [PATCH 0/4][RFC v3] Improve load balancing when tasks have
 large weight differential -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <1287173550-30365-1-git-send-email-ncrao@google.com>
References: <1287173550-30365-1-git-send-email-ncrao@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 22:44:24 +0200
Message-ID: <1287175464.1998.112.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 13:12 -0700, Nikhil Rao wrote:
> 
> Please find attached a a series of patches that improve load balancing
> when there is a large weight differential between tasks (such as when nicing a
> task or when using SCHED_IDLE). These patches are based off feedback given by
> Peter Zijlstra and Mike Galbraith in earlier posts.


Thanks, I've queued them up, we'll see what happens :-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab0LWVxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 16:53:42 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26158 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab0LWVxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 16:53:41 -0500
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC -v9 4/4] net, rds, Replace xlist in net/rds/xlist.h with llist
In-reply-to: <1293083003-19577-5-git-send-email-ying.huang@intel.com>
References: <1293083003-19577-1-git-send-email-ying.huang@intel.com> <1293083003-19577-5-git-send-email-ying.huang@intel.com>
Date: Thu, 23 Dec 2010 16:51:21 -0500
Message-Id: <1293140819-sup-9361@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Huang Ying's message of 2010-12-23 00:43:23 -0500:
> The functionality of xlist and llist is almost same.  This patch
> replace xlist with llist to avoid code duplication.

I'm not against it, the goal was always to move this to include/linux as
more users popped up.  We can test it out here with rds RDMA.

-chris

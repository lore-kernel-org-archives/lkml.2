Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1AGFml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 00:42:41 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:43016 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751633Ab1AGFmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 00:42:40 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18qEqh+hRQqhnQ8Hz7sYhio2fOE4W88JdwxlHLrh1
	QJ9U2fwWcvbp6K
Subject: Re: [PATCH] sched: remove root_task_group
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1294375414-31028-1-git-send-email-yong.zhang0@gmail.com>
References: <1294375414-31028-1-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 06:42:30 +0100
Message-ID: <1294378950.8823.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 12:43 +0800, Yong Zhang wrote:
> root_task_group is the leftover of USER_SCHED, now it's always
> same to init_task_group.

Wouldn't the reverse be better?  It's root as in tree.

	-Mike


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161Ab1FDEOI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 00:14:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806Ab1FDEOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 00:14:07 -0400
Date: Fri, 3 Jun 2011 21:14:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: Fix wrong kunmap_atomic() pointer
Message-Id: <20110603211422.3db036df.akpm@linux-foundation.org>
In-Reply-To: <1307158665.3667.86.camel@gandalf.stny.rr.com>
References: <1307158665.3667.86.camel@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Jun 2011 23:37:45 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> Running a ktest.pl test, I hit the following bug on x86_32:

Damn, that sounds like a useful tool.  You should tell people about it!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab1HKOVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:21:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab1HKOVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:21:33 -0400
Date: Thu, 11 Aug 2011 16:21:26 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] ftrace/filter: Trace events filtering related fixies
Message-ID: <20110811142126.GC2065@jolsa.brq.redhat.com>
References: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
 <1313011535.18583.280.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313011535.18583.280.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 05:25:35PM -0400, Steven Rostedt wrote:
> On Thu, 2011-08-04 at 12:08 +0200, Jiri Olsa wrote:
> > hi,
> > 
> > on the way to perf/ftrace filtering changes, I made some changes
> > to the current events filtering code. It could be divided into 3
> > parts roughly:
> > 
> > - remove unnecessary dynamic allocations (patches 1 - 4)
> > - unify the predicate tree walking (patches 5 - 9)
> > - added startup test for event filtering (patch 10)
> > 
> > attached patches:
> > - 01/10 tracing/filter: Use static allocation for filter predicates
> > - 02/10 tracing/filter: Separate predicate init and filter addition
> > - 03/10 tracing/filter: Remove field_name from filter_pred struct
> > - 04/10 tracing/filter: Simplify tracepoint event lookup
> > - 05/10 tracing/filter: Unify predicate tree walking, change check_pred_tree function to use it
> > - 06/10 tracing/filter: Change count_leafs function to use walk_pred_tree
> > - 07/10 tracing/filter: Change fold_pred_tree function to use walk_pred_tree
> > - 08/10 tracing/filter: Change fold_pred function to use walk_pred_tree
> > - 09/10 tracing/filter: Change filter_match_preds function to use walk_pred_tree
> > - 10/10 tracing/filter: Add startup tests for events filter
> 
> Other than the comments I made, I really like this patch set. Thanks a
> lot for the hard work put into this!
> 
> If you do an update, I'll pull it into my queue for 3.2.

thanks for comments, I'll send out v2 shortly

jirka

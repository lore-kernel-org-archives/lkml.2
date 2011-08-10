Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab1HJVZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 17:25:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55680 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab1HJVZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 17:25:37 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=X6F9eoo1gIkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Ip3R4JTmQpuUQOtg_4kA:9 a=xFdSMWSSj9Qi0VRWTN0A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/10] ftrace/filter: Trace events filtering related
 fixies
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
References: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Aug 2011 17:25:35 -0400
Message-ID: <1313011535.18583.280.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 12:08 +0200, Jiri Olsa wrote:
> hi,
> 
> on the way to perf/ftrace filtering changes, I made some changes
> to the current events filtering code. It could be divided into 3
> parts roughly:
> 
> - remove unnecessary dynamic allocations (patches 1 - 4)
> - unify the predicate tree walking (patches 5 - 9)
> - added startup test for event filtering (patch 10)
> 
> attached patches:
> - 01/10 tracing/filter: Use static allocation for filter predicates
> - 02/10 tracing/filter: Separate predicate init and filter addition
> - 03/10 tracing/filter: Remove field_name from filter_pred struct
> - 04/10 tracing/filter: Simplify tracepoint event lookup
> - 05/10 tracing/filter: Unify predicate tree walking, change check_pred_tree function to use it
> - 06/10 tracing/filter: Change count_leafs function to use walk_pred_tree
> - 07/10 tracing/filter: Change fold_pred_tree function to use walk_pred_tree
> - 08/10 tracing/filter: Change fold_pred function to use walk_pred_tree
> - 09/10 tracing/filter: Change filter_match_preds function to use walk_pred_tree
> - 10/10 tracing/filter: Add startup tests for events filter

Other than the comments I made, I really like this patch set. Thanks a
lot for the hard work put into this!

If you do an update, I'll pull it into my queue for 3.2.

-- Steve



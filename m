Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab2BBRm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:42:56 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46708 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab2BBRmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:42:55 -0500
Date: Thu, 2 Feb 2012 18:42:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 4/7] ftrace, perf: Add add/del tracepoint perf
 registration actions
Message-ID: <20120202174248.GG9071@somewhere.redhat.com>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-5-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327776209-4883-5-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 07:43:26PM +0100, Jiri Olsa wrote:
> Adding TRACE_REG_PERF_ADD and TRACE_REG_PERF_DEL to handle
> perf event schedule in/out actions.
> 
> The add action is invoked for when the perf event is scheduled in,
> while the del action is invoked when the event is scheduled out.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

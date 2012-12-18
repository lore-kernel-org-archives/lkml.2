Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab2LRP2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:28:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab2LRP2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:28:44 -0500
Date: Tue, 18 Dec 2012 16:28:15 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 01/14] perf tools: Keep group information
Message-ID: <20121218152814.GI1283@krava.brq.redhat.com>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
 <1355726345-29553-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355726345-29553-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 03:38:52PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Add a few of group-related field in struct perf_{evlist,evsel} so that
> the group information in a evlist can be known easily.  It only counts
> groups which have more than 1 members since leader-only groups are
> treated as non-group events.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

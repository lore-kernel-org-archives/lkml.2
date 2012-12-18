Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2LRPcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:32:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab2LRPcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:32:53 -0500
Date: Tue, 18 Dec 2012 16:32:41 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 05/14] perf report: Make another loop for linking group
 hists
Message-ID: <20121218153241.GL1283@krava.brq.redhat.com>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
 <1355726345-29553-6-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355726345-29553-6-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 03:38:56PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Now the event grouping viewing requires linking all member hists in a
> group to the leader's.  Thus hists__output_resort should be called
> after linking all events in evlist.
> 
> Introduce symbol_conf.event_group flag to determine whether the
> feature is enabled or not.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Jiri Olsa <jolsa@redhat.com>

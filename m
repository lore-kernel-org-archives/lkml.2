Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab2K2O2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:28:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab2K2O2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:28:49 -0500
Date: Thu, 29 Nov 2012 15:28:35 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 02/18] perf evsel: Convert to _is_group_leader method
Message-ID: <20121129142834.GI1096@krava.brq.redhat.com>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
 <1354171126-14387-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354171126-14387-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:38:30PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Convert perf_evsel__is_group_member to perf_evsel__is_group_leader.
> This is because the most usecases are using negative form to check
> whether the given evsel is a leader or not and it's IMHO somewhat
> ambiguous - leader also *is* a member of the group.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---

Acked-by: Jiri Olsa <jolsa@redhat.com>

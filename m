Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab2LTCfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 21:35:04 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61352 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2LTCe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 21:34:57 -0500
X-AuditID: 9c930197-b7c5bae000000e31-3e-50d2794cde7a
Date: Thu, 20 Dec 2012 11:34:52 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 07/14] perf ui/hist: Add support for event group view
Message-ID: <20121220023452.GA3679@danjae>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
 <1355726345-29553-8-git-send-email-namhyung@kernel.org>
 <20121218193015.GA2639@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121218193015.GA2639@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 04:30:15PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 17, 2012 at 03:38:58PM +0900, Namhyung Kim escreveu:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > Show group members' overhead also when showing the leader's if event
> > group is enabled.  Use macro for defining hpp functions which looks
> > almost identical.
> > 
> > Thanks to Arnaldo for suggesting a better way to print group members
> > without allocating temporary array.
> 
> I applied up to the previous patch (6/14), doing minor changes in some
> due to clashes with other patches, but then this one isn't applying, can
> you take a look?

Of course.  It's because, as I mentioned in the cover letter, this patch
set was based on Jiri's multi-diff series which contains a couple of
changes in hpp side.  I somehow thought you wanted to apply his change
before mine. ;-)

> 
> I left what I did on the perf/group, so you can continue from there.

I rebased it on the perf/group branch and pushed to perf/group-v8 on my
tree.  Please take a look, or I can resend it to the list if you want.

Thanks,
Namhyung

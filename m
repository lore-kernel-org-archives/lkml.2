Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab2GYPjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:39:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab2GYPjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:39:51 -0400
Date: Wed, 25 Jul 2012 17:39:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Ulrich Drepper <drepper@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 06/12] perf header: Reconstruct group relationship by
 parsing cmdline
Message-ID: <20120725153932.GE946@krava.brq.redhat.com>
References: <1343120493-23059-1-git-send-email-namhyung@kernel.org>
 <1343120493-23059-7-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343120493-23059-7-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 06:01:27PM +0900, Namhyung Kim wrote:
> In order to support the event group viewer, their group relationship
> is needed. Since it's not recorded explicitly anywhere in the perf.data
> we should parse saved cmdline and apply the result to the evlist. It is
> assumed that parsed entries are in a same order with the originals.
> 
> I know it's fragile but hard to find other way to do it in the current
> condition. :(

How about storing grouping details in new perf.data feature?
As you said reparsing looks too fragile.

jirka

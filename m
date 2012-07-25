Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab2GYPwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:52:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55576 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab2GYPwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:52:42 -0400
Subject: Re: [PATCH 06/12] perf header: Reconstruct group relationship by
 parsing cmdline
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Ulrich Drepper <drepper@gmail.com>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20120725153932.GE946@krava.brq.redhat.com>
References: <1343120493-23059-1-git-send-email-namhyung@kernel.org>
	 <1343120493-23059-7-git-send-email-namhyung@kernel.org>
	 <20120725153932.GE946@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Jul 2012 00:52:33 +0900
Message-ID: <1343231553.1525.11.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-07-25 (수), 17:39 +0200, Jiri Olsa:
> On Tue, Jul 24, 2012 at 06:01:27PM +0900, Namhyung Kim wrote:
> > In order to support the event group viewer, their group relationship
> > is needed. Since it's not recorded explicitly anywhere in the perf.data
> > we should parse saved cmdline and apply the result to the evlist. It is
> > assumed that parsed entries are in a same order with the originals.
> > 
> > I know it's fragile but hard to find other way to do it in the current
> > condition. :(
> 
> How about storing grouping details in new perf.data feature?
> As you said reparsing looks too fragile.
> 
> jirka

Yeah, maybe it's the best thing I can do now.

Thanks,
Namhyung



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab2GXVRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:17:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33428 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2GXVRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:17:39 -0400
Date: Tue, 24 Jul 2012 23:17:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Ulrich Drepper <drepper@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC/PATCHSET 00/12] perf report: Add support to event group viewing (v1)
Message-ID: <20120724211733.GR11413@one.firstfloor.org>
References: <1343120493-23059-1-git-send-email-namhyung@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343120493-23059-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 06:01:21PM +0900, Namhyung Kim wrote:
> Hi all,
> 
> This is a patchset to support event grouping on perf report.

I haven't read it in detail, but the concept looks good.

The main thing I'm interested in would be a group aware annotation.
So that you can use one event as a leader, but when you look at
the annotated source/assembler you see the average counts of all the 
events as they were when the leader fired.

-Andi


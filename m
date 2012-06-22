Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940Ab2FVJsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:48:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:35384 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761898Ab2FVJsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:48:08 -0400
Message-ID: <1340358478.18025.51.camel@twins>
Subject: Re: [RFC/PATCHSET 0/8] perf tools: Minimal build without libelf
 dependency (v2)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Date: Fri, 22 Jun 2012 11:47:58 +0200
In-Reply-To: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 14:37 +0900, Namhyung Kim wrote:
> And then I realized that the perf record needs to know about the
> build-id's anyway. :( So I implemented a poor man's version of elf
> parser only for parsing the build-id info. 

Why? the very first versions didn't know about any of that nonsense :-)
It works just fine as long as you don't go change binaries around.

That said, you did the work already, so no objection, just saying
builtids aren't that important.

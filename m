Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762484Ab2FVQOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:14:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33413 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2FVQOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:14:53 -0400
Date: Fri, 22 Jun 2012 13:14:49 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCHSET 0/8] perf tools: Minimal build without libelf
 dependency (v2)
Message-ID: <20120622161449.GL17747@infradead.org>
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
 <1340358478.18025.51.camel@twins>
 <1340377510.1478.10.camel@leonhard>
 <4FE48CCA.2050506@gmail.com>
 <1340379000.1478.34.camel@leonhard>
 <4FE490C9.1020903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE490C9.1020903@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 22, 2012 at 09:35:37AM -0600, David Ahern escreveu:
> On 6/22/12 9:30 AM, Namhyung Kim wrote:
> >>And build-id's are not required for report (-B option for record).

> >>Also, the intent is for a small footprint binary for embedded systems.
> >>On such a system I would expect binaries and libraries to be stripped,
> >>so no point in running perf-archive.

> >But is there a chance that binaries on host still contains symbol (and
> >debug) information even for those cases?
> 
> AFAIK embedded systems do not have the luxury of symbols; the goal
> is as small as possible. All debugging information is left on the
> build servers for off line analysis. That's certainly true for the
> product I work on.

I think at least the .dymsym symbol table is present in DSOs, aka
libraries, otherwise how will they dynamicly link?

- Arnaldo

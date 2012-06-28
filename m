Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2F1QOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:14:15 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51570 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab2F1QOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:14:14 -0400
Date: Thu, 28 Jun 2012 13:14:08 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 1/2] tools lib traceevent: Teach [ce]tags about
 libtraceeevent error codes
Message-ID: <20120628161408.GA6211@infradead.org>
References: <1340352615-20737-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340352615-20737-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 22, 2012 at 05:10:14PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> As we use a macro trick to sync each error codes with its
> description string, teach [ce]tags to process them properly.
> 
> This patch modifies the libtraceevent's Makefile not a
> kernel one.

Thanks, applied to perf/core.

- Arnaldo

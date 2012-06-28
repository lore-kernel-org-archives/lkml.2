Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2F1QWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:22:43 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42035 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab2F1QWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:22:42 -0400
Date: Thu, 28 Jun 2012 13:22:38 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 4/4] tools lib traceevent: Add support for __print_hex()
Message-ID: <20120628162238.GB6475@infradead.org>
References: <1340757701-10711-1-git-send-email-namhyung@kernel.org>
 <1340757701-10711-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340757701-10711-4-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jun 27, 2012 at 09:41:41AM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Since the __print_hex() function is used in print fmt now,
> add corresponding parser routines. This makes the output of
> perf script on the kvm_emulate_insn event not to fail any more.

Thanks, applied to perf/core.

- Arnaldo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab1AMNBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:01:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:60355 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab1AMNBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:01:20 -0500
Subject: Re: [PATCH -perf/perf/core 4/6] perf: Add strfilter for general
 purpose string filter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <20110113124617.22426.25293.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>
	 <20110113124617.22426.25293.stgit@ltc236.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 13 Jan 2011 14:01:41 +0100
Message-ID: <1294923701.19601.108.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 21:46 +0900, Masami Hiramatsu wrote:
> Format:
> <rule> ::= <glob-exp> | "!" <rule> | <rule> <op> <rule> | "(" <rule> ")"
> <op> ::= "&" | "|"
> 
> e.g.
>  "(add* | del*) & *timer" filter rules pass strings which
>  start with add or del and end with timer. 

Why not simply use regexps?

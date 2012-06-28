Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2F1QRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:17:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35335 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2F1QRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:17:43 -0400
Date: Thu, 28 Jun 2012 13:17:38 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 2/2] tools lib traceevent: Check string is really
 printable
Message-ID: <20120628161738.GC6211@infradead.org>
References: <1340352615-20737-1-git-send-email-namhyung@kernel.org>
 <1340352615-20737-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340352615-20737-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 22, 2012 at 05:10:15PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> When libtraceevent parses format fields, it assumes that
> array of 1 byte is string but it's not always true. The
> kvm_emulate_insn contains 15 u8 array of insn that contains
> (binary) instructions. Thus when it's printed, it'll have
> broken output like below:

Thanks, applied to perf/core.

- Arnaldo

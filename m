Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3ABPL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:11:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab3ABPL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:11:57 -0500
Date: Wed, 2 Jan 2013 16:11:42 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf symbol: Include elf.h header regardless
 LIBELF_SUPPORT
Message-ID: <20130102151141.GF931@krava.brq.redhat.com>
References: <1356679009-32122-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1356679009-32122-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 04:16:49PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The elf.h header file is used for NO_LIBELF build too so it should be
> included anyway.  Also remove duplicated include of the header file in
> symbol-*.c.  This patch fixes following build error on NO_LIBELF build:
> 
>     CC tests/hists_link.o
> tests/hists_link.c: In function ‘setup_fake_machine’:
> tests/hists_link.c:132:8: error: ‘STB_GLOBAL’ undeclared (first use in this function)
> tests/hists_link.c:132:8: note: each undeclared identifier is reported only once for each function it appears in
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Jiri Olsa <jolsa@redhat.com>

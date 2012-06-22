Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762325Ab2FVPTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:19:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53029 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762302Ab2FVPTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:19:09 -0400
Subject: Re: [PATCH 5/8] perf symbols: Do not use ELF's symbol binding
 constants
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
In-Reply-To: <20120622124329.GG17747@infradead.org>
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
	 <1340343462-15556-6-git-send-email-namhyung@kernel.org>
	 <20120622124329.GG17747@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jun 2012 00:19:02 +0900
Message-ID: <1340378342.1478.24.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-06-22 (금), 09:43 -0300, Arnaldo Carvalho de Melo:
> Em Fri, Jun 22, 2012 at 02:37:39PM +0900, Namhyung Kim escreveu:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > There's no need to use the ELF's internal value directly.
> > Define and use our own - it's required to eliminated the
> > dependency of libelf.
> 
> Why don't you set STB_GLOBAL, etc to the expected values when libelf is
> not present? That way no changes need to be made to symbol.c
> 
> Ditto for GELF_ST_BIND.
> 
> I.e. keep the subset of libelf.h that we use, providing those
> definitions on the poor man's libelf.h we should use when the "real
> thing" is not available.
> 

I just tried to be independent to (lib)elf as much as possible. And I
thought that using same macro name might cause a bit of confusion - at
least for me - so I wanted to use more descriptive and generic name.

But it's not a big deal. If you insist on using the same name is the
better way, I can change it.


-- 
Regards,
Namhyung Kim



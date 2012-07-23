Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab2GWSS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:18:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59904 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2GWSS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:18:56 -0400
Date: Mon, 23 Jul 2012 20:18:49 +0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: fix build error
Message-ID: <20120723181849.GF6717@infradead.org>
References: <1343055645-24083-1-git-send-email-kirill@shutemov.name>
 <20120723180244.GB5418@infradead.org>
 <20120723181608.GA24558@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120723181608.GA24558@shutemov.name>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 23, 2012 at 09:16:08PM +0300, Kirill A. Shutemov escreveu:
> On Mon, Jul 23, 2012 at 08:02:44PM +0200, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Jul 23, 2012 at 06:00:44PM +0300, Kirill A. Shutemov escreveu:
> > > util/parse-events.c:29:5: error: redundant redeclaration of ‘parse_events_parse’ [-Werror=redundant-decls]
> > > util/parse-events-bison.h:99:5: note: previous declaration of ‘parse_events_parse’ was here
> > > cc1: all warnings being treated as errors

> > Causes the build to fail for me:

> > cc1: warnings being treated as errors
> > util/parse-events.c: In function ‘parse_events__scanner’:
> > util/parse-events.c:701: error: implicit declaration of function ‘parse_events_parse’
> > util/parse-events.c:701: error: nested extern declaration of ‘parse_events_parse’
> > make: *** [/home/acme/git/build/perf/util/parse-events.o] Error 1
> > make: *** Waiting for unfinished jobs....
> > make: Leaving directory `/home/git/linux/tools/perf'
> 
> What bison version do you have?

[acme@sandy linux]$ rpm -q bison
bison-2.4.1-5.el6.x86_64


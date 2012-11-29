Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2K3QKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:10:07 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60817 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2K3QKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:10:01 -0500
Date: Thu, 29 Nov 2012 16:09:22 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 03/18] perf tools: Keep group information
Message-ID: <20121129190922.GD1957@ghostprotocols.net>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
 <1354171126-14387-5-git-send-email-namhyung@kernel.org>
 <20121129143303.GJ1096@krava.brq.redhat.com>
 <1354201134.1630.41.camel@leonhard>
 <20121129150220.GL1096@krava.brq.redhat.com>
 <1354201751.1630.45.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1354201751.1630.45.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 30, 2012 at 12:09:11AM +0900, Namhyung Kim escreveu:
> 2012-11-29 (목), 16:02 +0100, Jiri Olsa:
> > > You mean adding 'evsel->nr_members > 1' to this function?  For some
> > > reason, I'd like to treat non-group events as group leaders so I dropped
> > > that check from the function.
> > 
> > nope, the change is ok, I meant updating automated tests in tests/parse-events.c
> 
> Ah, okay.  Always forgot to update the test. :(  Will add.

Also consider adding more tests, perhaps for the formatting, i.e.
calling those hpp functions and then checking that the resulting
formatted string is the one expected.

One thing I need to do is to create a test that uses slang to write a
line with callchains and then, without updating the screen, check if
what is buffered to refresh the screen is what we expect, so that we can
check that that '+' char isn't lost like it happened twice :-)

- Arnaldo

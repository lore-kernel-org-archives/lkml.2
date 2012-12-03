Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab2LCBMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 20:12:31 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55611 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2LCBMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 20:12:30 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-c5-50bbfc7b853f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 03/18] perf tools: Keep group information
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
	<1354171126-14387-5-git-send-email-namhyung@kernel.org>
	<20121129143303.GJ1096@krava.brq.redhat.com>
	<1354201134.1630.41.camel@leonhard>
	<20121129150220.GL1096@krava.brq.redhat.com>
	<1354201751.1630.45.camel@leonhard>
	<20121129190922.GD1957@ghostprotocols.net>
Date: Mon, 03 Dec 2012 10:12:27 +0900
In-Reply-To: <20121129190922.GD1957@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Thu, 29 Nov 2012 16:09:22 -0300")
Message-ID: <871uf8ym4k.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Thu, 29 Nov 2012 16:09:22 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 30, 2012 at 12:09:11AM +0900, Namhyung Kim escreveu:
>> 2012-11-29 (목), 16:02 +0100, Jiri Olsa:
>> > > You mean adding 'evsel->nr_members > 1' to this function?  For some
>> > > reason, I'd like to treat non-group events as group leaders so I dropped
>> > > that check from the function.
>> > 
>> > nope, the change is ok, I meant updating automated tests in tests/parse-events.c
>> 
>> Ah, okay.  Always forgot to update the test. :(  Will add.
>
> Also consider adding more tests, perhaps for the formatting, i.e.
> calling those hpp functions and then checking that the resulting
> formatted string is the one expected.
>
> One thing I need to do is to create a test that uses slang to write a
> line with callchains and then, without updating the screen, check if
> what is buffered to refresh the screen is what we expect, so that we can
> check that that '+' char isn't lost like it happened twice :-)

Yep, will try.

Thanks,
Namhyung

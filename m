Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab0HPObA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:31:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:58832 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0HPOa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:30:59 -0400
Subject: Re: [PATCH] perf tools: Don't use brace expansion.
From: Peter Zijlstra <peterz@infradead.org>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1281967761.17267.6.camel@thorin>
References: <20100816124101.1829415C039@msa104.auone-net.jp>
	 <1281967761.17267.6.camel@thorin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 16:30:43 +0200
Message-ID: <1281969043.1926.1469.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 16:09 +0200, Bernd Petrovitsch wrote:

> > -$(shell sh -c 'mkdir -p $(OUTPUT)scripts/{perl,python}/Perf-Trace-Util/' 2> /dev/null)
> > -$(shell sh -c 'mkdir -p $(OUTPUT)util/{ui/browsers,scripting-engines}/' 2> /dev/null)

> The other solution is to use standard-make features like in
> mkdir -p $(foreach d,ui/browsers scripting-engines,$(OUTPUT)util/$(d)/) 2> /dev/null
> 
> Is there actually a specific reason for the 
> $(shell sh -c '...')
> around?
> It looks superflous.

I think the reason is is that nobody who touched that file really knew
make all that well. Your version looks fine to me.

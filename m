Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0HSKcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 06:32:11 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:3577 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524Ab0HSKcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 06:32:09 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o7JAVmxH013328
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
From: Bernd Petrovitsch <bernd@sysprog.at>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100818171917.GH9410@ghostprotocols.net>
References: <20100817181835.GA21083@ghostprotocols.net>
	 <20100818123713.1F02414C03B@msa103.auone-net.jp>
	 <20100818141412.GD9410@ghostprotocols.net>
	 <1282145141.5822.125.camel@thorin>
	 <20100818171917.GH9410@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 12:31:48 +0200
Message-ID: <1282213908.10440.8.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2010-08-18 at 14:19 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Aug 18, 2010 at 05:25:41PM +0200, Bernd Petrovitsch escreveu:
> > On Mit, 2010-08-18 at 11:14 -0300, Arnaldo Carvalho de Melo wrote:
[...]
> > > $(phony feature-tests): 
> > First, this should probably have been:
> > .PHONY: feature-tests
> 
> Humm, isn't $(phony feature-tests): variation valid and shorter, humm,
> yeah, seems to be for !GNU make :-\
> 
> (http://makepp.sourceforge.net/1.18/t_phony.html)

Funny, I didn't knew GNU-make's "$(phony target): " construct.

Hmm, what GNU-make versions and other `make`s are considered (or should
be) supported?

[...]
> There is no use of mktemp in Kbuild, that I try hard to use as reference
> here.

FWIW fine with me - I just threw an idea in.

	Bernd
-- 
mobile: +43 664 4416156              http://www.sysprog.at/
    Linux Software Development, Consulting and Services


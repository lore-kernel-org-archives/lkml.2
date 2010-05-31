Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab0EaXhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:37:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:60400 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab0EaXhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:37:37 -0400
Date: Mon, 31 May 2010 20:37:16 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 1/5] perf stat: add perf stat -B to pretty print large
 numbers
Message-ID: <20100531233716.GB4093@ghostprotocols.net>
References: <1274234900-12162-1-git-send-email-acme@infradead.org>
 <1274234900-12162-2-git-send-email-acme@infradead.org>
 <52092.1275333099@localhost>
 <AANLkTimBxG-2TVC7hAfvRHWupa8T7FaVEcDTnAMCtQWy@mail.gmail.com>
 <77282.1275338942@localhost>
 <20100531231145.GA4093@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531231145.GA4093@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 31, 2010 at 08:11:45PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, May 31, 2010 at 04:49:02PM -0400, Valdis.Kletnieks@vt.edu escreveu:
> > the same places, -B or not -B.  I was sort of expecting that the first
> > example wouldn't have commas in it, or something?  Or were those two
> 
> Right, from a quick read it seems you saw a bug in the changeset and I

Gack, s/in the changeset and/in the changeset comment and/g

> saw none in the patch itself.

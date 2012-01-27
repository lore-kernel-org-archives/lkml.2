Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2A0Ktl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:49:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44435 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2A0Ktj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:49:39 -0500
Message-ID: <1327661364.2446.159.camel@twins>
Subject: Re: Shift by one instruction in the perf annotate output
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?L=E9na=EFc?= Huard <lenaic@lhuard.fr.eu.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Jan 2012 11:49:24 +0100
In-Reply-To: <20120127104442.GB31782@elte.hu>
References: <201201270001.27765.lenaic@lhuard.fr.eu.org>
	 <1327652120.2446.123.camel@twins> <20120127102741.GA31782@elte.hu>
	 <1327660811.2446.155.camel@twins> <20120127104442.GB31782@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 11:44 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Fri, 2012-01-27 at 11:27 +0100, Ingo Molnar wrote:
> >
> > > On Core2 CPUs there's PEBS so 'p' will work, but there's no 
> > > LBR so the IP-rewinding does not work.
> > 
> > Not on his thing.. PEBS is a trainwreck on model 15.
> 
> ok - i have a model 23, there it works:
> 
> [    0.044260] CPU0: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
> [    0.044996] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.

Right, only model 15 the very first core2 chips were badly broken, they
fixed it in the shrink (model 22,23,29).

And as you know, something got screwy in SNB (model 42) so that's got
PEBS fully disabled until further notice as well.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab1F1Qfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:35:48 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:34475 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927Ab1F1QcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:32:24 -0400
Date: Tue, 28 Jun 2011 12:32:06 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Robert Richter <robert.richter@amd.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        "Przywara, Andre" <Andre.Przywara@amd.com>
Subject: Re: [patch] perf_events: even more wrong events for AMD fam10h
In-Reply-To: <20110627155106.GG4590@erda.amd.com>
Message-ID: <alpine.DEB.2.00.1106281230010.3859@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1106071532250.21714@cl320.eecs.utk.edu> <alpine.DEB.2.00.1106071701560.21714@cl320.eecs.utk.edu> <1309173741.6701.104.camel@twins> <20110627155106.GG4590@erda.amd.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011, Robert Richter wrote:

> 
> do you think it is worth to introduce l1-dcache-access?

It could be useful to have.  On PAPI we have the equivelent
PAPI_L1_DCA and all AMD processors support it, as do all
Intel except atom.  POWER does not though, at least not
directly.

Vince
vweaver1@eecs.utk.edu

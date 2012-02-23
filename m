Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab2BWQpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:45:09 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:48667 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2BWQpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:45:07 -0500
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report'
 browser
From: Pekka Enberg <penberg@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20120223163938.GD25177@infradead.org>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
	 <20120223162850.GC25177@infradead.org>
	 <CAOJsxLG2c=Mc-Rn56jmB290LtHpRY8pkfyqPrizgwE8_8+uxFQ@mail.gmail.com>
	 <20120223163938.GD25177@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 23 Feb 2012 18:45:04 +0200
Message-ID: <1330015504.13624.84.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 14:39 -0200, Arnaldo Carvalho de Melo wrote:
> > Dunno, probably. Does that matter, though? It's pretty damn fast as-is.
> 
> Well, what kinds of perf.data file are you feeding it?

It's a real-world case where I'm profiling JRuby startup under Jato with
perf:

penberg@jaguar:~/src/jato$ ls -lh perf.data 
-rw------- 1 penberg penberg 453K 2012-02-23 18:06 perf.data

On Thu, 2012-02-23 at 14:39 -0200, Arnaldo Carvalho de Melo wrote:
> I'm testing it now with large ones, lets see.

How big files are we talking about here?

			Pekka


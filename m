Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab2BWQrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:47:47 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62492 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab2BWQrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:47:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arnaldo.melo@gmail.com designates 10.236.125.130 as permitted sender) smtp.mail=arnaldo.melo@gmail.com; dkim=pass header.i=arnaldo.melo@gmail.com
Date: Thu, 23 Feb 2012 14:47:39 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report'
 browser
Message-ID: <20120223164739.GF25177@infradead.org>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
 <20120223162850.GC25177@infradead.org>
 <CAOJsxLG2c=Mc-Rn56jmB290LtHpRY8pkfyqPrizgwE8_8+uxFQ@mail.gmail.com>
 <20120223163938.GD25177@infradead.org>
 <1330015504.13624.84.camel@jaguar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330015504.13624.84.camel@jaguar>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 23, 2012 at 06:45:04PM +0200, Pekka Enberg escreveu:
> On Thu, 2012-02-23 at 14:39 -0200, Arnaldo Carvalho de Melo wrote:
> > > Dunno, probably. Does that matter, though? It's pretty damn fast as-is.
> > 
> > Well, what kinds of perf.data file are you feeding it?
> 
> It's a real-world case where I'm profiling JRuby startup under Jato with
> perf:
> 
> penberg@jaguar:~/src/jato$ ls -lh perf.data 
> -rw------- 1 penberg penberg 453K 2012-02-23 18:06 perf.data
> 
> On Thu, 2012-02-23 at 14:39 -0200, Arnaldo Carvalho de Melo wrote:
> > I'm testing it now with large ones, lets see.
> 
> How big files are we talking about here?

5 MB ones, say.

But the way you did it is pretty minimalistic, which is good, its just
that I don't really like the idea of having two mirror data structures
representing the report lines.

- Arnaldo

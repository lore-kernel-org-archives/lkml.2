Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab2BWQjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:39:48 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33025 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2BWQjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:39:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arnaldo.melo@gmail.com designates 10.236.170.134 as permitted sender) smtp.mail=arnaldo.melo@gmail.com; dkim=pass header.i=arnaldo.melo@gmail.com
Date: Thu, 23 Feb 2012 14:39:38 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report'
 browser
Message-ID: <20120223163938.GD25177@infradead.org>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
 <20120223162850.GC25177@infradead.org>
 <CAOJsxLG2c=Mc-Rn56jmB290LtHpRY8pkfyqPrizgwE8_8+uxFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLG2c=Mc-Rn56jmB290LtHpRY8pkfyqPrizgwE8_8+uxFQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 23, 2012 at 06:32:41PM +0200, Pekka Enberg escreveu:
> On Thu, Feb 23, 2012 at 6:28 PM, Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> > This is what I avoided by writing a tree widget for the TUI, I really
> > didn't want to traverse _all_ the hists just to show the ones that
> > appear in the screen.
> >
> > Isn't there a way to ask GTK to ask a callback to provide a
> > representation for the Nth hist entry, i.e. just the ones it _needs_ to
> > render the screen?
> 
> Dunno, probably. Does that matter, though? It's pretty damn fast as-is.

Well, what kinds of perf.data file are you feeding it?

I'm testing it now with large ones, lets see.

- Arnaldo

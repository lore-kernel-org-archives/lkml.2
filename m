Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab1ANQto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:49:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:46964 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757650Ab1ANQtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:49:39 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: perf timechart broken
Date: Fri, 14 Jan 2011 17:49:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-18-desktop; KDE/4.5.3; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-perf-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <201101071104.37576.trenn@suse.de> <20110111114951.GA8564@ghostprotocols.net> <20110111145134.GA11968@ghostprotocols.net>
In-Reply-To: <20110111145134.GA11968@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101141749.36716.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 January 2011 15:51:34 Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 11, 2011 at 09:49:51AM -0200, Arnaldo Carvalho de Melo escreveu:
> > Em Tue, Jan 11, 2011 at 09:55:36AM +0100, Thomas Renninger escreveu:
> > > On Tuesday 11 January 2011 02:36:28 Frederic Weisbecker wrote:
> > > > It's too late for .37, but it's fine, we just need to add
> > > > a "Cc: stable@kernel.org" tag in the patch for it to be
> > > > backported.
> > > I'll submit it to stable@ (it wasn't taken because
> > > the patch which included the fix wasn't mainline yet and I
> > > forgot to submit it for 2.6.37-rcX). 
> >  
> > > I can take care of that, but it would be great if someone could look
> > > at the issue that perf timechart shows: "no trace data in the file" in
> > > x86/tip which seems introduced by one of Arnaldo's latest commits.
> > > Reverting some of his latest patches, solved it for me.
> > 
> > Looking at it now.
> 
> Can you try with this patch applied? We need a better way of specifying
> ordering of __exit and __init routines :-\
I tested on x86/tip and it is fixed.
I explicitly reverted your fix and run into it again.

Thanks!

   Thomas

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab1AKLt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:49:59 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39318 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab1AKLt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:49:57 -0500
Date: Tue, 11 Jan 2011 09:49:51 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-perf-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf timechart broken
Message-ID: <20110111114951.GA8564@ghostprotocols.net>
References: <201101071104.37576.trenn@suse.de> <20110111013625.GE2570@nowhere> <201101110955.37560.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101110955.37560.trenn@suse.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 11, 2011 at 09:55:36AM +0100, Thomas Renninger escreveu:
> On Tuesday 11 January 2011 02:36:28 Frederic Weisbecker wrote:
> > It's too late for .37, but it's fine, we just need to add
> > a "Cc: stable@kernel.org" tag in the patch for it to be
> > backported.
> I'll submit it to stable@ (it wasn't taken because
> the patch which included the fix wasn't mainline yet and I
> forgot to submit it for 2.6.37-rcX). 
 
> I can take care of that, but it would be great if someone could look
> at the issue that perf timechart shows: "no trace data in the file" in
> x86/tip which seems introduced by one of Arnaldo's latest commits.
> Reverting some of his latest patches, solved it for me.

Looking at it now.

- Arnaldo

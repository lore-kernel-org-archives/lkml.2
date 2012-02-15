Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab2BOUnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:43:47 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34179 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab2BOUnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:43:45 -0500
Date: Wed, 15 Feb 2012 20:43:38 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
Message-ID: <20120215204338.GA30191@srcf.ucam.org>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com>
 <alpine.LFD.2.02.1202151537500.2794@ionos>
 <20120215145225.GA21448@srcf.ucam.org>
 <alpine.LFD.2.02.1202152059230.2794@ionos>
 <20120215202221.GA29552@srcf.ucam.org>
 <alpine.LFD.2.02.1202152125500.2794@ionos>
 <20120215203814.GA29795@srcf.ucam.org>
 <1329338428.2293.176.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329338428.2293.176.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 09:40:28PM +0100, Peter Zijlstra wrote:
> On Wed, 2012-02-15 at 20:38 +0000, Matthew Garrett wrote:
> > Application authors do seem to have ended up under the belief 
> > that sleep(0) is a meaningful thing to do, and the internet seems to be 
> > full of suggestions to use it rather than sched_yield().
> 
> http://xkcd.com/386/

I'm not even going to pretend to disagree. The question is whether we 
want to support their breakage anyway.
-- 
Matthew Garrett | mjg59@srcf.ucam.org

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab0IHOcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:32:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0IHOcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:32:20 -0400
Date: Wed, 8 Sep 2010 16:32:19 +0200
From: Jan Blunck <jblunck@novell.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org,
        Sven-Thorsten Dietrich <sdietrich@novell.com>,
        Michael Galbraith <MGalbraith@novell.com>
Subject: Re: [RFC 3/4] Disable scheduler tick when we are running
	SCHED_FIFO tasks
Message-ID: <20100908143219.GJ7436@bolzano.suse.de>
References: <1283948964-6418-1-git-send-email-jblunck@suse.de> <1283948964-6418-4-git-send-email-jblunck@suse.de> <1283949814.23762.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283949814.23762.14.camel@laptop>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, Peter Zijlstra wrote:

> On Wed, 2010-09-08 at 14:29 +0200, Jan Blunck wrote:
> > This patch is disabling the scheduler tick to go off when there is a task
> > with SCHED_FIFO policy running. Since these tasks are not timesliced anyway
> > we only care about timers, softirqs and such stuff just like when we disable
> > the tick during idle periods.
> 
> 
> Why only FIFO and not also nr_running == 1?

Lazy Bastard Syndrome

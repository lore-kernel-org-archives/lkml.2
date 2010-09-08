Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab0IHMib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 08:38:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:48003 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab0IHMi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 08:38:28 -0400
Subject: Re: [RFC 1/4] ftrace: Add events for tracing timer interrupts
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Blunck <jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org,
        Sven-Thorsten Dietrich <sdietrich@novell.com>,
        Michael Galbraith <MGalbraith@novell.com>
In-Reply-To: <1283948964-6418-2-git-send-email-jblunck@suse.de>
References: <1283948964-6418-1-git-send-email-jblunck@suse.de>
	 <1283948964-6418-2-git-send-email-jblunck@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Sep 2010 14:38:23 +0200
Message-ID: <1283949503.23762.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 14:29 +0200, Jan Blunck wrote:
> Trace the execution of the timer interrupt. I did not find an argument that
> makes any sense so traces look like this:
> 
> <idle>-0     [000] 181019.693546: timerirq_enter: unused=1
> <idle>-0     [000] 181019.693553: timerirq_exit: unused=1

So what's wrong with the normal IRQ enter/exit tracepoints?

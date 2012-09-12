Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320Ab2ILOaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:30:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:53440 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180Ab2ILOaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:30:15 -0400
Message-ID: <1347460199.15764.37.camel@twins>
Subject: Re: [PATCH 2/2] uprobes: add global breakpoints
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        srikar@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        gdb-patches@sourceware.org
Date: Wed, 12 Sep 2012 16:29:59 +0200
In-Reply-To: <20120912143010.GA1447@redhat.com>
References: <1347377843-16017-1-git-send-email-bigeasy@linutronix.de>
	 <1347377843-16017-2-git-send-email-bigeasy@linutronix.de>
	 <20120912143010.GA1447@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 16:30 +0200, Oleg Nesterov wrote:
> 
> Well, I hoped that someone else will nack^Wreview this patch. You know
> that personally I hate this feature ;) 

I'll try and look at it soon-ish.

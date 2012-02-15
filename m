Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2BOUkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:40:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58172 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab2BOUko convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:40:44 -0500
Message-ID: <1329338428.2293.176.camel@twins>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>
Date: Wed, 15 Feb 2012 21:40:28 +0100
In-Reply-To: <20120215203814.GA29795@srcf.ucam.org>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com>
	 <alpine.LFD.2.02.1202151537500.2794@ionos>
	 <20120215145225.GA21448@srcf.ucam.org>
	 <alpine.LFD.2.02.1202152059230.2794@ionos>
	 <20120215202221.GA29552@srcf.ucam.org>
	 <alpine.LFD.2.02.1202152125500.2794@ionos>
	 <20120215203814.GA29795@srcf.ucam.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 20:38 +0000, Matthew Garrett wrote:
> Application authors do seem to have ended up under the belief 
> that sleep(0) is a meaningful thing to do, and the internet seems to be 
> full of suggestions to use it rather than sched_yield().

http://xkcd.com/386/

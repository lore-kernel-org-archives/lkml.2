Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab2GKVn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:43:29 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41106 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab2GKVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:43:27 -0400
Date: Wed, 11 Jul 2012 14:43:22 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: Re: Add to stable: tracing: change CPU ring buffer state from
 tracing_cpumask
Message-ID: <20120711214322.GB10930@kroah.com>
References: <1341243809.6578.5.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341243809.6578.5.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 11:43:29AM -0400, Steven Rostedt wrote:
> Hi Greg,
> 
> Thomas pointed out that the buffering for tracing (other than function
> tracer - and other "tracers") is not affected by the tracing_cpumask.
> This goes back to 3.0 (and probably before that).
> 
> It's fixed with this commit: 71babb2705e2203a64c27ede13ae3508a0d2c16c
> "tracing: change CPU ring buffer state from tracing_cpumask"
> 
> Which looks to have made it into 3.5-rc1. Can you apply this to all the
> stable trees from 3.0 and beyond.

Applied to 3.0 and 3.4 now.

greg k-h

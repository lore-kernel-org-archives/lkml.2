Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2FNO6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:58:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:55278 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab2FNO6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:58:07 -0400
Message-ID: <1339685880.2559.38.camel@twins>
Subject: Re: [RFC][PATCH 2/4] sched: Push put_prev_task() into
 pick_next_task()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@kernel.org, pjt@google.com, venki@google.com, efault@gmx.de,
        glommer@parallels.com, linux-kernel@vger.kernel.org
Date: Thu, 14 Jun 2012 16:58:00 +0200
In-Reply-To: <1339684321.13377.215.camel@gandalf.stny.rr.com>
References: <20120614132902.800827488@chello.nl>
	 <20120614133212.690691207@chello.nl>
	 <1339684321.13377.215.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 10:32 -0400, Steven Rostedt wrote:
> 
> You remove the call to put_prev_task() which looks to be the only user
> of this static function. But I don't see the deletion of this
> function.
> 
> 
Right you are.. must've overlooked my compiler complaining about this.

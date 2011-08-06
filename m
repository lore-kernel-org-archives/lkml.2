Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab1HFXg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 19:36:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753813Ab1HFXg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 19:36:27 -0400
Date: Sat, 6 Aug 2011 16:38:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] stop_machine: build unconditionally if SMP
Message-Id: <20110806163837.881d70af.akpm@linux-foundation.org>
In-Reply-To: <20110806080323.GB23937@htj.dyndns.org>
References: <1312614073-11516-1-git-send-email-rabin@rab.in>
	<20110806080323.GB23937@htj.dyndns.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Aug 2011 10:03:23 +0200 Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Sat, Aug 06, 2011 at 12:31:13PM +0530, Rabin Vincent wrote:
> > stop_machine() is built for "(SMP && MODULE_UNLOAD) || HOTPLUG_CPU", but
> > is also used by the timekeeping code, the mm code, ftrace, and couple of
> > things in arch/*.  Just build it if we're using SMP, like it's already
> > the case on x86.
> > 
> > Cc: x86@kernel.org
> > Cc: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Rabin Vincent <rabin@rab.in>
> 
> Yeah, looks good to me.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Andrew, can you please route this one?
> 

Sure.

The priority is unclear.  It appears that the patch fixes a build error
under sone circumstances in current mainline?

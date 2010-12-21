Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab0LUBxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:53:18 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:41003 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407Ab0LUBxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:53:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mSgc8WYHYj+pI58caTREn/1vJh2AhWZoqXfqYvDfNQ7ImU+W2UwH2qWXRa2pX9x20L
         kZLEz9cUYwBItHElNrbM1ogAkl4O9c5pfy/wypp72pPwE8OduZ4X6KmQC/VH0/4znCcR
         HmhJtBxv6UzQK/HouHMOqnDOTMlEd3Vohzg+A=
Date: Tue, 21 Dec 2010 02:53:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 00/15] Nohz task support
Message-ID: <20101221015311.GO1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292862951.5021.52.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292862951.5021.52.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 05:35:51PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > Any comments are welcome.
> 
> Not a single patch touches any of the accounting work done by the tick,
> current NO_HZ more is _barely_ sufficient for the nr_running==0 case, it
> definitely needs work for nr_running==1.

I'm not sure what you mean. Is it about timekeeping? Note we keep a cpu to
handle that. Hmm that makes me think, if it goes idle we may be screwed...

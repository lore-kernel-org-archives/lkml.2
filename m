Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1IBNcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 09:32:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49696 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab1IBNcY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 09:32:24 -0400
Subject: Re: [PATCH] x86: perf: Clean up perf_event cpu code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 02 Sep 2011 15:32:06 +0200
In-Reply-To: <1314747665-2090-1-git-send-email-kjwinchester@gmail.com>
References: <1314704115.2799.12.camel@twins>
	 <1314747665-2090-1-git-send-email-kjwinchester@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314970326.1301.16.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 20:41 -0300, Kevin Winchester wrote:
> The CPU support for perf events on x86 was implemented via included C files
> with #ifdefs.  Clean this up by creating a new header file and compiling
> the vendor-specific files as needed.
> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> ---
> 
> This is now against the tip tree.  I left it all as one big commit for now,
> although I can break it up if necessary.  I'm just not sure it would gain much.
> 
> Again, this is by far the largest out of the handful of patches I have ever
> submitted, so please let me know if I am doing anything wrong.
> 

I've stuck it in the queue,. seems to work so far.

If Ingo doesn't complain, it ought to show up for the next release
someplace ;-)

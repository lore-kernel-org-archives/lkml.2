Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1AIWe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:34:29 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52029 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1AIWe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:34:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qiXS0RX8rM7OpN+szBzP3XfJToOLnnhbwiBhiNkeGGfKii3ytWuB7Js5JPicl/8OPF
         92A7lSyhAtCLBrJjUnu8oAOOmhd163o4772TQi1FgCyg56GLsvn2dsGGnd4I09rQtPdA
         tN5oUP3EcG5CM1/VlZ+iQzuA67fRb3MoBcm7A=
Date: Sun, 9 Jan 2011 17:34:23 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED] workqueue: relax lockdep annotation on
 flush_work()
Message-ID: <20110109223423.GA26607@mtj.dyndns.org>
References: <20101229125711.GL488@htj.dyndns.org>
 <1294067685.2016.83.camel@laptop>
 <20110103152017.GV18831@htj.dyndns.org>
 <201101032225.46714.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101032225.46714.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 10:25:46PM +0100, Rafael J. Wysocki wrote:
> On Monday, January 03, 2011, Tejun Heo wrote:
> > On Mon, Jan 03, 2011 at 04:14:45PM +0100, Peter Zijlstra wrote:
> > > > Hmmm?  The code applies the most strict contraints.  If the workqueue
> > > > has a rescuer, flushing another work from the workqueue will always
> > > > trigger lockdep warning.  The rule is relaxed only for workqueues
> > > > which aren't used for memory reclaiming && support parallel execution.
> > > 
> > > Ah, ok. I read it like: if the current thread is a rescue thread.
> > 
> > Ah, I see.  Rafael, can you please verify the updated version is okay
> > too (it should be but just in case)?
> 
> It still appears to be fine.

Applied to wq#fixes-2.6.38 with Tested-by and stable cc added.

Thank you.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab1ACV0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:26:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53900 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592Ab1ACV0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:26:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH UPDATED] workqueue: relax lockdep annotation on flush_work()
Date: Mon, 3 Jan 2011 22:25:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20101229125711.GL488@htj.dyndns.org> <1294067685.2016.83.camel@laptop> <20110103152017.GV18831@htj.dyndns.org>
In-Reply-To: <20110103152017.GV18831@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101032225.46714.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 03, 2011, Tejun Heo wrote:
> On Mon, Jan 03, 2011 at 04:14:45PM +0100, Peter Zijlstra wrote:
> > > Hmmm?  The code applies the most strict contraints.  If the workqueue
> > > has a rescuer, flushing another work from the workqueue will always
> > > trigger lockdep warning.  The rule is relaxed only for workqueues
> > > which aren't used for memory reclaiming && support parallel execution.
> > 
> > Ah, ok. I read it like: if the current thread is a rescue thread.
> 
> Ah, I see.  Rafael, can you please verify the updated version is okay
> too (it should be but just in case)?

It still appears to be fine.

Thanks,
Rafael

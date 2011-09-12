Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1ILLeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 07:34:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46730 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755147Ab1ILLeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 07:34:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18vBiEsvXAvHhB1BtERE7veK9gjeU/bhmSUTIepSb
	FGqdRXTxe6NXmG
Subject: Re: [ANNOUNCE] 3.0.4-rt13
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1315821899.26517.22.camel@twins>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315821899.26517.22.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Sep 2011 13:33:56 +0200
Message-ID: <1315827236.6285.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 12:04 +0200, Peter Zijlstra wrote:
> On Sun, 2011-09-11 at 12:35 +0200, Mike Galbraith wrote:
> > [  134.105291] Pid: 6224, comm: lmsched Not tainted 3.0.4-rt13 #2040
> 
> What's this lmsched thing you're running and where does one get it? I
> can't seem to make it go bang using kernel compiles ;-)

It's a simple model of a realtime simulation executive.. and
non-releasable despite containing no rocket science.  It's a high
priority timer thread synchronizing lower priority workers via ipc.

	-Mike


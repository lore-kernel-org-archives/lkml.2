Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab1IMP2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 11:28:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50546 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754951Ab1IMP2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 11:28:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+pzVR9OGupXYwg9WpYExwzhUqNJNIA/KeBrzNTUv
	XhhhwIN0doQfE9
Subject: Re: [ANNOUNCE] 3.0.4-rt13
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1315926499.5977.19.camel@twins>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 17:28:19 +0200
Message-ID: <1315927699.6445.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 17:08 +0200, Peter Zijlstra wrote:
> On Tue, 2011-09-13 at 15:36 +0200, Peter Zijlstra wrote:
> > Does the below cure things? It breaks !rt builds, but we can cure that
> > if it works..
> 
> n/m its broken like hell..

Since this seems to be a legitimate need for a non-preemptive wakeup,
how about we [re]create one to get rid of abuse?  (otoh, that would add
a branch everywhere.. btdt a couple times, always ended up tossing it)

	-Mike


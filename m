Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2E0LMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 07:12:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53035 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751034Ab2E0LMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 07:12:37 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX183mUc2nnA3+UbZ4cz/Vg4cJxcrybdAE8KtwFbGJ8
	lsSVhn6LBHzPDb
Message-ID: <1338117152.27146.24.camel@marge.simpson.net>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Sun, 27 May 2012 13:12:32 +0200
In-Reply-To: <1338110259.7678.77.camel@marge.simpson.net>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop> <1337865641.9783.149.camel@laptop>
	 <1337926468.5415.48.camel@marge.simpson.net>
	 <1338014259.7302.26.camel@marge.simpson.net>
	 <1338017364.14636.9.camel@twins>
	 <1338020834.7747.8.camel@marge.simpson.net>
	 <1338110259.7678.77.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-27 at 11:17 +0200, Mike Galbraith wrote: 
> On Sat, 2012-05-26 at 10:27 +0200, Mike Galbraith wrote: 
> > Hohum, back to finding out what happened to cpufreq.
> 
> Answer: nothing.. in mainline.

Aha.

http://lkml.indiana.edu/hypermail/linux/kernel/1010.0/00658.html

-Mike


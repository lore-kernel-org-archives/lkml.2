Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab2EYGOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:14:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:44799 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751124Ab2EYGOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:14:32 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX189FFt0XYA9oHTsltUxiKg2tPOb6PIBiik6fAMI5o
	UrpWYoMouB31CV
Message-ID: <1337926468.5415.48.camel@marge.simpson.net>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>
Date: Fri, 25 May 2012 08:14:28 +0200
In-Reply-To: <1337865641.9783.149.camel@laptop>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop> <1337865641.9783.149.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 15:20 +0200, Peter Zijlstra wrote: 
> On Thu, 2012-05-24 at 15:17 +0200, Peter Zijlstra wrote:
> > For power7 with 4 smt it would end up as 1230 I guess.
> 
> One more thing, in light of that, can't you simplify the core stuff to
> be a simple shift as well? map them 123450, does it really matter to
> pair them off like 103254 ?

In my head it does.  Buddies need to be glued together so we can use
them as a team to convert overlap and kick butt on ramp up.

-Mike


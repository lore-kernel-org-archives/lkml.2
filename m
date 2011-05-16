Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab1EPXWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:22:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1697 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab1EPXWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:22:43 -0400
Subject: Re: [PATCH 3/3] checkpatch.pl: Add check for task comm references
From: Joe Perches <joe@perches.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: David Rientjes <rientjes@google.com>, Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, "Ted Ts'o" <tytso@mit.edu>,
        Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <op.vvlj1vad3l0zgt@mnazarewicz-glaptop>
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>
	 <1305580757-13175-4-git-send-email-john.stultz@linaro.org>
	 <op.vvlfaobx3l0zgt@mnazarewicz-glaptop>
	 <alpine.DEB.2.00.1105161431550.4353@chino.kir.corp.google.com>
	 <1305587090.2503.42.camel@Joe-Laptop>
	 <op.vvlj1vad3l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 16:22:41 -0700
Message-ID: <1305588161.2503.46.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 01:11 +0200, Michal Nazarewicz wrote:
> On Tue, 17 May 2011 01:04:50 +0200, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2011-05-16 at 14:34 -0700, David Rientjes wrote:
> >> On Mon, 16 May 2011, Michal Nazarewicz wrote:
> >> > > Now that accessing current->comm needs to be protected,
> >> > > +# check for current->comm usage
> >> > > +		if ($line =~ /\b(?:current|task|tsk|t)\s*->\s*comm\b/) {
> >> > Not a checkpatch.pl expert but as far as I'm concerned, that looks  
> >> reasonable.
> > You don't need (?: just (
> Yep, it's a micro-optimisation though.

True, but it's not the common style in checkpatch.
You could submit patches to add non-capture markers to other () uses.



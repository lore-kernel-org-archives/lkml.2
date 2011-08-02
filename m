Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1HBWG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:06:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50913 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab1HBWGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:06:23 -0400
Date: Wed, 3 Aug 2011 00:06:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Revert needed: udev spewing warnons on common systems in 3.0
Message-ID: <20110802220619.GI27083@one.firstfloor.org>
References: <20110802005206.GA3832@tassilo.jf.intel.com> <20110801183207.cea89a96.akpm@linux-foundation.org> <CA+55aFw=wX1CormdOAnsoK2ruDLp9SaEVh1EcTj8wvt+Kq2gAg@mail.gmail.com> <alpine.DEB.2.00.1108011916480.15596@chino.kir.corp.google.com> <20110802101614.009cdf42@lxorguk.ukuu.org.uk> <alpine.DEB.2.00.1108020249560.18935@chino.kir.corp.google.com> <20110802111117.10a73b89@lxorguk.ukuu.org.uk> <alpine.DEB.2.00.1108021439030.12258@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108021439030.12258@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> All of the examples that I've cited that were fixed as a result of the 
> printk_once() were through bugzilla for the developers of those 
> applications, I didn't talk to any distro when I publically said I would 
> handle all reports of this warning that people didn't know how to triage.

The distros would have updated udev at some point anyways.
But they won't do it for old releases.

But the users who don't want to update will just be annoyed 
(in Linus words) the backtrace forever. 

The big problem I have with your "use kernel WARN_ONs to social engineer"
approach is that the devalues a good mechanism to report kernel 
problems.

Traditionally at least I looked at all backtraces
and tried to get at the bottom of the problem to improve the kernel.
I know from email that users reported those too.

Now that all my test systems spew them on every boot I cannot do 
that anymore. When I see a backtrace scrolling by I now just
think "Ah it's probably David Rientjes trying to social engineer
someone again". 

And then some point noone will look at backtraces anymore because
they have become normal.  Really serious problems will get missed.

And this is a bad thing.  

IMHO still the only sensible thing that can be done with this patch
is to revert it.

-Andi


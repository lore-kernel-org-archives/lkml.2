Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0KSUFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:05:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281Ab0KSUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:05:43 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1011191156470.19579@asgard.lang.hm>
References: <20101116104600.GA24015@suse.de> <20101119191906.GA31760@xanatos>
 <AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com> <alpine.DEB.2.00.1011191156470.19579@asgard.lang.hm>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Nov 2010 12:04:47 -0800
Message-ID: <AANLkTikP5MpT6-WBBfNsP2nK1Cdh=St+nWky_bU9FhSO@mail.gmail.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
To: david@lang.hm
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        w@1wt.eu, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 11:58 AM,  <david@lang.hm> wrote:
>
> how far back do we need to maintain compatibility with userspace?
>
> Is this something that we can revisit in a few years and lock it down then?

The rule is basically "we never break user space".

But the "out" to that rule is that "if nobody notices, it's not
broken". In a few years? Who knows?

So breaking user space is a bit like trees falling in the forest. If
there's nobody around to see it, did it really break?

                   Linus

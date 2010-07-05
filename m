Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0GEV1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 17:27:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53756 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab0GEV1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 17:27:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Marek <mmarek@suse.cz>
Subject: Re: Linux 2.6.35-rc4 - CONFIG_LOCALVERSION ignored?
Date: Mon, 5 Jul 2010 23:25:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
In-Reply-To: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201007052325.56971.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 05, 2010, Linus Torvalds wrote:
> Hey everybody, there's finally a new -rc out there..
> 
> I've been back online for a week, and at least judging by the kinds of
> patches and pull requests I've been getting, I have to say that I
> think that having been strict for -rc3 ended up working out pretty
> well. The diffstat of rc3..rc4 looks quite reasonable, despite the
> longer window between rc's. And while there were certainly some things
> that needed fixing, I'm hoping that we'll have a timely 2.6.35 release
> despite my vacation (my longest time away from the kernel in many
> years, I do believe - I followed email on a cellphone, but did not a
> single kernel compile, and had a great time under water).
> 
> So go out and test -rc4. It fixes a number of regressions, a couple of
> them harking back to from before 2.6.34. Networking, cfq, i915 and
> radeo. And filesystem writeback performance issues, etc. It's all
> good.

Hmm.  Am I dong anything particularly wrong, or is CONFIG_LOCALVERSION ignored
now, as it seems?

Rafael

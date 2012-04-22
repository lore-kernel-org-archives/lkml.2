Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab2DVMQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 08:16:21 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57742 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab2DVMQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 08:16:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw buffering
Date: Sun, 22 Apr 2012 13:47:52 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
References: <1334267969.2573.14.camel@shrek.rexursive.com> <201204182330.38156.rjw@sisk.pl> <161dc918-dabe-4c26-a25b-772498282722@email.android.com>
In-Reply-To: <161dc918-dabe-4c26-a25b-772498282722@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204221347.52883.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 22, 2012, Bojan Smojver wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> >On Wednesday, April 18, 2012, Bojan Smojver wrote:
> >> Per Olofsson <pelle@debian.org> wrote:
> >> 
> >> >OK, let's say Reviewed-by then.
> >> >
> >> >Reviewed-by: Per Olofsson <pelle@debian.org>
> >> >
> >> 
> >> Rafael,
> >> 
> >> Anything you still need here?
> >
> >No, thanks, I'm going to apply the patch.
> >
> >Rafael
> 
> Any chance of it in 3.3.3?

Nope.

> Looks like rc1 of it is already out there...

I'm going to push it for v3.5, so it will only appear in 3.4.y I guess.

Thanks,
Rafael

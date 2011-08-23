Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1HWAaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:30:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62427 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab1HWAan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:30:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110817143728.7abc955b@lxorguk.ukuu.org.uk>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
	<20110817115543.GA8745@redhat.com>
	<20110817130531.GA12204@redhat.com>
	<CAPXgP10A4rcQLht--h1d3PJE=oOrm=MSjGXTUSKVF+ssnkt_gw@mail.gmail.com>
	<20110817143728.7abc955b@lxorguk.ukuu.org.uk>
Date: Mon, 22 Aug 2011 20:30:41 -0400
X-Google-Sender-Auth: od3mjuW-x34E6OQUTXTPE3RUp0A
Message-ID: <CADkLE3U-2Mmq5r=G+tHzz3QZbA78vAFkOPdEO7+uBc-C9MbB8A@mail.gmail.com>
Subject: Re: + prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
 .patch added to -mm tree
From: Colin Walters <walters@verbum.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Oleg Nesterov <oleg@redhat.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 9:37 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> Now I can see why you want to know when processes exit and do it without
> tampering with the process, but it seems to me that's simply a question
> of us lacking a way to do this nicely, whether inotify/dnotify/etc
> on /proc, some kind of 'also signal me' property or some kind of process
> event interface.

Yes please!  The fact that in Unix one can only get notifications of a
process exiting when one is the parent is just lame, and SIGCHLD (like
all signals) sucks.  Lennart was tossing around a "childfd" namespace
proposal...

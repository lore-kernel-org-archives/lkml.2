Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032097Ab2CSRoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:44:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51153 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031242Ab2CSRoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:44:13 -0400
Message-ID: <1332179050.3341.7.camel@joe2Laptop>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: Valdis.Kletnieks@vt.edu
Cc: Jiri Slaby <jirislaby@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 19 Mar 2012 10:44:10 -0700
In-Reply-To: <171703.1332178579@turing-police.cc.vt.edu>
References: <cover.1331856299.git.joe@perches.com>
	 <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
	 <20120319040950.GG31682@thunk.org> <1332131137.23125.44.camel@joe2Laptop>
	 <4F6762F1.7050902@gmail.com> <1332176943.1983.28.camel@joe2Laptop>
	 <171703.1332178579@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 13:36 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 19 Mar 2012 10:09:03 PDT, Joe Perches said:
> > On Mon, 2012-03-19 at 17:46 +0100, Jiri Slaby wrote:
> > > Please stop repeating that shit. I already explained you the reasons. A
> > > couple of weeks ago.
> > I don't quite understand your comment on this
> > subject as git log -i --grep=slaby fs/ext4
> > doesn't show your name.
> > do that currently.  There are no patches from
> > you for ext4 between the patch I sent and now.
> Oh, give us a *break* Joe.  JIri's not allowed to comment on the situation merely
> because he doesn't have an in-flight patch at the moment?

Of course he's allowed to comment.

I just don't understand his comment as anything
other than general grumpiness.

His "explanation" to me was he as far as I can
tell was he didn't like whitespace only changes.

https://lkml.org/lkml/2012/2/27/266

This stuff ain't whitespace.

cheers, Joe


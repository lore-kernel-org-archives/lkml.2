Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab2LUEAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 23:00:37 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:40042 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUEAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 23:00:30 -0500
MIME-Version: 1.0
In-Reply-To: <1356058154.2592.26.camel@localhost>
References: <1356043138.2592.10.camel@localhost> <CA+55aFxGi5qMounLCpJGa7vYxx+O3ho1xVPuHxOg3F24DTu2cg@mail.gmail.com>
 <1356058154.2592.26.camel@localhost>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Dec 2012 20:00:08 -0800
X-Google-Sender-Auth: _n_Uzi8cQrrGQ_ggE68bFgBnen4
Message-ID: <CA+55aFwawpzvxOrOS3mnLqFd2d1f2P_+y9QEXH6640h4qA1y=w@mail.gmail.com>
Subject: Re: [GIT PULL] notification tree changes for 3.8
To: Eric Paris <eparis@redhat.com>
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 6:49 PM, Eric Paris <eparis@redhat.com> wrote:
>
> It is a locking change, but if anything goes wrong, at least I've got
> time without other work commitments over the next 2 weeks to fix them.

That doesn't much help. Because realistically, very few people will be
*testing* over the next two weeks.

Grr.

Ok, so I'll pull, but dammit, this kind of crap has got to stop.
There's *no* reason to start rebasing when the merge window opens, and
then leave it to the last day. Seriously. This bugs the hell out of
me.

            Linus

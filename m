Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965189Ab2I1Xov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:44:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38510 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964990Ab2I1Xot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <1348874861.6858.12.camel@deadeye.wl.decadent.org.uk>
References: <20120928201501.208384923@linuxfoundation.org> <20120928201505.430974605@linuxfoundation.org>
 <1348874861.6858.12.camel@deadeye.wl.decadent.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Sep 2012 16:44:28 -0700
X-Google-Sender-Auth: Hom7dh4-nEhvA_HjDvWFV_KaiyQ
Message-ID: <CA+55aFx1Yg6OKD=dM+B2M9pDwVH__EdzJrDMGvuU=RXvY7qrOw@mail.gmail.com>
Subject: Re: [ 035/218] vfs: make O_PATH file descriptors usable for fstat()
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        =?KOI8-R?B?z8zYx8Egy9LZ1sHOz9fTy8HR?= <olga.kryzhanovska@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 4:27 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>
> The upstream version exchanges fget_light() for fget_raw_light().  Since
> 3.2 (and likewise 3.4) have fget() here, I cherry-picked e994def 'VFS:
> make vfs_fstat() use f[get|put]_light()' before this.  Was that a
> bad/good/neutral idea?

Pretty neutral, I don't think it matters. Doing like greg did and just
doing it with fget_raw() (without the cherry-pick) is fine too.

            Linus

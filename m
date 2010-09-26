Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab0IZNCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 09:02:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60047 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745Ab0IZNCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 09:02:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=IjVhimWDnaLQpf+YexO5Xq6p0TAMX5AcF81/sGlk1/BQo0joBiLbd3t237csBk7G9x
         /Ycv38Ax4Ek+NUEuvFsTud2XK84qgWacKUn7VltbrQ/LwhQ37+7f5P6ekEcmf4TCq5lU
         FScSAE4TRF39rJ6mOS1RbjC9RpxbbIKaRN+wY=
Date: Sun, 26 Sep 2010 15:02:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 1/2] autofs: Only declare function when CONFIG_COMPAT
	is defined
Message-ID: <20100926130230.GA5378@nowhere>
References: <1285334543-7074-1-git-send-regression-fweisbec@gmail.com> <201009251755.57690.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201009251755.57690.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 05:55:57PM +0200, Arnd Bergmann wrote:
> On Friday 24 September 2010 15:22:22 Frederic Weisbecker wrote:
> > From: Márton Németh <nm127@freemail.hu>
> > 
> > The patch solves the following warnings message when CONFIG_COMPAT
> > is not defined:
> > 
> > fs/autofs/root.c:30: warning: ‘autofs_root_compat_ioctl’ declared ‘static’ but never defined
> > 
> > Signed-off-by: Márton Németh <nm127@freemail.hu>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> My initial reaction was to put these into my bkl/vfs tree, but then I noticed
> that they are against a 2.6.36 bug. Who's taking care of getting them upstream?
> 
> - Ian (maintainer)
> - Arnd (who wrote the broken patch to start with)
> - Frederic (who pushed the broken patch to Linus)
> - Andrew (took them into -mm)
> 
> I don't care either way, just trying to make sure it gets there and we don't
> all submit the same patch simultaneously.
> 
> The current state is annoying but harmless, so I could also just add the
> patches to my 2.6.37 queue, which already has autofs patches for the BKL.
> 
> 	Arnd



I think Andrew has taken the autofs one, as I've received an mmotm notification.
I don't know about the autofs4 one though.


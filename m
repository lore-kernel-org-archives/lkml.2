Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266Ab0GPMJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:09:18 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47314 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965049Ab0GPMJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XqvbGWS8AnIJtOpokUtSFXYp+oWUDDB6stl+xIIM7Yh9KTemDKFqzh5VgIuGoFp2OR
         B5akdDUad2PP8Q0mtqxMAJid4eUcqGiEXMAx5sVEmZ/UftBVQpv+nkHiBXmuKos/bZE0
         CiEyzRqzPg8Z6caDd8QMmvjPuH12FfXNYSMtw=
Date: Fri, 16 Jul 2010 14:09:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ian Kent <raven@themaw.net>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "autofs@linux.kernel.org" <autofs@linux.kernel.org>
Subject: Re: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
Message-ID: <20100716120915.GD5377@nowhere>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <AANLkTimVzSzCl2XfWBg5HauYtIT5znxkm6M0yo_1en2b@mail.gmail.com> <1279255230.2968.24.camel@localhost> <201007161305.31291.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007161305.31291.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 01:05:31PM +0200, Arnd Bergmann wrote:
> On Friday 16 July 2010, Ian Kent wrote:
> > On Fri, 2010-07-16 at 02:14 +0200, Frederic Weisbecker wrote:
> > > 2010/7/6 Ian Kent <raven@themaw.net>:
> > > In any case, can we let you handle this patch for 2.6.36 inclusion?
> > 
> > I think it makes more sense to keep these common patches together so
> > Arnd probably should keep it with his series.
> 
> I think that's fine. Takashi Iwai took the alsa patch, but the
> rest can probably be merged together.
> 
> Frederic, would you like to add the remaining ioctl removal series
> into your git tree and have Stephen pull that into linux-next?
> I believe he's still pulling your tree anyway, although it doesn't
> have much content at the moment.
> 
> 	Arnd


Sure, I'll do that next week.

Thanks.


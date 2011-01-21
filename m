Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1AUDXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 22:23:18 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62466 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1AUDXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 22:23:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MKdh7NjMIUMvCByCO3InjyKSJUtk+ZI0kEfI1R3T51nyngT9HeLzD6vQ5O+aTq12gh
         jlcIygDxas5EoLhCrXju509c8jzoV6uYVvfwH8bVg5J51TedJ9iHpuFny3iAsvxZz6Ne
         PCWfr1/s5WfE9WnQY6HV01YbwKERQvIkQq8Lk=
Date: Thu, 20 Jan 2011 22:23:10 -0500
From: nobody <darwinskernel@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: tag&track [Re: Linux 2.6.38-rc1]
Message-ID: <20110121032310.GA28289@WALL-E>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <AANLkTimp0UcWi68N5Jv_hUww9PhGVgCzY0qYLETc8Dj_@mail.gmail.com>
 <1161CC5A-C8CA-477E-B2CE-7870F8E634EE@gmail.com>
 <AANLkTin+Div6HoAJdFOfqRFSMyxqx7ft7mcteXomaV_Y@mail.gmail.com>
 <20110119051049.GA2536@WALL-E>
 <AANLkTikdCek7DGN885Cjuo1nkswe_Y8KG6Knn8XknzsF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikdCek7DGN885Cjuo1nkswe_Y8KG6Knn8XknzsF@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 09:42:42PM -0800, Linus Torvalds wrote:
> On Tue, Jan 18, 2011 at 9:10 PM, nobody <darwinskernel@gmail.com> wrote:
> >
> > i wish i could do that for everything. i am pulling up to 500MiB every
> > -rc cycle and mostly codes for hardwares i don't have.
> 
> No you're not.

... i was lying.

> So no, you're not pulling 500MiB every -rc cycle, unless you're doing
> something stupid like using http (which will trigger a re-fetch, since
> I end up repacking a couple of times a release) or always re-cloning.

re-cloning to reclaim disk space. but disk space is not the only thing;
i can compile a tar release all in ram (1G) but re-cloning 388M into a
build directory there is a no go.


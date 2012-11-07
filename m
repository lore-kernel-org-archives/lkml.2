Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2KGSo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:44:56 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39499 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2KGSoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:44:55 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1210262112370.19184@pobox.suse.cz>
References: <alpine.LNX.2.00.1210262112370.19184@pobox.suse.cz>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 7 Nov 2012 13:44:34 -0500
Message-ID: <CA+1xoqcBx83FmN=0Rt0NGfeWSj8AYVNeFNugDejR4_3=nVXAeA@mail.gmail.com>
Subject: Re: [GIT] floppy
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys!

This is me complaining that I still see the spews that this pull
request should fix, probably because this mail got lost.


Thanks,
Sasha

On Fri, Oct 26, 2012 at 3:15 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> Jens,
>
> please pull from
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git for-jens
>
> into your for-3.7/drivers branch to receive revert of patch that Sasha
> Levin reported to cause NULL pointer dereferences, and it's not necessary.
>
> Thanks!
>
> Jiri Kosina (1):
>       Revert "genhd: Make put_disk() safe for disks that have not been registered"
>
>  block/genhd.c          |    6 +++---
>  drivers/block/floppy.c |   13 +++++++++++++
>  2 files changed, 16 insertions(+), 3 deletions(-)
>
> --
> Jiri Kosina
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

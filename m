Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab1EXPIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:08:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46038 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab1EXPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:08:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jtjIMdv3ZgS9HbQ1xB4YfKA5nVltJDopBz99GAinfLyU0RGoLJ7nPIMtzZqoigNW+Z
         u0yDoMqmWLvlx36i9FrFP/FHFQR1ZD/G3qk+2k/f+pWmCZQ/96cuoIKBR5YESC+m+WSd
         80qUeMbfofm5WIdn8Bvou8L6dzzmy5ASxU+7E=
Subject: Re: [PATCH 2/2] loop: handle on-demand devices correctly
From: Namhyung Kim <namhyung@gmail.com>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1306249314.2838.19.camel@b015126-ux.fr.ad.bull.net>
References: <1306247761-2246-1-git-send-email-namhyung@gmail.com>
	 <1306247761-2246-2-git-send-email-namhyung@gmail.com>
	 <4DDBC4A7.1040104@fusionio.com>  <1306249066.1751.7.camel@leonhard>
	 <1306249314.2838.19.camel@b015126-ux.fr.ad.bull.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 00:08:03 +0900
Message-ID: <1306249683.1751.12.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-05-24 (화), 17:01 +0200, Laurent Vivier:
> Le mardi 24 mai 2011 à 23:57 +0900, Namhyung Kim a écrit :
> > 2011-05-24 (화), 16:45 +0200, Jens Axboe:
> > > Thanks, applied. Seems we should mark this for stable.
> > > 
> > 
> > Hi Jens,
> > 
> > The partition handling was introduced by commit 476a4813cfdd ("loop:
> > manage partitions in disk image") so that we need these patches for all
> > stable releases, AFAICS.
> > 
> > $ git name-rev --tags 476a4813cfdd
> > 476a4813cfdd tags/v2.6.26-rc1~1115^2~9
> > 
> > Now I can see that brd (ramdisk) module seems to have same problems with
> > loop. I'll work on that, too.
> 
> Have a look to nbd.c too.
> 
> Regards,
> Laurent
> 

Hi Laurent,

I'll take a look on that too after looking at brd. Thanks for the
comment.


-- 
Regards,
Namhyung Kim



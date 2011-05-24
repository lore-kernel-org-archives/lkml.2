Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab1EXP3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:29:36 -0400
Received: from odin2.bull.net ([129.184.85.11]:35125 "EHLO odin2.bull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793Ab1EXP3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:29:35 -0400
Subject: Re: [PATCH 2/2] loop: handle on-demand devices correctly
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1306249066.1751.7.camel@leonhard>
References: <1306247761-2246-1-git-send-email-namhyung@gmail.com>
	 <1306247761-2246-2-git-send-email-namhyung@gmail.com>
	 <4DDBC4A7.1040104@fusionio.com>  <1306249066.1751.7.camel@leonhard>
Date: Tue, 24 May 2011 17:01:54 +0200
Message-ID: <1306249314.2838.19.camel@b015126-ux.fr.ad.bull.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on MSGC-003/SRV/BULL(Release 8.5.2FP1|November 29, 2010) at
 24/05/2011 17:01:55,
	Serialize by Router on MSGC-003/SRV/BULL(Release 8.5.2FP1|November 29, 2010) at
 24/05/2011 17:01:55,
	Serialize complete at 24/05/2011 17:01:55
X-TNEFEvaluated: 1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 mai 2011 à 23:57 +0900, Namhyung Kim a écrit :
> 2011-05-24 (화), 16:45 +0200, Jens Axboe:
> > Thanks, applied. Seems we should mark this for stable.
> > 
> 
> Hi Jens,
> 
> The partition handling was introduced by commit 476a4813cfdd ("loop:
> manage partitions in disk image") so that we need these patches for all
> stable releases, AFAICS.
> 
> $ git name-rev --tags 476a4813cfdd
> 476a4813cfdd tags/v2.6.26-rc1~1115^2~9
> 
> Now I can see that brd (ramdisk) module seems to have same problems with
> loop. I'll work on that, too.

Have a look to nbd.c too.

Regards,
Laurent

-- 
------------ Laurent.Vivier@bull.net ------------
"We are the Borg. You will be assimilated. Your 
 biological and technological distinctiveness 
 will be added to our own. Resistance is futile."


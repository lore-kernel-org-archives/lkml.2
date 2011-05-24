Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1EXO5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:57:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42884 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab1EXO5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:57:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ghu5hdnpqTYbDF+pmJ+JC776ou2youOfB/MPjvy+cV0vcVZNeHlHEyFx4rfNQR8wgE
         b7xw5OIoZ4OTmCTHBepua+qQFN4OFisn0ge+RkHbhaSjsF3Ok9qKF4glooWTte5KvIYk
         D2EgeuKlOscZc27LvEFXSrHB0Wqqv+p4e6Lzk=
Subject: Re: [PATCH 2/2] loop: handle on-demand devices correctly
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Vivier <Laurent.Vivier@bull.net>
In-Reply-To: <4DDBC4A7.1040104@fusionio.com>
References: <1306247761-2246-1-git-send-email-namhyung@gmail.com>
	 <1306247761-2246-2-git-send-email-namhyung@gmail.com>
	 <4DDBC4A7.1040104@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 23:57:46 +0900
Message-ID: <1306249066.1751.7.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-05-24 (화), 16:45 +0200, Jens Axboe:
> Thanks, applied. Seems we should mark this for stable.
> 

Hi Jens,

The partition handling was introduced by commit 476a4813cfdd ("loop:
manage partitions in disk image") so that we need these patches for all
stable releases, AFAICS.

$ git name-rev --tags 476a4813cfdd
476a4813cfdd tags/v2.6.26-rc1~1115^2~9

Now I can see that brd (ramdisk) module seems to have same problems with
loop. I'll work on that, too.

Thanks.

-- 
Regards,
Namhyung Kim



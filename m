Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab0I0HFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:05:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51391 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab0I0HFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 03:05:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the bkl-trivial tree with the block tree
Date: Mon, 27 Sep 2010 09:05:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5+; KDE/4.5.1; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20100927144519.25cd3afa.sfr@canb.auug.org.au>
In-Reply-To: <20100927144519.25cd3afa.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009270905.02938.arnd@arndb.de>
X-Provags-ID: V02:K0:ZgyzqhDbMXAiJ/1qfHBSoZ9N7ta7QGaRfAv0wPgNcR2
 4rbgIDfZ3l7mmrV7cwESXB9M9qZ6RT3RYkex9ybjeMEAzBGJsk
 FJyAp7+viD6l1iCOXzhR5nn4Ye3LzalcWy7lav8Xkse+SMWkIh
 MaUx64CzGrVAnigCiSbSyD+yfWBnZspe35ivEII1JavcfNz0xy
 l6MQUWUbF5H11GM06l9AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 September 2010 06:45:19 Stephen Rothwell wrote:
> 
>   #undef DEBUG
>   
> + static DEFINE_MUTEX(ataflop_mutex);
>  -static struct request_queue *floppy_queue;
>   static struct request *fd_request;
>  +static int fdc_queue;
>   
>   /* Disk types: DD, HD, ED */
>   static struct atari_disk_type {

Looks good, thanks!

Vivek, since you are touching that file with other patches, are you interested
in taking the floppy part of my automated block driver BKL removal patch
as well?

I suspect it's possible to come up with a better solution than mine if you
know the code.

	Arnd

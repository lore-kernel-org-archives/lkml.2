Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0LFIlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 03:41:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64639 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab0LFIlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 03:41:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH] autofs4 - remove ioctl mutex
Date: Mon, 6 Dec 2010 09:41:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        autofs mailing list <autofs@linux.kernel.org>
References: <20101206035123.28966.79954.stgit@localhost6.localdomain6>
In-Reply-To: <20101206035123.28966.79954.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012060941.25977.arnd@arndb.de>
X-Provags-ID: V02:K0:1/1kJRSeIeJycXmgWLptO88zhpCSsqfMOx+hW25x0lN
 m0+ZGRoRbdjYPueyRbxm7ZbDM9J+am/8iQMOq3h9RXpiDNG/jJ
 acFTwl6jUO26vwz+2xACOtfNgYTFziZo2MvCtmvXoDPDI+0cme
 xcB4p07HJLYMmyCxcd80FLWRXTWBx0B9sjoyhJ9Ke4gZ8TXm5F
 v2MLLQPyE5mTMit8hVBSQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 December 2010 04:51:23 Ian Kent wrote:
> With the recent changes to remove the BKL a mutex was added to the
> ioctl entry point for calls to the old ioctl interface. This mutex
> needs to be removed because of the need for the expire ioctl to call
> back to the daemon to perform a umount and receive a completion
> status (via another ioctl).
> 
> This should be fine as the new ioctl interface uses much of the same
> code and it has been used without a mutex for around a year without
> issue, as was the original intention.

Acked-by: Arnd Bergmann <arnd@arndb.de>

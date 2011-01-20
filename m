Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1ATSc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:32:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64457 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab1ATSc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:32:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [GIT PATCH] TTY/serial driver movement for .38
Date: Thu, 20 Jan 2011 19:32:51 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.5.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <20110120174910.GA30124@kroah.com>
In-Reply-To: <20110120174910.GA30124@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101201932.51560.arnd@arndb.de>
X-Provags-ID: V02:K0:3ov6S5cnippOPEDr4JRa3FQbxwATJiUnVIu1qK7C9+I
 ZKDXut1sLnaskYHXcxHZ26yxmDjEv2qGWheK7fm15em9+v7kfm
 vH1k2081FvSsvuH3Fd7HYZTJxjXjUILk6ax1EURAAF4f9CEHNO
 KSDubO5vN9/Sp3FiATjGirX8hV/P6XKRVoH+bQ0nAuOMsaSZkv
 XQyLwB2TSRFwleABScUfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 January 2011 18:49:10 Greg KH wrote:
> As mentioned before in previous TTY git pull for .38, here's the big
> movement of the serial drivers into the drivers/tty/ subdirectory that
> needed to wait until after .38-rc1 was out.
> 
> It merely moves the hvc drivers to drivers/tty/hvc/ and the
> drivers/serial/ directory to drivers/tty/serial/ and fixes up the
> MAINTAINERS file to point to the proper locations of the files now that
> they have been moved.

Hi Greg,

Thanks for following up on this!

I noticed that this moves the majority of all the tty drivers, but not
the serial drivers from the drivers/char directory as my original patch
series did. Is that something you still plan to do, or would you like
me to respin that part of my patches for the next merge window?

	Arnd

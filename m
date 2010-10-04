Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0JDI3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:29:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51828 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab0JDI3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:29:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for October 1 (staging/ft1000)
Date: Mon, 4 Oct 2010 10:29:31 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31-19-generic; KDE/4.5.1; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Marek Belisko <marek.belisko@gmail.com>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>
References: <20101001153756.47b52566.sfr@canb.auug.org.au> <20101001154119.ec81d975.randy.dunlap@oracle.com>
In-Reply-To: <20101001154119.ec81d975.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010041029.31249.arnd@arndb.de>
X-Provags-ID: V02:K0:sjYXmN2RZWDesnUjTwYoKoy8E4DDURmaj2MTVfe6H2R
 Hn7SQD1fsE9Pk7LShgn8eAJ8zP52lsU1N+ZWZ2jj01Hxw30pkN
 gs/zmGvXTPItz9EplHjCDhWM2PxRlexhO+te8ZPCgr2MRNaELS
 NhgKlI/B1RV9/57PLKartHKLbVTTjUtX4pFZAvmM0K4TeXzYly
 8hMrDBSm45SqzmlAYNdcw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 October 2010 00:41:19 Randy Dunlap wrote:
> On Fri, 1 Oct 2010 15:37:56 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100930:
> 
> 
> drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c:84: warning: initialization from incompatible pointer type
> drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c:880: warning: the frame size of 2064 bytes is larger than 2048 bytes
> 

I already sent a patch for this

	Arnd

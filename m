Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab0EXPbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 11:31:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54058 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab0EXPbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 11:31:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 2/3] Rename ramzswap to zram in code.
Date: Mon, 24 May 2010 17:31:30 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00202-gac5d593; KDE/4.4.2; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1274710685-2351-1-git-send-email-ngupta@vflare.org> <1274710685-2351-3-git-send-email-ngupta@vflare.org>
In-Reply-To: <1274710685-2351-3-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005241731.31048.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+yYZPHeHHrlGwYOfRKctwD1icutbaFRFPAt+f
 ePn3lnGlJ8ZMENMiLzFWiYS2BAoJdi7N8zR9iMOhfIvy9cAWad
 pMLlH0a3/V9qgSfwDdDGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 May 2010 16:18:04 Nitin Gupta wrote:
> Rename ramzswap to zram in code and also rename
> files accordingly.
> 
> Automated renames in code:
>  - rzs* -> zram*
>  - ramzswap* -> zram*
>  - RZS -> ZRAM*

When renaming files, the -M option to git-format-patch
helps making the patch more reviewable.

	Arnd

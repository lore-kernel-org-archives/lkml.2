Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1HQVKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 17:10:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38701 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1HQVKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 17:10:35 -0400
Date: Thu, 18 Aug 2011 00:08:21 +0300
From: Dan Carpenter <error27@gmail.com>
To: Akshay Joshi <me@akshayjoshi.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@kernel.org>,
        Karthigan Srinivasan <karthigan.srinivasan2@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] Staging: Winbond: Convert C99 style comments in
 Winbond.
Message-ID: <20110817210821.GB4786@shale.localdomain>
References: <4E4B54A4.4040203@kernel.org>
 <1313608515-14033-1-git-send-email-me@akshayjoshi.com>
 <CAOJpy9u669cEs2xvMw2ok=Jc+pC0YtV7R3-sk=eEnhO3z0irzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJpy9u669cEs2xvMw2ok=Jc+pC0YtV7R3-sk=eEnhO3z0irzw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 03:17:01PM -0400, Akshay Joshi wrote:
> This updated patch should fix the comment concerns.
> 
> Pekka, I did compile-test it, but it slipped through since the comment
> was followed by another comment and not a line of code.
> 

It compiles correctly, but there is a gcc warning:

  CC [M]  drivers/staging/winbond/mds.o
  In file included from drivers/staging/winbond/wbhal.h:361:0,
		   from drivers/staging/winbond/mds_f.h:4,
		   from drivers/staging/winbond/mds.c:1:
	drivers/staging/winbond/wb35rx_s.h:2:1: warning: "/*" within comment
	drivers/staging/winbond/wb35rx_s.h:3:1: warning: "/*" within comment
	drivers/staging/winbond/wb35rx_s.h:5:1: warning: "/*" within comment

That's with gcc 4.5.1-4.

regards,
dan carpenter

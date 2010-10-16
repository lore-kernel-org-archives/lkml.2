Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab0JPXLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 19:11:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43862 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab0JPXLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 19:11:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=iMNoDg4cq5bcx8cfzhpY+sLQx9M300EoCrXcZN7fTsOAiYrV3Pqdb2P7qn18RMXbAh
         qKZhu6u0NOlHURH9KViyQRVtQ93okDXfZxP+A+A1Vekp6JKX1TA/xnaJjdFb9SYBKsdk
         4KYyGAi/m4E9hYL+nIgU5R+JzwGHiZQR7vKUk=
MIME-Version: 1.0
In-Reply-To: <20101016230129.GA21304@void.printf.net>
References: <20100827203639.GT23079@void.printf.net> <1287263976-9578-1-git-send-email-vapier@gentoo.org>
 <20101016230129.GA21304@void.printf.net>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 16 Oct 2010 19:11:21 -0400
X-Google-Sender-Auth: 0dxQl9k81Qt9p3uro3n-4TQT0IA
Message-ID: <AANLkTikpjGaz9vuw8Sp+zGSiihmHHYyvxxS031xH3KMH@mail.gmail.com>
Subject: Re: [PATCH] MMC:mmc_spi: Recover from CRC error for SD read/write
 operation over SPI.
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <avorontsov@mvista.com>,
        Ernst Schwab <eschwab@online.de>, Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 19:01, Chris Ball wrote:
> On Sat, Oct 16, 2010 at 05:19:36PM -0400, Mike Frysinger wrote:
>> Andrew: we posted this months ago with no feedback ... could you pick it up ?
>
> Sorry, my fault for missing this -- I've pushed it to mmc-next now,
> with minor language changes.

np.  thanks !
-mike

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137Ab1FWWv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:51:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35447 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760115Ab1FWWvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=S0WO3qTCPdZw+MDAb7hMbxM3erMT+DJgn6k4askI0ssW7eKPita63uCCDOdQ5zNuQd
         rgHIGhbJmpkyg3Z/jdnmAzRLTq3CJy85ejhUdZHqG5zfvutWzDHNt7jWN1Xg7l2qCZ99
         8ske+wZtMwT7MXVHMc+3y+yAN5gtFTQGKizhc=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1106240032560.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net> <alpine.LNX.2.00.1106240032560.17688@swampdragon.chaosbits.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 23 Jun 2011 18:51:04 -0400
Message-ID: <BANLkTi=FAvr7nmRdKv6Ta5zvSJ82SeK0QA@mail.gmail.com>
Subject: Re: [PATCH 18/37] Remove unneeded version.h includes from drivers/video/
To: Jesper Juhl <jj@chaosbits.net>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Richard Purdie <rpurdie@rpsys.net>, Paul Mundt <lethal@linux-sh.org>,
        device-drivers-devel@blackfin.uclinux.org, linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 18:35, Jesper Juhl wrote:
>  drivers/video/backlight/adp8860_bl.c |    1 -
>  drivers/video/backlight/adp8870_bl.c |    1 -

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike

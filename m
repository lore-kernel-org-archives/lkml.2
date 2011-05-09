Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab1EIGA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 02:00:57 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:36243 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab1EIGAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 02:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Wkb3noGdOlWzB4TPwg3h+5VbuKlmuv7ZjLbYQGIBq9+Gza6+2b28KQKMLVtWuRvgaw
         BkcEI3Do0J48V+0WOEoMmuusq+XQZ9fFBk59sqJnj0Yjkwe5M8QZNxxZJ1BueKwQ4Tt3
         uch2ZpsK3Two700+IahshIj5hOwelyq0Kq4ao=
Date: Sun, 8 May 2011 23:00:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-input@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Atari input patches
Message-ID: <20110509060048.GA27577@core.coreip.homeip.net>
References: <1304846247-12401-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304846247-12401-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Sun, May 08, 2011 at 11:17:24AM +0200, Geert Uytterhoeven wrote:
> 	Hi Dmitry,
> 
> Here are 3 patches to fix keyboard and mouse on Atari, after conversion to
> the "new" (several years old) input framework.
> 
>   [1/3] input/atari: Use the correct mouse interrupt hook
>   [2/3] input/atari: Fix atarimouse init
>   [3/3] input/atari: Fix mouse movement and button mapping
> 
> Will you take them for 2.6.40, or can I get them in through my m68k tree?

I can either take them or you can push them. I do not really have a
preference. There is nothing in my tree that would conflict with these
as far as I know.

Thanks.

-- 
Dmitry

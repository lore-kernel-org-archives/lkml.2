Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853Ab0EPEUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 00:20:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34247 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0EPEUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 00:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KykJx0/RiZMXYORfhijSB6tTH8NcVLA6mYjycIt2zZGaNlNt/jxjM3pPTqcgM8cWKi
         dWYRnPAZrtp+d6n7kUQDQ7o4fTjSydWSZ4b6TZxY4Y5x0WzQVJ8Y96li8C1s0IUvVCcn
         dBCBaE1pJpAs1Ch/os89RUgyHkkezMvDEvVto=
MIME-Version: 1.0
In-Reply-To: <1273740861-1900-1-git-send-email-ngupta@vflare.org>
References: <1273740861-1900-1-git-send-email-ngupta@vflare.org>
Date: Sun, 16 May 2010 13:20:44 +0900
Message-ID: <AANLkTilmMKWbnVjbSIp-owEG1wUsARdg8SvpoEjJNUJY@mail.gmail.com>
Subject: Re: [PATCH] ramzswap: Remove backing swap support
From: Minchan Kim <minchan.kim@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Nitin.

First of all, I am sorry for not review your code.
Now, I am too busy to review your code.

When you send the patch which notify free from swap slot,
I thought it's good except one.

One thing was about naming.
Now block device operations has field naming swap_xxx_notify
(I am not sure exact name). My concern was it's very specific about swap.
So I thought we would be better to more abstract name.

I thought trim like naming as Linus said.

Anyway, I will review again at next week if it isn't merged
linux-next(or linux-mm ?? which is right?). That's because I have a
interest in your good ramzswap. :)

Sorry for late response.
See you soon.

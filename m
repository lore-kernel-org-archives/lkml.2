Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0H0Fv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 01:51:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48810 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab0H0FvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 01:51:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=xNEPCNP710DT5D8e/8vgrCfmoI1eGFJfQEzGD6nD/B/DSUwTPE/CNNVlSYwXmEEBIp
         IVJc+fOt4pSOZ2tYQE5tG8b/J2cD/H/VZUEaktBLFTCm6GtDJ/LkxAt5Sb3smBZcVfwO
         UC2mR5FZY2gC3mA//VLUjc0Q5q8tg4MsRWH5I=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] UCB1400: Pass ucb1400-gpio data through ac97 bus
Date: Fri, 27 Aug 2010 07:50:37 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, dtor@mail.ru,
        adobriyan@gmail.com, tj@kernel.org, Eric Miao <eric.y.miao@gmail.com>
References: <1281327394-6716-1-git-send-email-marek.vasut@gmail.com> <201008090643.14777.marek.vasut@gmail.com> <20100826160736.747f3717.akpm@linux-foundation.org>
In-Reply-To: <20100826160736.747f3717.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008270750.38118.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Pá 27. srpna 2010 01:07:36 Andrew Morton napsal(a):
> On Mon, 9 Aug 2010 06:43:14 +0200
> 
> Marek Vasut <marek.vasut@gmail.com> wrote:
> > Dne Po 9. srpna 2010 06:16:34 Marek Vasut napsal(a):
> > > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> 
> Please don't send unchangelogged patches.

Unchangelogged? What do you mean ?
> 
> The title tells us what the patch does but provides no hint as to why
> it does it.
> 
> > > ---
> > > 
> > >  drivers/gpio/ucb1400_gpio.c |   19 ++++++-------------
> > >  drivers/mfd/ucb1400_core.c  |    5 +++++
> > >  include/linux/ucb1400.h     |   19 ++++++-------------
> > >  3 files changed, 17 insertions(+), 26 deletions(-)
> > 
> > Ah right, guys, if possible, let this go through Eric Miao's tree (as I
> > have changes that depend on this). Thanks!
> 
> He's probably unaware of the patch.  Let's cc him.

I have this one in my tree and I sent it to Eric as a part of larger patchset. I 
just wanted to add your Ack eventually.

Cheers

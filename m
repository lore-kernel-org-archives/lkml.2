Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab2FFEwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:52:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60298 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab2FFEwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:52:32 -0400
MIME-Version: 1.0
In-Reply-To: <1338955977.2760.3603.camel@edumazet-glaptop>
References: <alpine.DEB.2.01.1206041546070.5568@trent.utfs.org>
	<20120606010255.GA9991@mcarlson.broadcom.com>
	<CABawtvPE_xuamH2ysL8x0WsJMXdFV5oXPrWjMT-EC-DF_kCxxw@mail.gmail.com>
	<20120606021436.GA10714@mcarlson.broadcom.com>
	<CABawtvNVKkxAgrQqJS7FJGoswQ9ZVyJcHcNwbSJQk4yscTn8gw@mail.gmail.com>
	<1338955977.2760.3603.camel@edumazet-glaptop>
Date: Wed, 6 Jun 2012 12:52:32 +0800
Message-ID: <CABawtvOBJQ-oajFQmviOdgKCub-4n06kRW+x7nE2uyiWnoky9Q@mail.gmail.com>
Subject: Re: tg3: transmit timed out, resetting
From: ethan zhao <ethan.kernel@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Matt Carlson <mcarlson@broadcom.com>,
        Christian Kujau <lists@nerdbynature.de>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,
  That is ask for confirmation from Matt Carlson of Broadcom.

Ethan

On Wed, Jun 6, 2012 at 12:12 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Wed, 2012-06-06 at 10:29 +0800, ethan zhao wrote:
>> So no way to fix it via firmware update or Linux driver ? :<
>
> Yes, but you need to cooperate, or else it might take more time than
> necessary.
>
> Asking questions like that on lkml is not going to help very much.
>
> So, once again, we kindly ask you try a recent kernel and post
> register dump and some additional information when transmit timeouts
> happen.
>
> The 'latest kernel' is either linux-3.5.rc1, or one of David Miller
> tree :
>
> http://git.kernel.org/?p=linux/kernel/git/davem/net-next.git;a=summary
>
> or
>
> http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=summary
>
> Thanks
>
>

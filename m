Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2FFENJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:13:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47925 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2FFENG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:13:06 -0400
Subject: Re: tg3: transmit timed out, resetting
From: Eric Dumazet <eric.dumazet@gmail.com>
To: ethan zhao <ethan.kernel@gmail.com>
Cc: Matt Carlson <mcarlson@broadcom.com>,
        Christian Kujau <lists@nerdbynature.de>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
In-Reply-To: <CABawtvNVKkxAgrQqJS7FJGoswQ9ZVyJcHcNwbSJQk4yscTn8gw@mail.gmail.com>
References: <alpine.DEB.2.01.1206041546070.5568@trent.utfs.org>
	 <20120606010255.GA9991@mcarlson.broadcom.com>
	 <CABawtvPE_xuamH2ysL8x0WsJMXdFV5oXPrWjMT-EC-DF_kCxxw@mail.gmail.com>
	 <20120606021436.GA10714@mcarlson.broadcom.com>
	 <CABawtvNVKkxAgrQqJS7FJGoswQ9ZVyJcHcNwbSJQk4yscTn8gw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 06:12:57 +0200
Message-ID: <1338955977.2760.3603.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 10:29 +0800, ethan zhao wrote:
> So no way to fix it via firmware update or Linux driver ? :<

Yes, but you need to cooperate, or else it might take more time than
necessary.

Asking questions like that on lkml is not going to help very much.

So, once again, we kindly ask you try a recent kernel and post
register dump and some additional information when transmit timeouts
happen.

The 'latest kernel' is either linux-3.5.rc1, or one of David Miller
tree :

http://git.kernel.org/?p=linux/kernel/git/davem/net-next.git;a=summary

or

http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=summary

Thanks



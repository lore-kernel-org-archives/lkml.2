Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab1D3SyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 14:54:20 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44299 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1D3SyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 14:54:17 -0400
Date: Sat, 30 Apr 2011 20:54:05 +0200
From: Florian Mickler <florian@mickler.org>
To: mchehab@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, crope@iki.fi,
        tvboxspy@gmail.com
Subject: Re: [PATCH 0/5] get rid of on-stack dma buffers (part1)
Message-ID: <20110430205405.4beb7d33@schatten.dmk.lab>
In-Reply-To: <1300657852-29318-1-git-send-email-florian@mickler.org>
References: <1300657852-29318-1-git-send-email-florian@mickler.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro!

I just saw that you picked up some patches of mine. What about these?
These are actually tested...

Regards,
Flo

 On Sun, 20 Mar 2011 22:50:47 +0100
Florian Mickler <florian@mickler.org> wrote:

> Hi Mauro!
> 
> These are the patches which got tested already and 
> should be good to go. [first batch of patches]
> 
> I have another batch with updated patches (dib0700, gp8psk, vp702x)
> where I did some more extensive changes to use preallocated memory.
> And a small update to the vp7045 patch.
> 
> Third batch are the patches to opera1, m920x, dw2102, friio,
> a800 which I left as is, for the time beeing. 
> Regards,
> Flo
> 
> Florian Mickler (5):
>   [media] ec168: get rid of on-stack dma buffers
>   [media] ce6230: get rid of on-stack dma buffer
>   [media] au6610: get rid of on-stack dma buffer
>   [media] lmedm04: correct indentation
>   [media] lmedm04: get rid of on-stack dma buffers
> 
>  drivers/media/dvb/dvb-usb/au6610.c  |   22 ++++++++++++++++------
>  drivers/media/dvb/dvb-usb/ce6230.c  |   11 +++++++++--
>  drivers/media/dvb/dvb-usb/ec168.c   |   18 +++++++++++++++---
>  drivers/media/dvb/dvb-usb/lmedm04.c |   35 +++++++++++++++++++++++------------
>  4 files changed, 63 insertions(+), 23 deletions(-)
> 

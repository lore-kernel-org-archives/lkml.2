Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175Ab0FKMIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 08:08:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45497 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754663Ab0FKMID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 08:08:03 -0400
Date: Fri, 11 Jun 2010 13:16:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?ISO-8859-14?B?TOFzemzz?= Monda <laci@monda.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Hardcore trashing without any swap
Message-ID: <20100611131652.053afebd@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTil0M_2aiRX5IoMzC90O9WgzJPco3arHmDSG_44H@mail.gmail.com>
References: <AANLkTil0M_2aiRX5IoMzC90O9WgzJPco3arHmDSG_44H@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 02:10:33 +0200
László Monda <laci@monda.hu> wrote:

> Hi List,
> 
> The problem I'm facing with is very simple, yet extremely irritating
> in nature.  I have a laptop with 4G RAM and I don't use any swap.
> Whenever the RAM is full my system keeps trashing.  This makes X and
> SSH completely unresponsive for about a hour then a bunch of processes
> gets killed and it's usable again.
> 
> How is possible that my system is trashing even though I don't use any swap?

Because you don't have any swap. Its having to dump stuff it doesn't want
to like bits of applications that it can retrieve back from disk.

> I'd expect the kernel to immediately kill the largest process without
> any trashing so I could continue my work right after the event.  How
> is it possible to configure?

It isn't.

However if you want to avoid overcommit and thrashing play with 

/proc/sys/vm/overcommit*

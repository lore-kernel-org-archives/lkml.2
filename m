Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0HXKGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:06:43 -0400
Received: from ist.d-labs.de ([213.239.218.44]:42305 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab0HXKGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:06:40 -0400
Date: Tue, 24 Aug 2010 12:06:13 +0200
From: Florian Mickler <florian@mickler.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Please add generic support for root=UUID= at kernel parameter
 command line (LABEL, BYID maybe also)
Message-ID: <20100824120613.2ad7364a@schatten.dmk.lab>
In-Reply-To: <4C72D5E3.7070203@zytor.com>
References: <4C728145.4030808@Free.fr>
	<20100823220506.7248c51b@schatten.dmk.lab>
	<4C72D5E3.7070203@zytor.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 13:11:15 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 08/23/2010 01:05 PM, Florian Mickler wrote:
> > 
> > I'm not exactly shure, but isn't the search command in grub2 what you
> > want?
> > 
> > http://forums.linuxmint.com/viewtopic.php?f=46&t=38599
> > 
> > You can let grub2 figure out which drive is which and pass the right
> > devices to the kernel...
> > 
> 
> Fantastic!   So when grub2's idea of device naming doesn't match what
> the kernel ends up with, it will cause all kinds of odd failures.
> 
> This really needs to be done by Linux.  As far as doing this stuff in
> the kernel, one of the major motivations for klibc was to be able to do
> this kind of stuff without having to have people write kernel code, but
> klibc integrated into the kernel build didn't get enough support to
> actually make it in -- it still exists and is maintained as a standalone
> system, and it's possible to write a very small initramfs with it.
> 
> 	-hpa

hehe, indeed. I didn't think it through :) 


